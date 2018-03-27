//
//  IWFullscreenPopGesture.swift
//  haoduobaduo
//
//  Created by iWw on 2018/3/9.
//  Copyright © 2018年 iWe. All rights reserved.
//

import UIKit

public class IWFullscreenPopGesture: NSObject {
    
    /// (初始化).
    public static func configuration() -> Void {
        UIViewController.viewcFullscreenInit()
        UINavigationController.navFullscreenInit()
    }
    
}

fileprivate class _IWFullscreenPopGestureDelegate: NSObject, UIGestureRecognizerDelegate {
    
    weak var navigationController: UINavigationController?
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        guard let navController = self.navigationController else { return false }
        
        // 忽略没有控制器可以 push 的时候
        guard navController.viewControllers.count > 1 else {
            return false
        }
        
        // 控制器不允许交互弹出时忽略
        guard let topViewController = navController.viewControllers.last, !topViewController.iwe_interactivePopDisabled else {
            return false
        }
        
        if let isTransitioning = navController.value(forKey: "_isTransitioning") as? Bool, isTransitioning {
            return false
        }
        
        guard let panGesture = gestureRecognizer as? UIPanGestureRecognizer else {
            return false
        }
        
        // 始位置超出最大允许初始距离时忽略
        let beginningLocation = panGesture.location(in: gestureRecognizer.view)
        let maxAllowedInitialDistance = topViewController.iwe_interactivePopMaxAllowedInitialDistanceToLeftEdge
        if maxAllowedInitialDistance > 0, beginningLocation.x > maxAllowedInitialDistance { return false }
        
        let translation = panGesture.translation(in: gestureRecognizer.view)
        let isLeftToRight = UIApplication.shared.userInterfaceLayoutDirection == UIUserInterfaceLayoutDirection.leftToRight
        let multiplier: CGFloat = isLeftToRight ? 1 : -1
        if (translation.x * multiplier) <= 0 {
            return false
        }
        return true
    }
    
}


public extension UIViewController {
    
    fileprivate static func viewcFullscreenInit() {
        let appear_originalMethod = class_getInstanceMethod(self, #selector(viewWillAppear(_:)))
        let appear_swizzledMethod = class_getInstanceMethod(self, #selector(iwe_viewWillAppear(_:)))
        method_exchangeImplementations(appear_originalMethod!, appear_swizzledMethod!)
        
        let disappear_originalMethod = class_getInstanceMethod(self, #selector(viewWillDisappear(_:)))
        let disappear_swizzledMethod = class_getInstanceMethod(self, #selector(iwe_viewWillDisappear(animated:)))
        method_exchangeImplementations(disappear_originalMethod!, disappear_swizzledMethod!)
    }
    
    private struct Key {
        static var interactivePopDisabled: Void?
        static var maxAllowedInitialDistance: Void?
        static var prefersNavigationBarHidden: Void?
        static var willAppearInjectBlock: Void?
    }
    
    var iwe_interactivePopDisabled: Bool {
        get { return (objc_getAssociatedObject(self, &Key.interactivePopDisabled) as? Bool) ?? false }
        set { objc_setAssociatedObject(self, &Key.interactivePopDisabled, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
    
    var iwe_interactivePopMaxAllowedInitialDistanceToLeftEdge: CGFloat {
        get { return (objc_getAssociatedObject(self, &Key.maxAllowedInitialDistance) as? CGFloat) ?? 0.00 }
        set { objc_setAssociatedObject(self, &Key.maxAllowedInitialDistance, max(0, newValue), .OBJC_ASSOCIATION_COPY) }
    }
    
    /// (是否隐藏导航栏).
    var iwe_prefersNavigationBarHidden: Bool {
        get {
            guard let bools = objc_getAssociatedObject(self, &Key.prefersNavigationBarHidden) as? Bool  else { return false }
            return bools
        }
        set {
            objc_setAssociatedObject(self, &Key.prefersNavigationBarHidden, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    fileprivate var iwe_willAppearInjectBlock: IWViewControllerWillAppearInjectBlock? {
        get { return objc_getAssociatedObject(self, &Key.willAppearInjectBlock) as? IWViewControllerWillAppearInjectBlock }
        set { objc_setAssociatedObject(self, &Key.willAppearInjectBlock, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    @objc fileprivate func iwe_viewWillAppear(_ animated: Bool) {
        self.iwe_viewWillAppear(animated)
        
        self.iwe_willAppearInjectBlock?(self, animated)
    }
    
    @objc fileprivate func iwe_viewWillDisappear(animated: Bool) {
        self.iwe_viewWillDisappear(animated: animated)

        let vc = self.navigationController?.viewControllers.last

        if vc != nil, vc!.iwe_prefersNavigationBarHidden, !self.iwe_prefersNavigationBarHidden {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }
}

fileprivate typealias IWViewControllerWillAppearInjectBlock = (_ viewController: UIViewController, _ animated: Bool) -> Void

public extension UINavigationController {
    
    fileprivate static func navFullscreenInit() {
        let originalSelector = #selector(pushViewController(_:animated:))
        let swizzledSelector = #selector(iwe_pushViewController(_:animated:))
        
        guard let originalMethod = class_getInstanceMethod(self, originalSelector) else { return }
        guard let swizzledMethod = class_getInstanceMethod(self, swizzledSelector) else { return }
        
        let success = class_addMethod(self.classForCoder(), originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        if success {
            class_replaceMethod(self.classForCoder(), swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    private struct Key {
        static var cmd: Void?
        static var popGestureRecognizerDelegate: Void?
        static var fullscreenPopGestureRecognizer: Void?
        static var viewControllerBasedNavigationBarAppearanceEnabled: Void?
    }
    
    @objc private func iwe_pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.interactivePopGestureRecognizer?.view?.gestureRecognizers?.contains(self.iwe_fullscreenPopGestureRecognizer) == false {
            
            self.interactivePopGestureRecognizer?.view?.addGestureRecognizer(self.iwe_fullscreenPopGestureRecognizer)
            
            guard let internalTargets = self.interactivePopGestureRecognizer?.value(forKey: "targets") as? [NSObject] else { return }
            guard let internalTarget = internalTargets.first!.value(forKey: "target") else { return } //internalTargets?.first?.value(forKey: "target") else { return }
            let internalAction = NSSelectorFromString("handleNavigationTransition:")
            self.iwe_fullscreenPopGestureRecognizer.delegate = self.iwe_popGestureRecognizerDelegate
            self.iwe_fullscreenPopGestureRecognizer.addTarget(internalTarget, action: internalAction)
            
            self.interactivePopGestureRecognizer?.isEnabled = false
        }
        self.iwe_setupViewControllerBasedNavigationBarAppearanceIfNeeded(viewController)
        
        if !self.viewControllers.contains(viewController) {
            self.iwe_pushViewController(viewController, animated: animated)
        }
    }
    
    private func iwe_setupViewControllerBasedNavigationBarAppearanceIfNeeded(_ appearingViewController: UIViewController) -> Void {
        guard self.iwe_viewControllerBasedNavigationBarAppearanceEnabled else {
            return
        }
        
        let block: IWViewControllerWillAppearInjectBlock = { [weak self] (vc, animated) in
            self.unwrapped({ $0.setNavigationBarHidden(vc.iwe_prefersNavigationBarHidden, animated: animated) })
        }
        
        appearingViewController.iwe_willAppearInjectBlock = block
        if let disappearingViewController = self.viewControllers.last, disappearingViewController.iwe_willAppearInjectBlock.isNone {
            disappearingViewController.iwe_willAppearInjectBlock = block
        }
    }
    
    
    private var iwe_fullscreenPopGestureRecognizer: UIPanGestureRecognizer {
        guard let pan = objc_getAssociatedObject(self, &Key.fullscreenPopGestureRecognizer) as? UIPanGestureRecognizer else {
            let pg = UIPanGestureRecognizer()
            pg.maximumNumberOfTouches = 1
            objc_setAssociatedObject(self, &Key.fullscreenPopGestureRecognizer, pg, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return pg
        }
        return pan
    }
    
    private var iwe_popGestureRecognizerDelegate: _IWFullscreenPopGestureDelegate {
        guard let dg = objc_getAssociatedObject(self, &Key.popGestureRecognizerDelegate) as? _IWFullscreenPopGestureDelegate else {
            let popDg = _IWFullscreenPopGestureDelegate()
            popDg.navigationController = self
            objc_setAssociatedObject(self, &Key.popGestureRecognizerDelegate, popDg, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return popDg
        }
        return dg
    }
    
    private var iwe_viewControllerBasedNavigationBarAppearanceEnabled: Bool {
        get {
            guard let nb = objc_getAssociatedObject(self, &Key.viewControllerBasedNavigationBarAppearanceEnabled) as? Bool else {
                self.iwe_viewControllerBasedNavigationBarAppearanceEnabled = true
                return true
            }
            return nb
        }
        set {
            objc_setAssociatedObject(self, &Key.viewControllerBasedNavigationBarAppearanceEnabled, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
}

