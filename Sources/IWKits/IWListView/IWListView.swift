//  Created by iWe on 2017/6/14.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

protocol IWTableViewInitProtocol {
    
    var listView: IWListView! { get set }
    var listViewThread: DispatchQueue { get }
    func setupGroupedListView(to view: UIView) -> Void
    func setupPlainListView(to view: UIView) -> Void
    /// (初始化).
    func initListView(_ frame: CGRect, style: UITableViewStyle) -> IWListView
    
    /// (添加约束).
    //func _constraintsAddedOfListView(_ view: UIView) -> Void
}

extension IWTableViewInitProtocol {
    
    public var listViewThread: DispatchQueue {
        return DispatchQueue(label: "cc.iwe.listView", attributes: .init(rawValue: 0))
    }
    
    public func setupGroupedListView(to view: UIView) -> Void {
        let lv = initListView(view.bounds, style: .grouped)
        view.addSubview(lv)
        _constraintsAddedOfListView(view)
    }
    
    public func setupPlainListView(to view: UIView) -> Void {
        let lv = initListView(view.bounds, style: .plain)
        view.addSubview(lv)
        //_constraintsAddedOfListView(view)
        if #available(iOS 9.0, *) {
            lv.fillToSuperview()
        } else {
            // Fallback on earlier versions
            lv.fillToSuperviewWithiOS6()
        }
    }
    
    private func _constraintsAddedOfListView(_ view: UIView) -> Void {
        let topConstraint = NSLayoutConstraint.init(item: listView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0)
        let leftConstraint = NSLayoutConstraint.init(item: listView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0)
        let rightConstraint = NSLayoutConstraint.init(item: view, attribute: .trailing, relatedBy: .equal, toItem: listView, attribute: .trailing, multiplier: 1.0, constant: 0)
        let bottomConstraint = NSLayoutConstraint.init(item: view, attribute: .bottom, relatedBy: .equal, toItem: listView, attribute: .bottom, multiplier: 1.0, constant: 0)
        NSLayoutConstraint.activate([topConstraint, leftConstraint, rightConstraint, bottomConstraint])
    }
}


/// UITableView Override.
/// (UITableView 的子类, 相比较增加了更多便捷功能).
public class IWListView: UITableView {
    
    public struct Key {
        static var listViewKey: Void?
    }
    
    /// (是否为第一次加载数据).
    public final var isFirstReloadData: Bool!
    /// (是否正在刷新).
    public final var isRefreshing: Bool!
    /// (是否开启自动反选, 用于 didselect 中, 为 true 时自动触发 deselect 操作).
    public final var isAutoDeselect: Bool = true
    
    /// (是否隐藏横向&竖直的滚动条).
    public final var isHideVandHScrollIndicator: Bool = false {
        willSet {
            self.showsVerticalScrollIndicator = !newValue
            self.showsHorizontalScrollIndicator = !newValue
        }
    }
    /// (是否隐藏 Cell 下划线).
    public final var isHideSeparator: Bool = false {
        willSet {
            if newValue {
                self.separatorStyle = .none
            } else {
                self.separatorStyle = .singleLine
            }
        }
    }
    
    
    private final var tapToHideKeyborderGesture: UITapGestureRecognizer?
    /// (是否在 touch 时隐藏 keyboard).
    public final var isTouchHideKeyborder: Bool = false {
        willSet {
            if newValue {
                let tap = UITap(target: self, action: #selector(IWListView.touchHideKeyboard))
                self.tapToHideKeyborderGesture = tap
                self.addGestureRecognizer(tap)
            } else {
                if self.tapToHideKeyborderGesture != nil {
                    self.removeGestureRecognizer(tapToHideKeyborderGesture!)
                    self.tapToHideKeyborderGesture = nil
                }
            }
        }
    }
    
    fileprivate var moveToSuperView: UIView?
    
    /// (重新加载目前显示在视图上的 Cell).
    public func reloadVisiableRows(with animation: UITableViewRowAnimation) -> Void {
        if let visiableRowIndexPaths = self.indexPathsForVisibleRows {
            self.reloadRows(at: visiableRowIndexPaths, with: animation)
        }
    }
    
    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        _init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func _init() {
        initUserInterface()
    }
    
    @objc public override func reloadData() {
        print("r self: \(self)")
        print("r selfds: \(self.dataSource as Any)")
        
        super.reloadData()
        
        print("self: \(self)")
        print("selfds: \(self.dataSource as Any)")
    }
    
    open func reloadDataWithAnimation(_ animation: UIViewAnimationOptions = .transitionCrossDissolve) -> Void {
        UIView.transition(with: self, duration: 0.35, options: animation, animations: {
            self.reloadData()
        }) { (finished) in
            self.layer.removeAllAnimations()
        }
    }
    
    /// (配置 protocols).
    public func configrationProtocols<T: UITableViewCell, P: UITableViewHeaderFooterView>(delegate: UITableViewDelegate?, dataSource: UITableViewDataSource?, rcells: [T.Type]?, rviews: [P.Type]?) -> Void {
        self.delegate = delegate
        self.dataSource = dataSource
        
        print("self: \(self)")
        print("selfds: \(self.dataSource as Any)")
        
        if rcells.isSome { self.registerCells(rcells!) }
        if rviews.isSome { self.registerViews(rviews!) }
    }
    
    /// (注册复用 Cells).
    public final func registerCells<T: UITableViewCell>(_ cells: [T.Type]) -> Void {
        for i in cells {
            self.registReusable(i)
        }
    }
    /// (注册复用 HeaderFooterViews).
    public final func registerViews<T: UITableViewHeaderFooterView>(_ headerFooterViews: [T.Type]) -> Void {
        for i in headerFooterViews {
            self.registReusable(i)
        }
    }
    
}


extension IWListView {
    
    fileprivate func initUserInterface() -> Void {
        
        isFirstReloadData = false
        isRefreshing = false
        
        autoresizingMask = .flexibleWidth
        
        //separatorColor = .groupTableViewBackground
        
        tableHeaderView = UIView(frame: MakeRect(0, 0, .screenWidth, .min))
        tableFooterView = UIView()
        
        if let tabbar = UIViewController.IWE.current()?.tabBarController?.tabBar, !tabbar.isTranslucent {
            if iw.isTabbarExists {
                self.contentInset = MakeEdge(0, 0, .navBarHeightNormal + 49, 0)
                self.scrollIndicatorInsets = self.contentInset
            } else {
                self.contentInset = MakeEdge(0, 0, .navBarHeightNormal, 0)
                self.scrollIndicatorInsets = self.contentInset
            }
        }
        
        registReusable(UITableViewCell.self)
    }
    
}

extension IWListView {
    
    /*
    public override func willMove(toSuperview newSuperview: UIView?) {
        moveToSuperView = newSuperview
        iwe.autoSetEdge(moveToSuperView)
    } */
    
    @objc public final func touchHideKeyboard() {
        self.endEditing(true)
    }
}

