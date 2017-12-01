//
//  UIViewController+IWViewController.swift
//  haoduobaduo
//
//  Created by iWe on 2017/9/19.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

extension IWViewController where ViewController: UIViewController {
	
	// Use these func, you must set key: 'View controller-based status bar appearance and value': 'No' to "Info.plist"
	final func useBackStyleWithStatusBar() -> Void {
		UIApplication.shared.statusBarStyle = .default
	}
	final func useWhiteStyleWithStatusBar() -> Void {
		UIApplication.shared.statusBarStyle = .lightContent
	}
	
	final class func current<T: UIViewController>() -> T? {
		let rootVc = UIApplication.shared.keyWindow?.rootViewController
		let vc = self.find(in: rootVc)
		return vc as? T
	}
	
	final var isNavigationBarHidden: Bool {
		get {
			if let navBar = vc.navigationController?.navigationBar {
				return navBar.isHidden
			}
			return false
		}
		set {
			main {
				if newValue {
					self.hideNavigationBar()
				} else {
					self.showNavigationBar()
				}
			}
			
		}
	}
	
	final var navigationBarHeight: CGFloat {
		if !isNavigationBarHidden {
			return vc.navigationController!.navigationBar.height + CGFloat.statusBarHeight
		}
		return CGFloat.statusBarHeight
	}
	
	final func navItem(_ title: String?, target: Any?, action: Selector?) -> UIBarButtonItem {
		let btn = UIBarButtonItem(title: title, style: .plain, target: target, action: action)
		btn.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)], for: .normal)
		return btn
	}
	
	final func addLeftNavBtn(_ title: String, target: Any?, action: Selector?) {
		if vc.navigationController == nil {
			iPrint("The navigation controller is nil.")
			return
		}
		vc.navigationItem.leftBarButtonItem = navItem(title, target: target, action: action)
	}
	
	final func addRightNavBtn(_ title: String, target: Any?, action: Selector?) {
		if vc.navigationController == nil {
			iPrint("The navigation controller is nil.")
			return
		}
		vc.navigationItem.rightBarButtonItem = navItem(title, target: target, action: action)
	}
	
	func push(to viewController: UIViewController, _ animated: Bool = true) -> Void {
		vc.navigationController?.pushViewController(viewController, animated: animated)
	}
    
	final func pop(viewControllerWithAnimated animated: Bool = true) {
		backToPreviousController(animated)
	}
	
	func modal(_ viewController: UIViewController, _ animated: Bool = true) -> Void {
		vc.present(viewController, animated: animated, completion: nil)
	}
    
	final func dismiss() {
		backToPreviousController()
	}
	
	final func backToPreviousViewController() -> Void {
		backToPreviousController()
	}
	
	final func showNavigationBar() -> Void {
		vc.navigationController?.setNavigationBarHidden(false, animated: true)
		vc.navigationController?.navigationBar.isHidden = false
	}
	
	final func hideNavigationBar() -> Void {
		vc.navigationController?.setNavigationBarHidden(true, animated: false)
		vc.navigationController?.navigationBar.isHidden = true
	}
	
	final func interactivePopGestureRecognizer(_ recognizer: UIGestureRecognizerDelegate?) -> Void {
		weak var rec = recognizer
		vc.navigationController?.interactivePopGestureRecognizer?.delegate = rec
	}
}

fileprivate extension IWViewController where ViewController: UIViewController {
	
	class func find(in displayController: UIViewController?) -> UIViewController? {
		if displayController != nil {
			if (displayController?.presentedViewController != nil) {
				
				return self.find(in: displayController?.presentedViewController!)
			} else if (displayController?.isKind(of: UISplitViewController.self))! {
				
				let splitVc = displayController as! UISplitViewController
				if splitVc.viewControllers.count > 0 {
					return self.find(in: splitVc.viewControllers.last)
				}
			} else if (displayController?.isKind(of: UINavigationController.self))! {
				
				let navigationC = displayController as! UINavigationController
				if navigationC.viewControllers.count > 0 {
					return self.find(in: navigationC.topViewController)
				}
			} else if (displayController?.isKind(of: UITabBarController.self))! {
				
				let tabbarC = displayController as! UITabBarController
				if tabbarC.viewControllers!.count > 0 {
					return self.find(in: tabbarC.selectedViewController)
				}
			}
			return displayController
		}
		return nil
	}
	
	func backToPreviousController(_ animated: Bool = true) {
		if let controllers = vc.navigationController?.viewControllers, controllers.count > 1 {
			if controllers[safe: controllers.count - 1] == vc {
				// push
				vc.navigationController?.popViewController(animated: animated)
			}
		} else {
			// presnet
			vc.dismiss(animated: animated, completion: nil)
		}
	}
}
