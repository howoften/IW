//  Created by iWw on 23/01/2018.
//  Copyright © 2018 iWe. All rights reserved.
//

import UIKit

public extension CGFloat {
    
    public var toFloat: Float { return Float(self) }
    
    public static let estimated: CGFloat = -1
    
    /**
     time: 2017.10/10 at 09:34
     note: 根据 iPhoneX SafeAreaGuide 进行了修正
     Changed by iwe. */
    public static var tabbarHeight: CGFloat {
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
    public static var navBarHeight: CGFloat {
        guard let vc = UIViewController.IWE.current() else { return 0 }
        guard let navBar = vc.navigationController?.navigationBar else { return 0 }
        if navBar.isHidden {
            return statusBarHeight
        }
        return navBar.height + statusBarHeight
    }
    
    /// (不考虑是否隐藏的情况下， tabbar 的高度).
    public static var tabbarHeightNormal: CGFloat {
        return IWDevice.isiPhoneX.true({ 83 }, elseReturn: { 49 })
    }
    
    /// (不考虑是否隐藏的情况下， navBar 的高度).
    public static var navBarHeightNormal: CGFloat {
        return IWDevice.isiPhoneX.true({ 88 }, elseReturn: { 64 })
    }
    
    public static var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    
    public static let largeTitleViewHeight: CGFloat = 48.0
    
    /**
     导航栏 titleView 尽可能充满屏幕，余留的边距
     iPhone5s/iPhone6(iOS8/iOS9/iOS10) margin = 8
     iPhone6p(iOS8/iOS9/iOS10) margin = 12
     
     iPhone5s/iPhone6(iOS11) margin = 16
     iPhone6p(iOS11) margin = 20
     */
    public static var titleViewMargin: CGFloat {
        return iw.system.version.toInt >= 11 ? (self.screenWidth > 375 ? 20 : 16) : (self.screenWidth > 375 ? 12 : 8)
    }
    
    /**
     导航栏左右navigationBarItem余留的边距
     iPhone5s/iPhone6(iOS8/iOS9/iOS10) margin = 16
     iPhone6p(iOS8/iOS9/iOS10) margin = 20
     */
    public static var itemMargin: CGFloat {
        return self.screenWidth > 375 ? 20 : 16
    }
    
    /**
     导航栏titleView和navigationBarItem之间的间距
     iPhone5s/iPhone6/iPhone6p(iOS8/iOS9/iOS10) iterItemSpace = 6
     */
    public static let interItemSpace: CGFloat = 6
    
    /// (iPhone X 返回 34, 其他设备返回 0 ).
    public static let bottomSpacing: CGFloat = (IWDevice.isiPhoneX ? 34 : 0)
    
    /// (最小值).
    public static let min: CGFloat = CGFloat.leastNormalMagnitude
    /// (最大值).
    public static let max: CGFloat = CGFloat.greatestFiniteMagnitude
    
    /// (屏幕高度, 会根据设备方向的不同返回不同值).
    public static var screenHeight: CGFloat {
        return (IWDevice.orientation == .unknown).or({ IWDevice.orientation.isPortrait }).true({ iw.screenHeight }, elseReturn: { iw.screenWidth })
    }
    /// (屏幕宽度, 会根据设备方向的不同返回不同值).
    public static var screenWidth: CGFloat {
        return (IWDevice.orientation == .unknown).or({ IWDevice.orientation.isPortrait }).true({ iw.screenWidth }, elseReturn: { iw.screenHeight })
    }
    public static var screenBounds: CGRect {
        return UIScreen.main.bounds
    }
    
    public static var safeAreaHeight: CGFloat {
        var safeAh = screenHeight
        safeAh -= navBarHeight
        safeAh -= tabbarHeight
        return safeAh
    }
}

