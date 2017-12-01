//
//  UIWindow+IWView.swift
//  haoduobaduo
//
//  Created by iWe on 2017/9/28.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

extension IWView where View: UIWindow {
	
	func show() -> Void {
		view.isHidden = false
		
		if #available(iOS 11, *) {
			for wd in UIApplication.shared.windows {
				if wd.isKind(of: NSClassFromString("_UIInteractiveHighlightEffectWindow")!) {
					wd.isHidden = true
				}
			}
		}
	}
}
