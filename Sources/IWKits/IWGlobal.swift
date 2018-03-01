//  Created by iWe on 2017/7/7.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit
import StoreKit // 应用内打开 app store 详情页

public typealias UIAlert = UIAlertController
public typealias UITap = UITapGestureRecognizer

/// (IW 全局公共方法/属性)
public class iw {
    /// (断言).
    public struct assert {
        /// (condition 成立时，assertion failure 输出 message).
        public static func failure(_ condition: Bool, msg message: String) -> Void {
            condition.founded({ assertionFailure(message) })
        }
    }
    
    /// (App 全局设置).
    public struct app {
        /// (隐藏状态栏).
        public static func hideStatusBar(with animation: UIStatusBarAnimation) -> Void {
            UIApplication.shared.setStatusBarHidden(true, with: animation)
        }
        /// (显示状态栏).
        public static func showStatusBar(with animation: UIStatusBarAnimation) -> Void {
            UIApplication.shared.setStatusBarHidden(false, with: animation)
        }
    }
    
    /// (是否为 Debug 模式).
    public static let isDebugMode: Bool = {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }()
    
    ///  Previous viewController, set in `IWRootVC.viewWillDisappear`.
    /// (上一个控制器, 在 IWRootVC.viewWillDisappear 进行赋值).
    public weak static var previousViewController: UIViewController?
    
    /// Tabbar is exists.
    /// (UITabbar 是否存在(显示)).
    public static var isTabbarExists: Bool {
        let window = UIApplication.shared.delegate!.window!!
        if window.subviews.count == 0 { return false }
        
        var hasTabbar = false
        let vc = UIViewController.IWE.current()
        if vc != nil { if (vc?.tabBarController?.tabBar) != nil { hasTabbar = !vc!.tabBarController!.tabBar.isHidden } }
        
        let tabbarClass: AnyClass! = NSClassFromString("UILayoutContainerView")
        let windowFirst = window.subviews.first!
        if (windowFirst.isKind(of: tabbarClass)) {
            let findTabbar = iw.find(tabbarIn: window.subviews.first?.subviews)
            if hasTabbar && findTabbar { return true }
        }
        return false
    }
    
    /// 延迟执行, execution, cancel
    public struct delay {
        public typealias Task = (_ cancel: Bool) -> Void
        /// Running.
        public static func execution(delay dly: TimeInterval, toRun task: @escaping () -> ()) -> Task? {
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
        /// (取消延迟执行的任务 (执行开始前使用)).
        public static func cancel(_ task: Task?) {
            task?(true)
        }
    }
    
    /// (主线程).
    public struct main {
        
        /// (主线程执行).
        public static func execution(_ task: @escaping () -> Void) -> Void {
            DispatchQueue.main.async { task() }
        }
    }
    
    /// (子线程).
    public struct subThread {
        
        /// (子线程执行).
        ///
        /// - Parameters:
        ///   - qlabel: 子线程标识
        public static func execution(queueLabel qlabel: String, _ task: @escaping () -> Void) -> Void {
            DispatchQueue(label: qlabel).async { task() }
        }
    }
    
    /// (是否为 iPhone).
    public static let isiPhone = IWDevice.isiPhone
    /// (屏幕 Bounds).
    public static let screenBounds = UIScreen.main.bounds
    /// (屏幕 Size).
    public static let screenSize = iw.screenBounds.size
    /// (屏幕 Width).
    public static let screenWidth = iw.screenSize.width
    /// (屏幕 高度).
    public static let screenHeight = iw.screenSize.height
    
    /// (设备系统).
    public struct system {
        /// (系统版本号, 字符型).
        public static let version = UIDevice.current.systemVersion
    }
    
    /// (设备类型/平台).
    public struct platform {
        
        /// is simulator?
        /// (是否为模拟器).
        public static let isSimulator: Bool = {
            var isSim = false
            #if arch(i386) || arch(x86_64)
                isSim = true
            #endif
            return isSim
        }()
    }
    
    /// (try 事件).
    public struct `throw` {
        public static func should(_ do:() throws -> Void) -> Error? {
            do {
                try `do`()
                return nil
            } catch {
                return error
            }
        }
    }
    
    /// (在 App 内打开 app store 详情页).
    public struct appstore {
        /// (通过 AppID 显示对应的应用详情页).
        public static func show(with appID: String?) {
            let productViewController = IWStoreProductVC()
            productViewController.show(with: appID)
        }
    }
    
    /// (等待).
    public struct loading {
        public static func stopWaveLoading() -> Void {
            IWWaveLoadingView.shared.stopWave()
        }
        public static func showWaveLoading(withMaskType maskType: IWWaveLoadingView.MaskViewType = .none) -> Void {
            IWWaveLoadingView.shared.startWave(UIViewController.IWE.current(), useMask: maskType == .none ? false : true, maskType: maskType)
        }
    }
}

fileprivate extension iw {
    static func find(tabbarIn array: [UIView]?) -> Bool {
        if array.isSome {
            for obj in array! {
                let v = obj
                if v is UITabBar {
                    return !(v as! UITabBar).isHidden
                }
            }
        }
        return false
    }
}

// MARK:- 正则操作符

/// 正则操作符号
infix operator =~
/// (正则操作, 左边参数为文本, 右边参数为表达式).
public func =~ (content: String, matchs: String) -> Bool {
    return IWRegex.match(matchs, content)
}


// MARK:- Edge & Rect
/// Make UIEdgeInsets.
/// (返回一个 CGFloat > UIEdgeInsets).
public func MakeEdge(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsetsMake(top, left, bottom, right)
}
/// Make CGRect.
/// (返回一个 CGFloat > CGRect).
public func MakeRect(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
    return CGRect(x: x, y: y, width: width, height: height)
}
/// Make IndexPath.
/// (返回一个 IndexPath).
public func MakeIndex(_ row: Int, _ section: Int) -> IndexPath {
    return IndexPath(row: row, section: section)
}
/// Make CGSize
/// (返回一个 CGFloat > CGSize).
public func MakeSize(_ width: CGFloat, _ height: CGFloat) -> CGSize {
    return CGSize(width: width, height: height)
}
/// Make CGPoint
/// (返回一个 CGFloat > CGPoint).
public func MakePoint(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
    return CGPoint(x: x, y: y)
}

