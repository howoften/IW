//  Created by iWe on 2017/6/19.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

/// (UINavigationController 的子类, 相比较拥有更多快捷功能).
public class IWNavController: UINavigationController {
    
    /// (是否在 push 后隐藏返回按钮的标题).
    public static var withoutBackTitleWhenPushed: Bool = false
    
    /// (是否开启向右滑动返回上一个控制器).
    public var isEnableRightSlideToPop: Bool = false {
        willSet {
            iw.queue.main {
                newValue ? self.enableRightSlideToPop() : self.disableRightSlideToPop()
            }
        }
    }
    
    /// 全局手势委托
    private var fullScreenGes: UIPanGestureRecognizer?
    
    /// (UINavigationBar的下划线备份).
    private var shadowImageBackup: UIImageView? = nil
    /// (是否隐藏 UINavigationBar 的下划线).
    public var isHiddenShadowImage: Bool = false {
        willSet {
            if newValue {
                for v: UIView in navigationBar.subviews {
                    let condition = iw.system.version.toInt >= 10 ? v.isKind(of: "_UIBarBackground".toAnyClass!) : v.isKind(of: "_UINavigationBarBackground".toAnyClass!)
                    if condition {
                        for sv: UIView in v.subviews {
                            if sv.height <= 0.5 {
                                shadowImageBackup = (sv as! UIImageView)
                                break
                            }
                        }
                    }
                }
                shadowImageBackup?.isHidden = true
            } else {
                shadowImageBackup?.isHidden = false
            }
        }
    }
    
    /// navigation bar background color.
    /// (背景颜色).
    public var navBackgroundColor: UIColor? {
        willSet {
            if let color = newValue {
                self.navigationBar.barTintColor = color
            }
        }
    }
    
    /// (前景视图颜色: navgation item显示的颜色).
    public var navTintColor: UIColor? {
        willSet {
            if let color = newValue {
                self.navigationBar.tintColor = color
            }
        }
    }
    
    /// (tabbar item 显示的颜色).
    public var tabbarSelectedColor: UIColor? {
        willSet {
            if let color = newValue {
                self.tabBarController?.tabBar.tintColor = color
            }
        }
    }
    
    /// (是否隐藏导航栏).
    public override var isNavigationBarHidden: Bool {
        get { return navigationBar.isHidden }
        set { navigationBar.isHidden = newValue }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        _init()
    }
    
    private func _init() {
        self.navigationBar.isTranslucent = false
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if IWNavController.withoutBackTitleWhenPushed {
            topViewController?.navigationItem.backBarButtonItem = withoutTitleForBackItem()
        }
        (viewController as? IWRootVC)?.isEnterByPush = true
        super.pushViewController(viewController, animated: animated)
        
        // 修复iPhoneX设备上 push 时 tabbar 会上移的 bug, 2018.01.21
        if IWDevice.isiPhoneX, #available(iOS 11.0, *) {
            if var tbframe = self.tabBarController?.tabBar.frame {
                tbframe.origin.y = .screenHeight - tbframe.size.height
                self.tabBarController?.tabBar.frame = tbframe
            }
        }
    }
    
    public override func popViewController(animated: Bool) -> UIViewController? {
        let viewCs = self.viewControllers
        if let preVC = viewCs[safe: viewCs.count - 2] {
            (preVC as? IWRootVC)?.isEnterByPop = true
        }
        return super.popViewController(animated: animated)
    }
}

extension IWNavController: UIGestureRecognizerDelegate {
    
    // MARK:- PUSH后不显示返回按钮的标题
    public func withoutTitleForBackItem() -> UIBarButtonItem {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)], for: .normal)
        return backItem
    }
    
    // MARK:- 任意位置向右滑动返回上一界面
    fileprivate func enableRightSlideToPop() {
        let target = self.interactivePopGestureRecognizer?.delegate
        let handler = NSSelectorFromString("handleNavigationTransition:")
        let targetView = self.interactivePopGestureRecognizer?.view
        fullScreenGes = UIPanGestureRecognizer(target: target, action: handler)
        fullScreenGes!.delegate = self
        targetView?.addGestureRecognizer(fullScreenGes!)
        self.interactivePopGestureRecognizer?.isEnabled = false
    }
    fileprivate func disableRightSlideToPop() {
        self.interactivePopGestureRecognizer?.isEnabled = true
    }
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if isEnableRightSlideToPop {
            let translation = (gestureRecognizer as! UIPanGestureRecognizer).translation(in: gestureRecognizer.view)
            if translation.x <= 0 {
                return false
            }
            return childViewControllers.count == 1 ? false : true
        }
        return false
    }
}


