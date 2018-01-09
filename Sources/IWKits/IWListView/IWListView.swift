//  Created by iWe on 2017/6/14.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

public class IWListView: UITableView {
    
    public var isFirstReloadData: Bool!
    public var isRefreshing: Bool!
    public var isAutoDeselect: Bool = true
    
    public var isHideVandHScrollIndicator: Bool = false {
        willSet {
            self.showsVerticalScrollIndicator = !newValue
            self.showsHorizontalScrollIndicator = !newValue
        }
    }
    public var isHideSeparator: Bool = false {
        willSet {
            if newValue {
                self.separatorStyle = .none
            } else {
                self.separatorStyle = .singleLine
            }
        }
    }
    
    private var tapToHideKeyborderGesture: UITapGestureRecognizer?
    public var isTouchHideKeyborder: Bool = false {
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
    
    override public init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        _init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func _init() {
    	initUserInterface()
    }
	
	override public func reloadData() {
		super.reloadData()
	}
    
}


extension IWListView {
    
    fileprivate func initUserInterface() -> Void {
        
        isFirstReloadData = false
        isRefreshing = false
        
        autoresizingMask = .flexibleWidth
        
        separatorColor = .groupTableViewBackground
		
        tableHeaderView = UIView(frame: MakeRect(0, 0, .screenWidth, .min))
        tableFooterView = UIView()
        
        registReusable(UITableViewCell.self)
    }
	
}

extension IWListView {
    
    override public func willMove(toSuperview newSuperview: UIView?) {
        moveToSuperView = newSuperview
		iwe.autoSetEdge(moveToSuperView)
    }
    
    @objc public final func touchHideKeyboard() {
        self.endEditing(true)
    }
}

