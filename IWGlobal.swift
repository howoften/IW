//
//  IWGlobal.swift
//  haoduobaduo
//
//  Created by iWe on 2017/7/7.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

typealias UIAlert = UIAlertController
typealias UITap = UITapGestureRecognizer

let ikScreenBounds = UIScreen.main.bounds
let ikScreenSize = ikScreenBounds.size
let ikScreenW = ikScreenSize.width
let ikScreenH = ikScreenSize.height

let iOSVersion = UIDevice.current.systemVersion.toInt
let iOSVersionS = UIDevice.current.systemVersion

let isIPhone = (UIDevice.current.model == "iPhone")

// Set in IWRootVC.viewWillDisappear
weak var previousViewController: UIViewController?

// 当代码使用优化编译的时候，断言将会被禁用，例如在 Xcode 中，使用默认的 target Release 配置选项来 build 时，断言会被禁用。
private let kEnableAssert = 1
func iAssert(_ condition: Bool, _ tips: String) {
    if kEnableAssert == 1 {
        assert(condition, tips)
    }
}

/// Tabbar is showing?
///
/// - Returns: Return true when displayed.
func isShowingTabbar() -> Bool {
    let window = UIApplication.shared.delegate!.window!!
    if window.subviews.count == 0 {
        return false
    }
    
    var hasTabbar = false
    let vc = UIViewController.IWE.current()
    if vc != nil {
        if (vc?.tabBarController?.tabBar) != nil {
            hasTabbar = !vc!.tabBarController!.tabBar.isHidden
        }
    }
    
    let tabbarClass: AnyClass! = NSClassFromString("UILayoutContainerView")
    let windowFirst = window.subviews.first!
    if (windowFirst.isKind(of: tabbarClass)) {
        let findTabbar = find(tabbarIn: window.subviews.first?.subviews as NSArray?)
        if hasTabbar && findTabbar {
            return true
        }
    }
    return false
}
private func find(tabbarIn array: NSArray?) -> Bool {
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

// MARK:- 延迟执行
typealias Task = (_ cancel: Bool) -> Void
func delayExecution(_ time: TimeInterval, task: @escaping () -> ()) -> Task? {
    func dispatch_later(block: @escaping ()->()) {
        let t = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: t, execute: block)
    }
    var closure: (() -> Void)? = task
    var result: Task?
    
    let delayedClosure: Task = { cancel in
        if let internalClosure = closure {
            if (cancel == false) {
                DispatchQueue.main.async(execute: internalClosure)
            }
        }
        closure = nil
        result = nil
    }
    
    result = delayedClosure
    
    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(false)
        }
    }
    return result
}
func cancel(_ task: Task?) {
    task?(true)
}

// MARK:- 主线程执行
func main(_ task: @escaping () -> Void) -> Void {
    DispatchQueue.main.async {
        task()
    }
}

// MARK:- 子线程执行
func subThread(_ task: @escaping () -> Void) -> Void {
    DispatchQueue(label: "writeLog").async {
        task()
    }
}

// MARK:- 正则操作符
infix operator =~
func =~ (content: String, matchs: String) -> Bool {
    return IWRegex.match(matchs, content)
}


// MARK:- Edge & Rect
func MakeEdge(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsetsMake(top, left, bottom, right)
}
func MakeRect(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
    return CGRect(x: x, y: y, width: width, height: height)
}
func MakeIndex(_ row: Int, _ section: Int) -> IndexPath {
    return IndexPath(row: row, section: section)
}
func MakeSize(_ width: CGFloat, _ height: CGFloat) -> CGSize {
    return CGSize(width: width, height: height)
}


// MARK:- Platform
struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}
