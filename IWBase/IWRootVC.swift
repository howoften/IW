//  Created by iWe on 2017/6/14.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

protocol IWConfigureReusableCell {
    /// Take the place of 'cellForRowAtIndexPath'
    func configureReusableCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    /// Take the place of 'didSelectAtIndexPath'
    func tableView(_ tableView: UITableView, ofDidSelectAt indexPath: IndexPath) -> Void
}

extension IWRootVC: IWConfigureReusableCell {
    @objc func configureReusableCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    @objc func tableView(_ tableView: UITableView, ofDidSelectAt indexPath: IndexPath) {
        
    }
}

class IWRootVC: UIViewController {
    
    var listView: IWListView! = nil
	lazy var listViewThread: DispatchQueue = {
		return DispatchQueue(label: "cc.iwe.listView", attributes: .init(rawValue: 0))
	}()
    
    /// The view background color
    var backgroundColor: UIColor? {
        get { return self.view.backgroundColor }
        set { self.view.backgroundColor = newValue }
    }
    /// Navigation item title
    var navTitle: String? {
        get { return self.navigationItem.title }
        set { self.navigationItem.title = newValue }
    }
    /// Tabbar item badge value
    var badgeValue: String? {
        get { return self.tabBarItem.badgeValue }
        set { self.tabBarItem.badgeValue = newValue }
    }
    
    /// Hide back item title when pushed.
    var isHideBackItemTitleWhenPushed: Bool {
        get { return IWNavController.withoutBackTitleWhenPushed }
        set { IWNavController.withoutBackTitleWhenPushed = newValue }
    }
    
    /// Auto hide bottom bar when pushed.
    var isAutoHideBottomBarWhenPushed: Bool = false
    
    /// Navigation item title color
    var navTitleColor: UIColor {
        get { return .white }
        set { self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: newValue] }
    }
	
	lazy var bottomSpacingBackgroundView: UIView = { [unowned self] in
		let v = UIView(frame: MakeRect(0, ikScreenH - .bottomSpacing, ikScreenW, .bottomSpacing))
		if self.listView != nil {
			v.backgroundColor = self.listView.backgroundColor
		} else {
			v.backgroundColor = self.backgroundColor
		}
		return v
	}()
	
    override var hidesBottomBarWhenPushed: Bool {
        get { return self.navigationController?.topViewController != self }
        set {}
    }
	
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
		if (isAutoHideBottomBarWhenPushed) { self.hidesBottomBarWhenPushed = true }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
		previousViewController = self
		if (isAutoHideBottomBarWhenPushed) { self.hidesBottomBarWhenPushed = false }
    }
	
    deinit {
        iPrint("The view controller(\(self)) has been released.")
    }
    
	// MARK:- View did load
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		_init()
    }
	
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // iPrint("The view controller is: \(self)")
    }
    
    private func _init() {
		self.automaticallyAdjustsScrollViewInsets = false
        self.isAutoHideBottomBarWhenPushed = true
        self.view.backgroundColor = .white
    }
    
    func addGroupedListView() {
        self.listView = createListView(withFrame: self.view.bounds, style: .grouped)
        self.view.addSubview(self.listView)
    }
    func addPlainListView() {
        self.listView = createListView(withFrame: self.view.bounds, style: .plain)
        self.view.addSubview(self.listView)
    }
    private func createListView(withFrame frame: CGRect, style: UITableViewStyle) -> IWListView {
        let lv = IWListView(frame: frame, style: style)
        lv.delegate = self
        lv.dataSource = self
        return lv
    }
	
	func insertSafeAreaBottomSpacingView(belowSubview: UIView, bgColor: UIColor? = nil) -> Void {
		if IWDevice.isiPhoneX {
			if belowSubview.bottom == ikScreenH {
				belowSubview.bottom = ikScreenH - .bottomSpacing
			}
			view.insertSubview(bottomSpacingBackgroundView, belowSubview: belowSubview)
			if bgColor != nil {
				bottomSpacingBackgroundView.backgroundColor = bgColor
			}
		}
	}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	// MARK:- 交给子类重写
    public func initUserInterface() -> Void { }
    public func initRequestData() -> Void { }
}

// MARK:- TableView 协议: DataSource
extension IWRootVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    final func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureReusableCell(tableView, indexPath: indexPath)
    }
    
    final func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.tableView(tableView, ofDidSelectAt: indexPath)
    }
    
}
// MARK:- TableView 协议: Delegate
extension IWRootVC: UITableViewDelegate {
    
    @objc func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    // iOS 11 中需要配置 viewForHeader viewForFooter 才会执行 heightForHeader heightForFooter
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView.style == .grouped {
            if section == 0 {
                return 20.0
            }
            return 10.0
        }
        return .min
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView.style == .grouped {
            return 10.0
        }
        return .min
    }
    
}

