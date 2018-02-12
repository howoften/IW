//  Created by iWe on 2017/9/20.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

private struct IWGestureRecognizerKey {
    static var handler: Void?
    static var handlerDelay: Void?
    static var shouldhandlerAction: Void?
}

public extension UIGestureRecognizer {
    
    public typealias IWGestureRecognizerHandler = (_ sender: UIGestureRecognizer, _ view: UIView?, _ state: UIGestureRecognizerState, _ location: CGPoint) -> Void
    
    private var iwe_handler: IWGestureRecognizerHandler? {
        get { return objc_getAssociatedObject(self, &IWGestureRecognizerKey.handler) as? IWGestureRecognizerHandler }
        set { objc_setAssociatedObject(self, &IWGestureRecognizerKey.handler, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    private var iwe_handlerDelay: TimeInterval {
        get { return objc_getAssociatedObject(self, &IWGestureRecognizerKey.handlerDelay) as! TimeInterval }
        set { objc_setAssociatedObject(self, &IWGestureRecognizerKey.handlerDelay, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
    private var iwe_shouldHandlerAction: Bool {
        get { return objc_getAssociatedObject(self, &IWGestureRecognizerKey.shouldhandlerAction) as! Bool }
        set { objc_setAssociatedObject(self, &IWGestureRecognizerKey.shouldhandlerAction, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }
    
    /// (定义一个手势).
    ///
    /// - Parameters:
    ///   - handler: 手势处理的事件
    ///   - delay: 延迟执行时间
    /// - Returns: 返回设定好的手势
    public class func iwe_recognizer(withHandler handler: IWGestureRecognizerHandler?, delay: TimeInterval = 0.0) -> UIGestureRecognizer {
        let a = self.init()
        a.iwe_handler = handler
        a.iwe_handlerDelay = delay
        a.addTarget(a, action: #selector(_handlerAction(_:)))
        return a
    }
    
    @objc private func _handlerAction(_ recognizer: UIGestureRecognizer) -> Void {
        guard let hd = recognizer.iwe_handler else { return }
        
        let delay = self.iwe_handlerDelay
        let location = self.location(in: self.view)
        let block = {
            if !self.iwe_shouldHandlerAction { return }
            hd(self, self.view, self.state, location)
        }
        
        self.iwe_shouldHandlerAction = true
        let _ = iw.delay.execution(delay: delay) {
            block()
        }
    }
    
    /// (获取当前手势直接作用到的 view).
    public var iwe_targetView: UIView? {
        let lc = self.location(in: self.view)
        let tgv = self.view?.hitTest(lc, with: nil)
        return tgv
    }
}

