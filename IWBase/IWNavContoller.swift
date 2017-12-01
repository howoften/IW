//
//  IWNavContoller.swift
//  haoduobaduo
//
//  Created by iWe on 2017/6/19.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit
import Foundation

class IWNavController: UINavigationController {
    
    static var withoutBackTitleWhenPushed: Bool = false
    
    var isEnableRightSlideToPop: Bool = false {
        willSet {
            main {
                if newValue {
                    self.enableRightSlideToPop()
                    return
                }
                self.disableRightSlideToPop()
            }
        }
    }
    
    var fullScreenGes: UIPanGestureRecognizer?
    
    private var shadowImageBackup: UIImageView? = nil
    var isHiddenShadowImage: Bool = false {
        willSet {
            if newValue {
                for v: UIView in navigationBar.subviews {
                    let condition = iOSVersion >= 10 ? v.isKind(of: "_UIBarBackground".toAnyClass!) : v.isKind(of: "_UINavigationBarBackground".toAnyClass!)
                    if condition {
                        for sv: UIView in v.subviews {
                            if sv.height <= 0.5 {
                                shadowImageBackup = (sv as! UIImageView)
                                break
                            }
                        }
                    }
                }
                shadowImageBackup?.isHidden = true
            } else {
                shadowImageBackup?.isHidden = false
            }
        }
    }
    
    // 背景颜色: navigation bar background color
    var navBackgroundColor: UIColor? {
        willSet {
            if let color = newValue {
                self.navigationBar.barTintColor = color
            }
        }
    }
    
    // 前景视图颜色: navgation item显示的颜色
    var navTintColor: UIColor? {
        willSet {
            if let color = newValue {
                self.navigationBar.tintColor = color
            }
        }
    }
	
	// Tabbar item显示的颜色
	var tabbarSelectedColor: UIColor? {
		willSet {
			if let color = newValue {
				self.tabBarController?.tabBar.tintColor = color
			}
		}
	}
	
	override var isNavigationBarHidden: Bool {
		get { return navigationBar.isHidden }
		set {
			navigationBar.isHidden = newValue
			
			/*
			if let vc = UIViewController.IWE.current() {
				for subv in vc.view.subviews {
					if subv is IWListView {
						(subv as! IWListView).iwe.autoSetEdge(vc.view)
						(subv as! IWListView).scrollRectToVisible(.zero, animated: false)
					}
				}
			}*/
		}
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if IWNavController.withoutBackTitleWhenPushed {
            topViewController?.navigationItem.backBarButtonItem = withoutTitleForBackItem()
        }
        super.pushViewController(viewController, animated: animated)
    }
	
}

extension IWNavController: UIGestureRecognizerDelegate {
    
    // MARK:- PUSH后不显示返回按钮的标题
    func withoutTitleForBackItem() -> UIBarButtonItem {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)], for: .normal)
        return backItem
    }
    
    // MARK:- 任意位置向右滑动返回上一界面
    fileprivate func enableRightSlideToPop() {
        let target = self.interactivePopGestureRecognizer?.delegate
        let handler = NSSelectorFromString("handleNavigationTransition:")
        let targetView = self.interactivePopGestureRecognizer?.view
        fullScreenGes = UIPanGestureRecognizer(target: target, action: handler)
        fullScreenGes!.delegate = self
        targetView?.addGestureRecognizer(fullScreenGes!)
        self.interactivePopGestureRecognizer?.isEnabled = false
    }
    fileprivate func disableRightSlideToPop() {
        self.interactivePopGestureRecognizer?.isEnabled = true
    }
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if isEnableRightSlideToPop {
            let translation = (gestureRecognizer as! UIPanGestureRecognizer).translation(in: gestureRecognizer.view)
            if translation.x <= 0 {
                return false
            }
            return childViewControllers.count == 1 ? false : true
        }
        return false
    }
}
