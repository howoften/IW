//
//  IWGlobal.swift
//  haoduobaduo
//
//  Created by iWe on 2017/7/7.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

public typealias UIAlert = UIAlertController
public typealias UITap = UITapGestureRecognizer

class iw {
	
	///  Previous viewController, set in `IWRootVC.viewWillDisappear`
	weak static var previousViewController: UIViewController?
	
	/// Tabbar is exists
	static var isTabbarExists: Bool {
		let window = UIApplication.shared.delegate!.window!!
		if window.subviews.count == 0 { return false }
		
		var hasTabbar = false
		let vc = UIViewController.IWE.current()
		if vc != nil { if (vc?.tabBarController?.tabBar) != nil { hasTabbar = !vc!.tabBarController!.tabBar.isHidden } }
		
		let tabbarClass: AnyClass! = NSClassFromString("UILayoutContainerView")
		let windowFirst = window.subviews.first!
		if (windowFirst.isKind(of: tabbarClass)) {
			let findTabbar = iw.find(tabbarIn: window.subviews.first?.subviews as NSArray?)
			if hasTabbar && findTabbar { return true }
		}
		return false
	}
	
	/// 延迟执行, execution, cancel
	struct delay {
		typealias Task = (_ cancel: Bool) -> Void
		static func execution(delay dly: TimeInterval, toRun task: @escaping () -> ()) -> Task? {
			func dispatch_later(block: @escaping ()->()) {
				let t = DispatchTime.now() + dly
				DispatchQueue.main.asyncAfter(deadline: t, execute: block)
			}
			var closure: (() -> Void)? = task
			var result: Task?
			
			let delayedClosure: Task = { cancel in
				if let internalClosure = closure {
					if (cancel == false) { DispatchQueue.main.async(execute: internalClosure) }
				}
				closure = nil; result = nil
			}
			
			result = delayedClosure
			
			dispatch_later { if let delayedClosure = result { delayedClosure(false) } }
			return result
		}
		/// 取消延迟执行的任务(执行开始前)
		static func cancel(_ task: Task?) {
			task?(true)
		}
	}
	
	/// 主线程, execution
	struct main {
		static func execution(_ task: @escaping () -> Void) -> Void {
			DispatchQueue.main.async { task() }
		}
	}
	
	/// 子线程, execution
	struct subThread {
		static func execution(queueLabel qlabel: String = "iw.writelog", _ task: @escaping () -> Void) -> Void {
			DispatchQueue(label: qlabel).async { task() }
		}
	}
	
	static let isiPhone = (UIDevice.current.model == "iPhone")
	static let screenBounds = UIScreen.main.bounds
	static let screenSize = iw.screenBounds.size
	static let screenWidth = iw.screenSize.width
	static let screenHeight = iw.screenSize.height
	
	/// 系统类型
	struct system {
		/// 系统版本号, 字符型
		static let version = UIDevice.current.systemVersion
	}
	
	/// 平台
	struct platform {
		/// 是否为模拟器
		static let isSimulator: Bool = {
			var isSim = false
			#if arch(i386) || arch(x86_64)
				isSim = true
			#endif
			return isSim
		}()
	}
	
}

fileprivate extension iw {
	
	static func find(tabbarIn array: NSArray?) -> Bool {
		if array != nil {
			for obj in array! {
				let v = obj as! UIView
				if v is UITabBar {
					let tabbar = v as! UITabBar
					if tabbar.isHidden {
						return false
					}
					return true
				}
			}
		}
		return false
	}
}

// MARK:- 正则操作符
infix operator =~
func =~ (content: String, matchs: String) -> Bool {
    return IWRegex.match(matchs, content)
}


// MARK:- Edge & Rect
/// Make UIEdgeInsets
func MakeEdge(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsetsMake(top, left, bottom, right)
}
/// Make CGRect
func MakeRect(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
    return CGRect(x: x, y: y, width: width, height: height)
}
/// Make IndexPath
func MakeIndex(_ row: Int, _ section: Int) -> IndexPath {
    return IndexPath(row: row, section: section)
}
/// Make CGSize
func MakeSize(_ width: CGFloat, _ height: CGFloat) -> CGSize {
    return CGSize(width: width, height: height)
}
/// Make CGPoint
func MakePoint(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
	return CGPoint(x: x, y: y)
}

