//  Created by iWe on 2017/6/14.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

open class IWRootVC: UIViewController {
    
    /// (IWListView).
    public var listView: IWListView! = nil
    lazy var listViewThread: DispatchQueue = {
        return DispatchQueue(label: "cc.iwe.listView", attributes: .init(rawValue: 0))
    }()
//    private var _numberOfSections: Int = 0
//    private var _numberOfRowsInSection: Int = 0
    
    /// The view background color.
    public var backgroundColor: UIColor? {
        get { return self.view.backgroundColor }
        set { self.view.backgroundColor = newValue }
    }
    /// Navigation item title.
    public var navTitle: String? {
        get { return self.navigationItem.title }
        set { self.navigationItem.title = newValue }
    }
    /// Tabbar item badge value.
    public var badgeValue: String? {
        get { return self.tabBarItem.badgeValue }
        set { self.tabBarItem.badgeValue = newValue }
    }
    
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
    public var naver: IWNaverInfo?
    
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
        
        if (isAutoHideBottomBarWhenPushed) { self.hidesBottomBarWhenPushed = true }
    }
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        iw.previousViewController = self
        if (isAutoHideBottomBarWhenPushed) { self.hidesBottomBarWhenPushed = false }
    }
    
    deinit {
        iPrint("The view controller(\(self)) has been released.")
    }
    
    // MARK:- View did load
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        _init()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // iPrint("The view controller is: \(self)")
    }
    
    private func _init() {
        self.extendedLayoutIncludesOpaqueBars = true
        if self.tabBarController.and(then: { $0.tabBar.isTranslucent }).or(true).isFalse {
            self.edgesForExtendedLayout = .bottom
        }
        
        self.isAutoHideBottomBarWhenPushed = true
        self.view.backgroundColor = .white
    }
    
    public var useLayoutGuide: Bool = false {
        didSet {
            if useLayoutGuide {
                self.edgesForExtendedLayout = .init(rawValue: 0)
            } else {
                self.edgesForExtendedLayout = .all //[.left, .right]
            }
        }
    }
    
    /// (添加一个 Grouped 风格的 IWListView 到界面上).
    open func addGroupedListView() {
        self.listView = createListView(withFrame: self.view.bounds, style: .grouped)
        self.view.addSubview(self.listView)
    }
    /// (添加一个 Plain 风格的 IWListView 到界面上).
    open func addPlainListView() {
        self.listView = createListView(withFrame: self.view.bounds, style: .plain)
        self.view.addSubview(self.listView)
    }
    /// (返回一个IWListView).
    private func createListView(withFrame frame: CGRect, style: UITableViewStyle) -> IWListView {
        let lv = IWListView(frame: frame, style: style)
        lv.delegate = self
        lv.dataSource = self
        return lv
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
    /// (用于加载 UI).
    open func initUserInterface() -> Void { }
    /// (用于配置一些其他信息, 例如网络请求等).
    open func configure() -> Void { }
    
    /// (v0.2.5 已废弃, 请使用 configureDidSelect(_:indexPath:)).
    @available(*, deprecated: 0.2.5, message: "Use configureDidSelect(_:indexPath:)")
    open func tableView(_ tableView: UITableView, ofDidSelectAt indexPath: IndexPath) { }
    /// (Cell 点击/选中时触发).
    open func configureDidSelect(_ tableView: UITableView, indexPath: IndexPath) { }
    /// (Cell 渲染/加载时触发).
    open func configureReusableCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell { return UITableViewCell() }
}

// MARK:- TableView 协议: DataSource
extension IWRootVC: UITableViewDataSource {
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureReusableCell(tableView, indexPath: indexPath)
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if listView != nil, listView.isAutoDeselect {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        self.configureDidSelect(tableView, indexPath: indexPath)
    }
}


// MARK:- TableView 协议: Delegate
extension IWRootVC: UITableViewDelegate {
    
//    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return nil
//    }
//    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return nil
//    }
//    // iOS 11 中需要配置 viewForHeader viewForFooter 才会执行 heightForHeader heightForFooter
//    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if tableView.style == .grouped {
//            if section == 0 {
//                return 20.0
//            }
//            return 10.0
//        }
//        return .min
//    }
//    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if tableView.style == .grouped {
//            return 10.0
//        }
//        return .min
//    }
}

