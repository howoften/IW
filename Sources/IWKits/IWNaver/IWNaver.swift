//  Created by iWw on 2018/4/14.
//  Copyright © 2018年 iWe. All rights reserved.
//

/**
 以域名为操作状态，path为控制器跳转内容，参数为传递内容
 
 naver://
 . 当前
 ./xx 从当前跳转到xx
 ./xx/xx1/xx2/xx3 从当前跳转到xx3 (xx3默认返回到 xx2)
 .. 返回上一级
 ../ 返回上一级
 ../xx 返回上一级再push到xx
 
 / 返回根视图
 /xx 返回到根视图再push到xx
 
 t0 切换到tabbar的第1个
 t1 切换到tabbar的第2个 ...依次类推
 
 t0/xx/xx1/xx2/xx3 切换到第0个标签 并push到xx3 (xx3默认返回到 xx2)
 
 
 t0/xx/xx1/xx2    当前目录切换到第0个标签并push到xx2
 ./t0/xx/xx1/xx2  当前目录切换到第0个标签并push到xx2
 
 // ../t0/xx/xx1/xx2 当前目录返回上一级再切换到0 再push到xx2
 
 */

import UIKit

/// (IWNaver 返回根视图).
public let IWNaverBackToRoot = "/"
/// (IWNaver 返回上一级视图).
public let IWNaverBackToPrevious = ".."

/// (Push/Back, URL 解决方案).
public class IWNaver: NSObject {
    
    public static let shared = IWNaver()
    
    /// (使用别名进行解析, 默认为 false).
    public var useAlias = false
    
    private var _nextPushWithoutAnimation = false
    /// (下一次 push 时，没有动画效果).
    public var nextPushWithoutAnimation: Bool {
        get {
            if _nextPushWithoutAnimation {
                _nextPushWithoutAnimation = false
                return !_nextPushWithoutAnimation
            }
            return false
        }
        set { _nextPushWithoutAnimation = newValue }
    }
    
    private var _nextPopWithoutAnimation = false
    /// (下一次 pop 时，没有动画效果).
    public var nextPopWithoutAnimation: Bool {
        get {
            if _nextPopWithoutAnimation {
                _nextPopWithoutAnimation = false
                return !_nextPopWithoutAnimation
            }
            return false
        }
        set { _nextPopWithoutAnimation = newValue }
    }
    
    private let appScheme = "naver"
    private var bundleName: String {
        return IWApp.bundleName.expect("获取 bundle name 失败, 若不知道怎么处理，直接将 bdName 改成当前项目的名称即可!")
    }
    
    public func naver(_ url: String) {
        let ana = analysis(str: url)
        // 为 naver 方式
        if ana.scheme == appScheme {
            
            switch ana.naverType {
            case .points: pushWithPoints(ana)
            case .toRoot: backToRootVC()
            case .tabbar: changeWithTabbar(ana)
            case .unknow: fatalError("\(ana.url.absoluteString) 无法解析 naver 类型。")
            }
            
        } else if ana.scheme.is(in: ["http", "https"]) {
            // 浏览器链接
            iPrint("\(ana.url.absoluteString) 是浏览器链接")
        } else {
            // 其它类型链接
            iPrint("\(ana.url.absoluteString) 是其它类型链接")
        }
    }
    
    public func push(to url: String) {
        naver(url)
    }
    
    private func analysis(str: String) -> IWNaverInfo {
        var checkStr = str
        if !str.containsEx(in: ["http://", "https://", "naver://"]) {
            checkStr = "naver://" + str
        }
        guard let url = URL(string: checkStr) else { fatalError("无法转换为 url") }
        guard let scheme = url.scheme else { fatalError("非法 scheme") }
        //guard let host = url.host else { fatalError("非法 host") }
        let host = url.host
        
        let model = IWNaverInfo()
        model.url = url
        model.scheme = scheme
        model.host = host
        model.params = url.submissionParameters?.toParameters
        model.pathComponents = url.pathComponents
        model.lastPath = url.lastPathComponent
        
        if isBackToRootVC(checkStr) {
            model.naverType = .toRoot
        } else if hasOnePoint(in: host.orEmpty) || hasTwoPoints(in: host.orEmpty) {
            model.naverType = .points
        } else if hasTabbar(in: url.host.orEmpty) {
            model.naverType = .tabbar
        } else {
            model.naverType = .unknow
        }
        
        return model
    }
    
    private func handlerPathComponents(with naver: IWNaverInfo) {
        
        guard naver.pathComponents.count > 1 || naver.lastPath != "" else {
            return
        }
        
        if naver.lastPath == "" {
            return
        }
        
        let irvc = initViewController(with: naver.lastPath)
        naver.previousVC = "\(getCurrentVC())"
        naver.previousVCInstance = getCurrentVC()
        irvc.naver = naver
        getCurrentVC().iwe.push(to: irvc, !nextPushWithoutAnimation)
        
        guard naver.pathComponents.count > 2 else { return }
        
        // 当前控制器
        guard var vcs = getCurrentVC().navigationController?.viewControllers else { fatalError("没有控制器 无法跳转") }
        guard let displayVCCurrentIdx = vcs.index(of: getCurrentVC()) else { fatalError("无法找到当前显示在屏幕的控制器的位置") }
        for (idx, pathClassStr) in naver.pathComponents.enumerated() {
            if idx == 0, pathClassStr == "/" { continue }
            if idx == naver.pathComponents.count - 1 {
                // 最后一个
                break
            } else {
                let irvc = initViewController(with: pathClassStr)
                vcs.insert(irvc, at: naver.naverType == .tabbar ? (displayVCCurrentIdx + idx) : (displayVCCurrentIdx + idx - 1))
            }
        }
        getCurrentVC().navigationController?.viewControllers = vcs
    }
    
    private func changeWithTabbar(_ naver: IWNaverInfo) {
        guard let tabbarInfo = naver.host.toArray else { fatalError("无法解析 \(naver.url.absoluteString)") }
        getCurrentVC().tabBarController?.selectedIndex = tabbarInfo.last.or("0").toInt
        
        handlerPathComponents(with: naver)
    }
    
    private func pushWithPoints(_ naver: IWNaverInfo) {
        guard let points = naver.host else {
            if naver.lastPath == "/", naver.pathComponents.count == 1 {
                // 返回根目录
                backToRootVC()
            }
            return
        }
        if hasOnePoint(in: points) {
            // naver://./UIViewController
            handlerPathComponents(with: naver)
        } else {
            // naver://../UIViewController     naver://..      naver://../
            // 返回上一级 再 push                返回根视图        返回上一级
            if naver.lastPath != "", naver.lastPath != "/" {
                // 返回上一级再push
                _backToPrevious(andPushWith: naver)
            } else if naver.pathComponents.count == 0 {
                // 返回根视图
                _pushToRootVC()
            } else if naver.pathComponents.count == 1 {
                // 返回上一级
                _backToPrevious()
            }
        }
    }
}

extension IWNaver {
    
    /// 修正 class
    private func fixClass(with classStr: String!) -> AnyObject {
        guard classStr != nil else { fatalError("Path 为空") }
        if classStr.contains(bundleName) {
            guard let pathClass = NSClassFromString(classStr!) else { fatalError("Path:\(classStr) 转换 class 失败") }
            return pathClass
        }
        guard let pathClass = NSClassFromString("\(bundleName).\(classStr!)") else { fatalError("Path:\(classStr) 转换 class 失败") }
        return pathClass
    }
    /// 初始化 class
    private func initClass(_ `class`: AnyObject) -> IWRootVC {
        let vcClass: IWRootVC.Type = `class` as! IWRootVC.Type
        return vcClass.init()
    }
    /// 通过 lastPath 动态初始化 view controller
    private func initViewController(with lastPath: String) -> IWRootVC {
        let cls = fixClass(with: lastPath)
        return initClass(cls)
    }
    
}

extension IWNaver {
    
    private func _pushToRootVC() {
        backToRootVC()
    }
    
    /// 返回上一级界面
    private func _backToPrevious() {
        if getCurrentVC().iwe.shouldUsePop {
            getCurrentVC().iwe.backToPreviousController(!nextPopWithoutAnimation)
            return
        }
        getCurrentVC().iwe.backToPreviousController()
    }
    
    /// 返回上一级界面 并 再次 push 到另一个界面
    private func _backToPrevious(andPushWith naver: IWNaverInfo) {
        _backToPrevious()
        handlerPathComponents(with: naver)
    }
    
    /// 返回根视图
    private func backToRootVC() {
        if let controllers = getCurrentVC().navigationController?.viewControllers, controllers.count > 1 {
            if controllers[safe: controllers.count - 1] == getCurrentVC() {
                // push
                getCurrentVC().navigationController?.popToRootViewController(animated: !nextPopWithoutAnimation)
            }
        }
    }
    
}


// MARK:- has Private
extension IWNaver {
    
    /// 是否为返回到根视图
    private func isBackToRootVC(_ url: String) -> Bool {
        return url == "naver:///"
    }
    /// host 是否包含 .
    private func hasPoints(in host: String) -> Bool {
        return host.contains(".")
    }
    /// host 是否只包含一个 .
    private func hasOnePoint(in host: String) -> Bool {
        return host == "."
    }
    /// host 是否只包含两个 ..
    private func hasTwoPoints(in host: String) -> Bool {
        return host == ".."
    }
    
    private func hasTabbar(in host: String) -> Bool {
        return host.matches("^t\\d+$")
    }
    
    private func getCurrentVC() -> UIViewController {
        guard let vc = UIViewController.IWE.current() else { fatalError("没有获取到当前控制器") }
        return vc
    }
    
}
