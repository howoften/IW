//
//  IWShouldPop.swift
//  haoduobaduo
//
//  Created by iWe on 2017/8/6.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit


protocol IWNavigationShouldPopOnBackButton: class {
    
    /// Default is true
    func navigationShouldPopOnBackButton() -> Bool
}

extension UIViewController: IWNavigationShouldPopOnBackButton {
    @objc open func navigationShouldPopOnBackButton() -> Bool {
        return true
    }
}

extension UINavigationController: UINavigationBarDelegate {
    
    open func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        if let items = navigationBar.items, viewControllers.count < items.count { return true }
        var shoudPop = true
        let vc = topViewController
        if let topVC = vc, topVC.responds(to: #selector(navigationShouldPopOnBackButton)) {
            shoudPop = topVC.navigationShouldPopOnBackButton()
        }
        
        if shoudPop {
            DispatchQueue.main.async {
                self.popViewController(animated: true)
            }
        } else {
            for subview in navigationBar.subviews {
                if subview.alpha > 0.0 && subview.alpha < 1.0 {
                    UIView.animate(withDuration: 0.25, animations: {
                        subview.alpha = 1.0
                    })
                }
            }
        }
        return false
    }
    
}
