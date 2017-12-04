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
	
	final var bothInsets: UIEdgeInsets {
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
	
	
	/// 立即停止滚动 (手指离开屏幕但列表还在滚动)
	final func stopDeceleratingIfNeeded() -> Void {
		if self.view.isDecelerating {
			self.view.setContentOffset(self.view.contentOffset, animated: false)
		}
	}
	
	
	/// 是否已在底部, 无法滚动返回 true
	final var isBottom: Bool {
		if !self.canScroll || (self.view.contentOffset.y == self.view.contentSize.height + self.contentInsets.bottom - self.view.height) {
			return true
		}
		return false
	}
	
	/// 是否已在顶部, 无法滚动返回 true
	final var isTop: Bool {
		if !self.canScroll || (self.view.contentOffset.y == -self.contentInsets.top) {
			return true
		}
		return false
	}
	
	final var contentInsets: UIEdgeInsets {
		if #available(iOS 11, *) {
			return self.view.adjustedContentInset
		}
		return self.view.contentInset
	}
	
	final var canScroll: Bool {
		if CGSize.isEmpty(self.view.bounds.size) {
			return false
		}
		let canVerticalScroll = self.view.contentSize.height + self.contentInsets.top + self.contentInsets.bottom + self.view.height
		let canHorizontalScroll = self.view.contentSize.width + self.contentInsets.left + self.contentInsets.right + self.view.width
		return canVerticalScroll > 0 || canHorizontalScroll > 0
	}
	
	final func scrollToTop(force: Bool, animated: Bool) -> Void {
		if force || (!force && self.canScroll) {
			self.view.setContentOffset(makePoint(-self.contentInsets.left, -self.contentInsets.top), animated: animated)
		}
	}
	
	final func scrollToTop(animated: Bool = false) -> Void {
		self.scrollToTop(force: false, animated: animated)
	}
	
	final func scrollToBottom(animated: Bool = false) -> Void {
		if self.canScroll {
			self.view.setContentOffset(makePoint(self.view.contentOffset.x, self.view.contentSize.height + self.contentInsets.bottom - self.view.height), animated: animated)
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
