//  Created by iWe on 2017/7/7.
//  Copyright © 2017年 iWe. All rights reserved.
//

#if os(macOS)
    import Cocoa
    public typealias NSVC = NSViewController
#else
    import UIKit
    public typealias UIAlert = UIAlertController
    public typealias UITap = UITapGestureRecognizer
    public typealias UIVC = UIViewController
#endif
import StoreKit // 应用内打开 app store 详情页

/// (IW 全局公共方法/属性)
public struct iw {
    
    public struct appInfoDictionary {
        public static let infoDictionary: [String: Any]? = Bundle.main.infoDictionary
    }
    
    #if os(iOS)
    struct naver {
        static func url(_ url: String, completed: IWNaver.CompletedHandler? = nil) {
            if completed.isSome {
                IWNaver.shared.naver(url, completed: completed!)
            } else {
                IWNaver.shared.naver(url)
            }
        }
    }
    #endif
    
    /// (线程).
    public struct queue {
        
        /// (单例, DispatchQueue.once).
        public static func once(token: String, block: @escaping () -> Void) -> Void {
            DispatchQueue.once(token: token, block: block)
        }
        
        /// (主线程执行, DispatchQueue.main.async).
        public static func main(_ task: @escaping () -> Void) -> Void {
            if Thread.isMainThread {
                task()
            } else {
                DispatchQueue.main.async { task() }
            }
        }
        
        /// (子线程执行, DispatchQueue(label: qlabel).async { }).
        ///
        /// - Parameters:
        ///   - qlabel: 子线程标识
        public static func subThread(label qlabel: String, _ task: @escaping () -> Void) -> Void {
            DispatchQueue(label: qlabel).async { task() }
        }
    }
    
    #if os(iOS)
    /// (批量设置圆角).
    public static func round(_ corner: CGFloat, toViews views: [UIView]) {
        views.forEach({ $0.iwe.round(corner) })
    }
    #endif
    
    /// (断言).
    public struct assert {
        /// (condition 成立时，assertion failure 输出 message).
        public static func failure(_ condition: Bool, msg message: String) -> Void {
            condition.founded({ assertionFailure(message) })
        }
    }
    
    #if os(iOS)
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
    #endif
    
    /// (是否为 Debug 模式).
    public static let isDebugMode: Bool = {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }()
    
    #if os(iOS)
    ///  Previous viewController, set in `IWRootVC.viewWillDisappear`.
    /// (上一个控制器, 在 IWRootVC.viewWillDisappear 进行赋值).
    public weak static var previousViewController: UIViewController?
    #endif
    
    #if os(iOS)
    /// Tabbar is exists.
    /// (UITabbar 是否存在(显示)).
    public static var isTabbarExists: Bool {
        let window = UIApplication.shared.delegate!.window!!
        if window.subviews.count == 0 { return false }
        
        var hasTabbar = false
        let vc = UIViewController.current
        if vc != nil { if (vc?.tabBarController?.tabBar) != nil { hasTabbar = !vc!.tabBarController!.tabBar.isHidden } }
        
        let tabbarClass: AnyClass! = NSClassFromString("UILayoutContainerView")
        let windowFirst = window.subviews.first!
        if (windowFirst.isKind(of: tabbarClass)) {
            let findTabbar = iw.find(tabbarIn: window.subviews.first?.subviews)
            if hasTabbar && findTabbar { return true }
        }
        return false
    }
    #endif
    
    /// 延迟执行, execution, cancel
    public struct delay {
        public typealias Task = (_ cancel: Bool) -> Void
        /// Running.
        @discardableResult public static func execution(delay dly: TimeInterval, toRun task: @escaping () -> ()) -> Task? {
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
    
    #if os(iOS)
    public struct screen {
        public static let bounds = UIScreen.main.bounds
        public static let size = screen.bounds.size
        public static let width = screen.size.width
        public static let height = screen.size.height
        
        public static let scale = UIScreen.main.scale
    }
    #endif
    
    #if os(iOS)
    /// (设备系统).
    public struct system {
        /// (系统版本号, 字符型).
        public static let version = UIDevice.current.systemVersion
    }
    #endif
    
    #if os(iOS)
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
        
        public static let isiPhone: Bool = IWDevice.isiPhone
        public static let isiPhoneX: Bool = IWDevice.isiPhoneX
    }
    #endif
    
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
    
    #if os(iOS)
    /// (在 App 内打开 app store 详情页).
    public struct appstore {
        /// (通过 AppID 显示对应的应用详情页).
        public static func show(with appID: String?) {
            let productViewController = IWStoreProductVC()
            productViewController.show(with: appID)
        }
    }
    #endif
    
    
    #if os(iOS)
    /// (等待).
    public struct loading {
        public static func stopWaveLoading() -> Void {
            IWWaveLoadingView.shared.stopWave()
        }
        public static func showWaveLoading(withMaskType maskType: IWWaveLoadingView.MaskViewType = .none) -> Void {
            IWWaveLoadingView.shared.startWave(UIViewController.current, useMask: maskType == .none ? false : true, maskType: maskType)
        }
    }
    #endif
    
    #if os(iOS)
    /// (输出设备信息, 机型 标识 OS版本).
    public static func outputDeviceInfos() -> Void {
        var infos = "-- iw.outputDeviceInfos"
        infos += """
        
         固件类型: \(IWDevice.deviceName)
         设备机型: \(IWDevice.modelName)
         设备机名: \(IWDevice.aboutPhoneName)
         系统版本: \(iw.system.version)
         内部标识: \(IWDevice.modelIdentifier)
         是否越狱: \(IWDevice.isJailbroken.map("是", "否"))
         应用名称: \(IWApp.name.or("未知"))
         应用版本: \(IWApp.shortVersion.or("1.0")) build \(IWApp.build.or("1"))
         应用标识: \(IWApp.bundleIdentifier.or("未知"))
         最低支持: \(IWApp.minimumOSVersion.or("未知"))
         需要加入: \(IWApp.infoDictionary.map({ $0.has(key: "UIRequiredDeviceCapabilities").map("无需加入 UIRequiredDeviceCapabilities", "需要在 info.plist 中添加 UIRequiredDeviceCapabilities") }).or("未知"))
        
         设备屏幕缩放比例: \(UIScreen.main.scale)
         物理分辨率(width*height): \(iw.screen.width) * \(iw.screen.height)
         实际分辨率(width*height): \(iw.screen.width * UIScreen.main.scale) * \(iw.screen.height * UIScreen.main.scale)
        """
        infos += "\n--------------------------------------------------"
        iPrint(infos)
    }
    #endif
    
    
    #if os(iOS)
    /// (是否安装).
    public struct installed {
        /// (是否安装 QQ).
        static var qq: Bool {
            return UIApplication.shared.canOpenURL("qq://".toURLValue)
        }
        /// (是否安装 TIM).
        static var tim: Bool {
            return UIApplication.shared.canOpenURL("tim://".toURLValue)
        }
        /// (是否安装 微信).
        static var wechat: Bool {
            return UIApplication.shared.canOpenURL("wechat://".toURLValue)
        }
        /// (是否安装 支付宝).
        static var alipay: Bool {
            return UIApplication.shared.canOpenURL("alipay://".toURLValue)
        }
        /// (是否安装 淘宝).
        static var taobao: Bool {
            return UIApplication.shared.canOpenURL("taobao://".toURLValue)
        }
        /// (是否安装 微博).
        static var weibo: Bool {
            return UIApplication.shared.canOpenURL("weibo://".toURLValue)
        }
    }
    #endif
}

#if os(iOS)
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
#endif

// MARK:- 正则操作符

/// 正则操作符号
infix operator =~
/// (正则操作, 左边参数为文本, 右边参数为表达式).
public func =~ (content: String, matchs: String) -> Bool {
    return IWRegex.match(matchs, content)
}


#if os(macOS)
// MARK:- Edge & Rect
/// Make UIEdgeInsets.
/// (返回一个 CGFloat > UIEdgeInsets).
public func MakeEdge(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) -> NSEdgeInsets {
    return NSEdgeInsetsMake(top, left, bottom, right)
}
#else
// MARK:- Edge & Rect
/// Make UIEdgeInsets.
/// (返回一个 CGFloat > UIEdgeInsets).
public func MakeEdge(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsetsMake(top, left, bottom, right)
}
#endif

/// Make CGRect.
/// (返回一个 CGFloat > CGRect).
public func MakeRect(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> IWRect {
    return IWRect(x: x, y: y, width: width, height: height)
}

#if os(macOS)
/// Make IndexPath.
/// (返回一个 IndexPath).
public func MakeIndex(_ item: Int, _ section: Int) -> IndexPath {
    return IndexPath(item: item, section: section)
}
#else
/// Make IndexPath.
/// (返回一个 IndexPath).
public func MakeIndex(_ row: Int, _ section: Int) -> IndexPath {
    return IndexPath(row: row, section: section)
}
#endif


/// Make CGSize
/// (返回一个 CGFloat > CGSize).
public func MakeSize(_ width: CGFloat, _ height: CGFloat) -> IWSize {
    return CGSize(width: width, height: height)
}
/// Make CGPoint
/// (返回一个 CGFloat > CGPoint).
public func MakePoint(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
    return CGPoint(x: x, y: y)
}

/// (If the condition is true, `todo()` is executed ...).
public func ifc(_ condition: Bool, _ todo: @autoclosure () throws -> Void) rethrows -> Void {
    if condition { try todo() }
}
/// (If the condition is true, `todo()` is executed ...).
public func ifc(_ condition: Bool, _ todo: @autoclosure () throws -> Void, else: @autoclosure () throws -> Void) rethrows -> Void {
    if condition { try todo() } else { try `else`() }
}
