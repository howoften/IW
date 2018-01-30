//  Created by iWw on 23/01/2018.
//  Copyright © 2018 iWe. All rights reserved.
//

import UIKit

public extension CGFloat {
    
    var toFloat: Float { return Float(self) }
    
    static let estimated: CGFloat = -1
    
    /**
     time: 2017.10/10 at 09:34
     note: 根据 iPhoneX SafeAreaGuide 进行了修正
     Changed by iwe. */
    static var tabbarHeight: CGFloat {
        guard let vc = UIViewController.IWE.current() else { return 0 }
        guard let tabBar = vc.tabBarController?.tabBar else { return 0 }
        if !iw.isTabbarExists || tabBar.isHidden {
            if IWDevice.isiPhoneX {
                return .bottomSpacing
            }
            return 0
        }
        return tabBar.height
    }
    static var navBarHeight: CGFloat {
        guard let vc = UIViewController.IWE.current() else { return 0 }
        guard let navBar = vc.navigationController?.navigationBar else { return 0 }
        if navBar.isHidden {
            return statusBarHeight
        }
        return navBar.height + statusBarHeight
    }
    static var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    
    static let largeTitleViewHeight: CGFloat = 48.0
    
    /**
     导航栏 titleView 尽可能充满屏幕，余留的边距
     iPhone5s/iPhone6(iOS8/iOS9/iOS10) margin = 8
     iPhone6p(iOS8/iOS9/iOS10) margin = 12
     
     iPhone5s/iPhone6(iOS11) margin = 16
     iPhone6p(iOS11) margin = 20
     */
    static var titleViewMargin: CGFloat {
        return iw.system.version.toInt >= 11 ? (self.screenWidth > 375 ? 20 : 16) : (self.screenWidth > 375 ? 12 : 8)
    }
    
    /**
     导航栏左右navigationBarItem余留的边距
     iPhone5s/iPhone6(iOS8/iOS9/iOS10) margin = 16
     iPhone6p(iOS8/iOS9/iOS10) margin = 20
     */
    static var itemMargin: CGFloat {
        return self.screenWidth > 375 ? 20 : 16
    }
    
    /**
     导航栏titleView和navigationBarItem之间的间距
     iPhone5s/iPhone6/iPhone6p(iOS8/iOS9/iOS10) iterItemSpace = 6
     */
    static let interItemSpace: CGFloat = 6
    
    /**
     time: 2017.10/10 at 09:30
     note: 根据 iPhoneX SafeAreaGuide 修正底部间距
     Created by iwe. */
    static let bottomSpacing: CGFloat = (IWDevice.isiPhoneX ? 34 : 0)
    
    static let min: CGFloat = CGFloat.leastNormalMagnitude
    
    static let screenHeight: CGFloat = { return iw.screenHeight }()
    static let screenWidth: CGFloat = { return iw.screenWidth }()
    static let screenBounds: CGRect = { return iw.screenBounds }()
    
    static var safeAreaHeight: CGFloat {
        var safeAh = screenHeight
        safeAh -= navBarHeight
        safeAh -= tabbarHeight
        return safeAh
    }
}

