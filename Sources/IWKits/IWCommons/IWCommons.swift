//
//  IWCommons.swift
//  IWExtensionDemo
//
//  Created by iWw on 2018/5/24.
//  Copyright © 2018 iWe. All rights reserved.
//

import UIKit

public protocol _IWGetCurrentViewControllerProtocol: class { }

extension UIViewController: _IWGetCurrentViewControllerProtocol { }

extension _IWGetCurrentViewControllerProtocol where Self: UIViewController {
    
    public static var current: Self? {
        let rootVc = UIApplication.shared.keyWindow?.rootViewController
        let vc = self.find(in: rootVc)
        return vc as? Self
    }
    
    private static func find(in displayController: UIViewController?) -> UIViewController? {
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
    
}

/// (当前屏幕显示的控制器).
public var GetCurrentViewController: UIViewController? {
    return UIViewController.current
}
