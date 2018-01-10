//
//  UIViewController+IWViewController.swift
//  haoduobaduo
//
//  Created by iWe on 2017/9/19.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

public extension IWViewController where ViewController: UIViewController {
    
    // Use these func, must set key: 'View controller-based status bar appearance and value': 'No' to "Info.plist"
    /// StatusBar Black.
    func useBlackStyleWithStatusBar() -> Void {
        UIApplication.shared.statusBarStyle = .default
    }
    /// StatusBar White.
    func useWhiteStyleWithStatusBar() -> Void {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    /// Return top ViewController.
    /// (返回当前显示的控制器).
    class func current<T: UIViewController>() -> T? {
        let rootVc = UIApplication.shared.keyWindow?.rootViewController
        let vc = self.find(in: rootVc)
        return vc as? T
    }
    
    /// NavigationBar is hidden?
    /// (导航栏是否隐藏).
    var isNavigationBarHidden: Bool {
        get {
            if let navBar = vc.navigationController?.navigationBar {
                return navBar.isHidden
            }
            return false
        }
        set {
            iw.main.execution {
                if newValue {
                    self.hideNavigationBar()
                } else {
                    self.showNavigationBar()
                }
            }
            
        }
    }
    
    /// NavigationBar height.
    /// (导航栏高度).
    var navigationBarHeight: CGFloat {
        if !isNavigationBarHidden {
            return vc.navigationController!.navigationBar.height + CGFloat.statusBarHeight
        }
        return CGFloat.statusBarHeight
    }
    
    /// Return UIBarButtonItem.
    /// (返回一个 UIBarButtonItem).
    func navItem(_ title: String?, target: Any?, action: Selector?) -> UIBarButtonItem {
        let btn = UIBarButtonItem(title: title, style: .plain, target: target, action: action)
        btn.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)], for: .normal)
        return btn
    }
    
    /// Add one UIBarButtonItem to leftBarButtonItem.
    /// (添加一个 UIBarButtonItem 到 leftBarButtonItem).
    func addLeftNavBtn(_ title: String, target: Any?, action: Selector?) {
        if vc.navigationController == nil {
            iPrint("The navigation controller is nil.")
            return
        }
        vc.navigationItem.leftBarButtonItem = navItem(title, target: target, action: action)
    }
    
    /// Add one UIBarButtonItem to rightBarButtonItem.
    /// (添加一个 UIBarButtonItem 到 rightBarButtonItem).
    func addRightNavBtn(_ title: String, target: Any?, action: Selector?) {
        if vc.navigationController == nil {
            iPrint("The navigation controller is nil.")
            return
        }
        vc.navigationItem.rightBarButtonItem = navItem(title, target: target, action: action)
    }
    
    /// Push.
    /// (push to viewController).
    func push(to viewController: UIViewController, _ animated: Bool = true) -> Void {
        vc.navigationController?.pushViewController(viewController, animated: animated)
    }
    /// Auto back previous viewController.
    /// (自动识别并处理返回事件).
    func pop(viewControllerWithAnimated animated: Bool = true) {
        backToPreviousController(animated)
    }
    /// Modal/Present.
    /// (modal/present viewController).
    func modal(_ viewController: UIViewController, _ animated: Bool = true) -> Void {
        vc.present(viewController, animated: animated, completion: nil)
    }
    /// Auto back previous viewController.
    /// (自动识别并处理返回事件).
    func dismiss(viewControllerWithAnimated animated: Bool = true) {
        backToPreviousController(animated)
    }
    /// Auto back previous viewController.
    /// (自动识别并处理返回事件).
    func close(viewControllerWithAnimated animated: Bool = true) {
        backToPreviousController(animated)
    }
    /// Auto back previous viewController.
    /// (自动识别并处理返回事件).
    func backToPreviousViewController() -> Void {
        backToPreviousController()
    }
    
    /// Show navigationBar.
    /// (显示导航栏).
    func showNavigationBar() -> Void {
        vc.navigationController?.setNavigationBarHidden(false, animated: true)
        vc.navigationController?.navigationBar.isHidden = false
    }
    /// Hide navgationBar.
    /// (隐藏导航栏).
    func hideNavigationBar() -> Void {
        vc.navigationController?.setNavigationBarHidden(true, animated: false)
        vc.navigationController?.navigationBar.isHidden = true
    }
    
    func interactivePopGestureRecognizer(_ recognizer: UIGestureRecognizerDelegate?) -> Void {
        weak var rec = recognizer
        vc.navigationController?.interactivePopGestureRecognizer?.delegate = rec
    }
    /// The view controller is presented?
    /// (返回该控制器是否为 present 进入).
    var isPresented: Bool {
        var tmpViewController: UIViewController = self.vc
        if let navC = tmpViewController.navigationController {
            if navC.viewControllers.first! != tmpViewController {
                return false
            }
            tmpViewController = navC
        }
        return tmpViewController.presentingViewController?.presentedViewController == tmpViewController
    }
    /// view can visible?
    /// (返回该控制器是否可见).
    var isViewLoadedAndVisible: Bool {
        return self.vc.isViewLoaded && (self.vc.view.window != nil)
    }
}

fileprivate extension IWViewController where ViewController: UIViewController {
    
    class func find(in displayController: UIViewController?) -> UIViewController? {
        if displayController != nil {
            if (displayController?.presentedViewController != nil) {
                
                return self.find(in: displayController?.presentedViewController!)
            } else if (displayController?.isKind(of: UISplitViewController.self))! {
                
                let splitVc = displayController as! UISplitViewController
                if splitVc.viewControllers.count > 0 {
                    return self.find(in: splitVc.viewControllers.last)
                }
            } else if (displayController?.isKind(of: UINavigationController.self))! {
                
                let navigationC = displayController as! UINavigationController
                if navigationC.viewControllers.count > 0 {
                    return self.find(in: navigationC.topViewController)
                }
            } else if (displayController?.isKind(of: UITabBarController.self))! {
                
                let tabbarC = displayController as! UITabBarController
                if tabbarC.viewControllers!.count > 0 {
                    return self.find(in: tabbarC.selectedViewController)
                }
            }
            return displayController
        }
        return nil
    }
    
    func backToPreviousController(_ animated: Bool = true) {
        if let controllers = vc.navigationController?.viewControllers, controllers.count > 1 {
            if controllers[safe: controllers.count - 1] == vc {
                // push
                vc.navigationController?.popViewController(animated: animated)
            }
        } else {
            // presnet
            vc.dismiss(animated: animated, completion: nil)
        }
    }
}


