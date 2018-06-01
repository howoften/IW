//  Created by iWe on 2017/6/14.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

open class IWRootVC: UIViewController {
    
    /// Hide back item title when pushed.
    public var isHideBackItemTitleWhenPushed: Bool {
        get { return IWNavController.withoutBackTitleWhenPushed }
        set { IWNavController.withoutBackTitleWhenPushed = newValue }
    }
    
    /// View will appear by popViewController.
    public var isEnterByPop: Bool = false
    public var isEnterByPush: Bool = false
    
    /// Auto hide bottom bar when pushed.
    public var isAutoHideBottomBarWhenPushed: Bool = false
    
    /// (指示状态).
    public lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        return indicator
    }()
    /// (在导航栏右侧按钮上显示指示状态).
    public var showActivityIndicatorToNavRightItem: Bool = false {
        didSet {
            if showActivityIndicatorToNavRightItem { self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator) } else {
                self.navigationItem.leftBarButtonItem = nil
            }
        }
    }
    /// (在导航栏左侧按钮上显示指示状态).
    public var showActivityIndicatorToNavLeftItem: Bool = false {
        didSet {
            if showActivityIndicatorToNavLeftItem { self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: activityIndicator) } else {
                self.navigationItem.leftBarButtonItem = nil
            }
        }
    }
    
    /// Navigation item title color.
    public var navTitleColor: UIColor {
        get { return .white }
        set { self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: newValue] }
    }
    
    /// Enable Large Titles.
    /// (开启大标题模式, iOS 11 及以后支持)
    @available(iOS 11, *)
    public var isEnableLargeTitlesStyle: Bool {
        get { return self.navigationController?.navigationBar.prefersLargeTitles ?? false }
        set { self.navigationController?.navigationBar.prefersLargeTitles = newValue }
    }
    
    /// (设置大标题存在方式, 默认为 .Automatic).
    @available(iOS 11, *)
    public var largeTitleDisplayMode: UINavigationItem.LargeTitleDisplayMode {
        get { return self.navigationItem.largeTitleDisplayMode }
        set { self.navigationItem.largeTitleDisplayMode = newValue }
    }
    
    /// (通过 naver 传递的参数).
    public var naverInfo: IWNaverInfo?
    
    public lazy var bottomSpacingBackgroundView: UIView = { [unowned self] in
        let v = UIView(frame: MakeRect(0, .screenHeight - .bottomSpacing, .screenWidth, .bottomSpacing))
        if self.listView != nil {
            v.backgroundColor = self.listView.backgroundColor
        } else {
            v.backgroundColor = self.backgroundColor
        }
        return v
        }()
    
    open override var hidesBottomBarWhenPushed: Bool {
        get { return self.navigationController?.topViewController != self }
        set {}
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (isAutoHideBottomBarWhenPushed) { hidesBottomBarWhenPushed = true }
    }
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        iw.previousViewController = self
        if (isAutoHideBottomBarWhenPushed) { hidesBottomBarWhenPushed = false }
    }
    
    deinit {
        iPrint("\(self) has been released.")
    }
    
    // MARK:- View did load
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        _init()
    }
    
    private func _init() {
        extendedLayoutIncludesOpaqueBars.enable()
        if tabBarController.and(then: { $0.tabBar.isTranslucent }).orTrue.isFalse {
            edgesForExtendedLayout = .bottom
        }
        
        isAutoHideBottomBarWhenPushed.enable()
        backgroundColor = .white
        
        preconfiguration()
        setupUserInterface()
        configureUserInterface()
        configure()
    }
    
    /// (xib 初始化界面后，不适配导航栏位置的解决方式).
    public var useLayoutGuide: Bool = false {
        didSet {
            if useLayoutGuide {
                self.edgesForExtendedLayout = .init(rawValue: 0)
            } else {
                self.edgesForExtendedLayout = .all //[.left, .right]
            }
        }
    }
    
    /// (添加一个与view背景色相同的view, 到iPhoneX屏幕底部).
    public func insertSafeAreaBottomSpacingView(belowSubview: UIView, bgColor: UIColor? = nil) -> Void {
        if IWDevice.isiPhoneX {
            if belowSubview.bottom == .screenHeight {
                belowSubview.bottom = .screenHeight - .bottomSpacing
            }
            view.insertSubview(bottomSpacingBackgroundView, belowSubview: belowSubview)
            if bgColor != nil {
                bottomSpacingBackgroundView.backgroundColor = bgColor
            }
        }
    }
    
    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- 交给子类重写
    /**
     viewDidLoad 中
     先走 preconfiguration
     再走 setupUserInterface
     再走 configureUserInterface
     最后 configure
     */
    
    /// (前置配置).
    open func preconfiguration() -> Void { }
    /// (添加视图).
    open func setupUserInterface() -> Void { }
    /// (配置视图).
    open func configureUserInterface() -> Void { }
    /// (用于配置一些其他信息, 例如网络请求等).
    open func configure() -> Void { }
}

extension IWRootVC: IWTableViewInitProtocol {
    
    public var listView: IWListView! {
        get {
            return objc_getAssociatedObject(self, &IWListView.Key.listViewKey) as! IWListView
        }
        set {
            objc_setAssociatedObject(self, &IWListView.Key.listViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// (初始化一个 listView).
    public func initListView(_ frame: CGRect, style: UITableViewStyle) -> IWListView {
        let lsv = IWListView.init(frame: frame, style: style)
        self.listView = lsv
        return lsv
    }
    
}
