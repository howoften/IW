//
//  UIScrollView+IWView.swift
//  haoduobaduo
//
//  Created by iWe on 2017/9/20.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

extension IWView where View: UIScrollView {
	
	final func autoSetEdge(_ optionSuperView: UIView?) -> Void {
		
		guard let superView = optionSuperView else {
			fatalError("The super view is nil.")
		}
		
		// iWARNING: Open in Xcode9
		if #available(iOS 11, *) {
			view.contentInsetAdjustmentBehavior = .never
		}
		
		(viewController as? IWRootVC)?.listViewThread.async {
			self.asyncAutoSetEdge(superView)
		}
		
	}
	
	final func setBothInsets(_ insets: UIEdgeInsets) -> Void {
		bothInsets = insets
	}
	
	var bothInsets: UIEdgeInsets {
		get { return view.contentInset }
		set {
			(viewController as? IWRootVC)?.listViewThread.async {
				main {
					self.view.contentInset = newValue
					self.view.scrollIndicatorInsets = newValue
					//self.view.contentOffset = CGPoint.init(x: 0, y: -newValue.top)
				}
			}
		}
	}
}

fileprivate extension IWView where View: UIScrollView {
	
	final func asyncAutoSetEdge(_ superView: UIView) -> Void {
        
        main {
            if superView.bounds == ikScreenBounds {
                let vc = superView.iwe.viewController
                if vc != nil {
                    var edge = UIEdgeInsets.zero
                    
                    if self.theNavgationBarExists(vc) {
                        self.refreshEdgeWithNavigationBarExists(vc, edge: &edge)
                    } else {
                        edge.top = self.findCompatibleValue(type: .top)
                    }
                    
                    edge.bottom = self.findCompatibleValue(type: .bottom)
                    
                    edge.left = self.findCompatibleValue(type: .left)
                    edge.right = self.findCompatibleValue(type: .right)
                    
                    self.view.contentInset = edge
                    self.view.scrollIndicatorInsets = edge
                    if IWDevice.isiPhoneX {
                        self.view.contentOffset = CGPoint.init(x: 0, y: -edge.top)
                    }
                }
            }
        }
		
	}
	
	final func theNavgationBarExists(_ optionVC: UIViewController?) -> Bool {
		guard let vc = optionVC else { return false }
		return (vc.navigationController?.navigationBar != nil && vc.navigationController?.navigationBar.isHidden == false)
	}
	
	final func refreshEdgeWithNavigationBarExists(_ optionVC: UIViewController?, edge:inout UIEdgeInsets) -> Void {
		if let vc = optionVC {
			if #available(iOS 11, *) {
				refreshEdgeWithiOS11(vc, edge: &edge)
			} else {
				refreshEdgeWithiOS10(vc, edge: &edge)
			}
		}
	}
	
	final func refreshEdgeWithiOS11(_ optionVC: UIViewController?, edge:inout UIEdgeInsets) -> Void {
        edge.top = findCompatibleValue(type: .top)
	}
	
	final func refreshEdgeWithiOS10(_ optionVC: UIViewController?, edge:inout UIEdgeInsets) -> Void {
		guard let vc = optionVC else { return }
		if vc.automaticallyAdjustsScrollViewInsets == false {
			edge.top = findCompatibleValue(type: .top)
		}
	}
    
    enum CompatibleEdgeType {
        case top
        case bottom
        case left
        case right
    }
    
    private func findCompatibleValue(type: CompatibleEdgeType) -> CGFloat {
        
        let c = self.view.contentInset
        let s = self.view.scrollIndicatorInsets
        
        switch type {
        case .top:
            return (c.top == 0 && s.top == 0) ? .navBarHeight : max(c.top, s.top, .navBarHeight)
        case .bottom:
            return (c.bottom == 0 && s.bottom == 0) ? .tabbarHeight : max(c.bottom, s.bottom, .tabbarHeight)
            
        case .left:
            return (c.left == 0 && s.left == 0) ? 0 : max(c.left, s.left)
        case .right:
            return (c.right == 0 && s.right == 0) ? 0 : max(c.right, s.right)
        }
    }
}
