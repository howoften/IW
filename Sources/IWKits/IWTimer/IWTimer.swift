//  Created by iWe on 2017/7/6.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

/// (NSTimer 子类, 拥有更多便捷的使用方法, 例如倒计时).
public class IWTimer: Timer {
    
    /// (单例).
    private static let shared = IWTimer()
    
    fileprivate lazy var countDonws: NSMutableArray = {
        return NSMutableArray()
    }()
    
    /// Count down with GCD.
    /// (倒计时).
    ///
    /// - Parameters:
    ///   - time: 总时间
    ///   - intervalTime: 间隔
    ///   - identify: 标识, 请确保唯一性
    ///   - loadingHandler: 倒计时过程回调
    ///   - loaded: 倒计时完成回调
    public class func countDown(_ time: TimeInterval, intervalTime: TimeInterval, identify: String, loadingHandler:((_ currentTime: TimeInterval) -> Void)?, loaded:(() -> Void)?) {
        
        var itime = time
        let iintervalTime = intervalTime
        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
        let timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
        timer.schedule(deadline: .now(), repeating: .seconds(Int(iintervalTime)), leeway: .seconds(Int(itime)))
        timer.setEventHandler {
            if itime > 0 {
                DispatchQueue.main.async {
                    loadingHandler?(itime)
                }
                itime -= 1
            } else {
                timer.cancel()
                DispatchQueue.main.async {
                    loaded?()
                }
            }
        }
        
        let manage = IWTimerManage()
        manage.identify = identify
        manage.timer = timer
        IWTimer.shared.countDonws.add(manage)
        
        timer.resume()
    }
    
    /// No need to manually release Timer.
    ///
    /// - Parameters:
    ///   - interval: Interval time
    ///   - target: Target
    ///   - action: Action
    ///   - userInfo: User info
    ///   - repeats: Repeats
    /// - Returns: Timer
    public class func timer(_ interval: TimeInterval, target: AnyObject, action: Selector, userInfo: Any?, repeats: Bool) -> Timer {
        
        let timerTarget = IWWeakTimerTarget()
        timerTarget.iTarget = target
        timerTarget.iSelector = action
        timerTarget.iTimer = Timer.scheduledTimer(timeInterval: interval, target: target as Any, selector: action, userInfo: userInfo, repeats: repeats)
        return timerTarget.iTimer!
    }
    
    /// Block Timer
    public class func timer(_ interval: TimeInterval, loadingHandler:(_ userInfo: Any?) -> Void?, userInfo: Any?, repeats: Bool) -> Timer {
        let m = NSMutableArray(object: loadingHandler)
        if let u = userInfo {
            m.add(u)
        }
        return self.scheduledTimer(timeInterval: interval, target: self, selector: #selector(self.timerRunningHandler(_:)), userInfo: m.copy(), repeats: repeats)
    }
    
    @objc private func timerRunningHandler(_ userInfo: Array<Any>) {
        let block: ((_ userInfo: Any?) -> Void)? = userInfo.first! as? ((Any?) -> Void)
        var info: Any? = nil
        if userInfo.count == 2 {
            info = userInfo.last
        }
        if block != nil {
            block!(info)
        }
    }
    
}


// MARK:- Cancel
extension IWTimer {
    
    /// Cancel countdown by identity.
    /// (通过 identity 取消倒计时).
    ///
    /// - Parameter identify: 唯一标识
    public class func cancel(by identity: String) {
        var i = 0
        for row in IWTimer.shared.countDonws {
            let manage = row as! IWTimerManage
            if manage.identify! == identity {
                manage.timer!.cancel()
                break
            }
            i += 1
        }
        IWTimer.shared.countDonws.removeObject(at: i)
    }
    
}

private class IWWeakTimerTarget: NSObject {
    
    weak var iTarget: AnyObject?
    var iSelector: Selector?
    weak var iTimer: Timer?
    
    func fire(_ timer: Timer) {
        if let t = iTarget {
            t.perform(iSelector!, with: timer.userInfo, afterDelay: 0.0)
        } else {
            self.iTimer?.invalidate()
        }
    }
    
}

private class IWTimerManage: NSObject {
    
    var identify: String?
    var timer: DispatchSourceTimer?
    var isFinished: Bool?
    
}

