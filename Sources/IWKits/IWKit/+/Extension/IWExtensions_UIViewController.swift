//  Created by iWw on 2018/3/18.
//  Copyright © 2018年 iWe. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit

public protocol _IWViewControllerExtension: class {
    static var className: String { get }
}

public extension _IWViewControllerExtension {
    static var className: String {
        return "\(self)"
    }
}

extension UIViewController: _IWViewControllerExtension { }

public extension _IWViewControllerExtension where Self: UIViewController {
    
    public var shouldUsePop: Bool {
        if let controllers = self.navigationController?.viewControllers, controllers.count > 1 {
            if controllers[safe: controllers.count - 1] == self {
                // push
                return true
            }
        }
        return false
    }
    
    public var shouldUseDimiss: Bool {
        if let controllers = self.navigationController?.viewControllers, controllers.count > 1 {
            return false
        } else {
            return true
        }
    }
    
    /// NavigationBar is hidden?
    /// (导航栏是否隐藏).
    var isNavigationBarHidden: Bool {
        get {
            if let navBar = self.navigationController?.navigationBar {
                return navBar.isHidden
            }
            return false
        }
        set {
            iw.queue.main {
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
            return self.navigationController!.navigationBar.height + CGFloat.statusBarHeight
        }
        return CGFloat.statusBarHeight
    }
}


// MAKR:- Function
public extension _IWViewControllerExtension where Self: UIViewController {
    
    /// (从 xib 初始化 UIViewController).
    ///
    ///     xib 内容为 UIView;
    ///     File's Owner 为 UIViewController 的类, 然后将其 view 关联至 xib的view中即可
    public static func initFromXib(xibName: String? = nil) -> Self {
        let name = xibName ?? "\(self)"
        let ret = self.init(nibName: "\(name)", bundle: Bundle.main)
        return ret
    }
    
    /// Show navigationBar.
    /// (显示导航栏).
    func showNavigationBar() -> Void {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.isHidden = false
    }
    /// Hide navgationBar.
    /// (隐藏导航栏).
    func hideNavigationBar() -> Void {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // Use these func, must set key: 'View controller-based status bar appearance and value': 'No' to "Info.plist"
    /// StatusBar Black.
    public func useBlackStyleWithStatusBar() -> Void {
        UIApplication.shared.statusBarStyle = .default
    }
    /// StatusBar White.
    public func useWhiteStyleWithStatusBar() -> Void {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    /// Return UIBarButtonItem.
    /// (返回一个 UIBarButtonItem).
    func barButtomItem(_ title: String?, target: Any?, action: Selector?) -> UIBarButtonItem {
        let btn = UIBarButtonItem(title: title, style: .plain, target: target, action: action)
        btn.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)], for: .normal)
        return btn
    }
    
    /// Add one UIBarButtonItem to leftBarButtonItem.
    /// (添加一个 UIBarButtonItem 到 leftBarButtonItem).
    func setupLeftBarButtonItem(_ title: String, target: Any?, action: Selector?) {
        if self.navigationController == nil {
            iPrint("The navigation controller is nil.")
            return
        }
        self.navigationItem.leftBarButtonItem = barButtomItem(title, target: target, action: action)
    }
    
    /// Add one UIBarButtonItem to rightBarButtonItem.
    /// (添加一个 UIBarButtonItem 到 rightBarButtonItem).
    func setupRightBarButtomItem(_ title: String, target: Any?, action: Selector?) {
        if self.navigationController == nil {
            iPrint("The navigation controller is nil.")
            return
        }
        self.navigationItem.rightBarButtonItem = barButtomItem(title, target: target, action: action)
    }
    
    /// Push.
    /// (push to viewController).
    func push(to viewController: UIViewController, _ animated: Bool = true) -> Void {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    /// Auto back previous viewController.
    /// (自动识别并处理返回事件).
    func pop(viewControllerWithAnimated animated: Bool = true) {
        backToPreviousController(animated)
    }
    /// Modal/Present.
    /// (modal/present viewController).
    func modal(_ viewController: UIViewController, _ animated: Bool = true) -> Void {
        self.present(viewController, animated: animated, completion: nil)
    }
    /// Auto back previous viewController.
    /// (自动识别并处理返回事件).
    func dismiss(viewControllerWithAnimated animated: Bool = true) {
        backToPreviousController(animated)
    }
    /// Auto back previous viewController.
    /// (自动识别并处理返回事件).
    func backToPreviousController(_ animated: Bool = true) {
        if let controllers = self.navigationController?.viewControllers, controllers.count > 1 {
            if controllers[safe: controllers.count - 1] == self {
                // push
                self.navigationController?.popViewController(animated: animated)
            }
        } else {
            // presnet
            self.dismiss(animated: animated, completion: nil)
        }
    }
    
    /// (截取系统返回按钮协议).
    func interactivePopGestureRecognizer(_ recognizer: UIGestureRecognizerDelegate?) -> Void {
        weak var rec = recognizer
        self.navigationController?.interactivePopGestureRecognizer?.delegate = rec
    }
}

// MARK:- Variable
public extension _IWViewControllerExtension where Self: UIViewController {
    
    /// (self.navigationItem.leftBarButtonItem).
    public var leftBarButtonItem: UIBarButtonItem? {
        get { return self.navigationItem.leftBarButtonItem }
        set { self.navigationItem.leftBarButtonItem = newValue }
    }
    /// (self.navigationItem.rightBarButtonItem).
    public var rightBarButtonItem: UIBarButtonItem? {
        get { return self.navigationItem.rightBarButtonItem }
        set { self.navigationItem.rightBarButtonItem = newValue }
    }
    
    /// (self.navigationItem.leftBarButtonItems).
    public var leftBarButtonItems: [UIBarButtonItem]? {
        get { return self.navigationItem.leftBarButtonItems }
        set { self.navigationItem.leftBarButtonItems = newValue }
    }
    /// (self.navigationItem.rightBarButtonItems).
    public var rightBarButtonItems: [UIBarButtonItem]? {
        get { return self.navigationItem.rightBarButtonItems }
        set { self.navigationItem.rightBarButtonItems = newValue }
    }
    
    /// (self.view.backgroundColor).
    public var backgroundColor: UIColor? {
        get { return self.view.backgroundColor }
        set { self.view.backgroundColor = newValue }
    }
    /// (self.navigationItem.title).
    public var navigationItemTitle: String? {
        get { return self.navigationItem.title }
        set { self.navigationItem.title = newValue }
    }
    /// (self.tabBarItem.badgeValue).
    public var badgeValue: String? {
        get { return self.tabBarItem.badgeValue }
        set { self.tabBarItem.badgeValue = newValue }
    }
    
    /// The view controller is presented?
    /// (返回该控制器是否为 present 进入).
    public var isPresented: Bool {
        var tmpViewController: UIViewController = self
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
    public var isViewLoadedAndVisible: Bool {
        return self.isViewLoaded && (self.view.window != nil)
    }
    
}

#endif
