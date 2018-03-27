//  Created by iWw on 2017/11/20.
//  Copyright © 2017年 iWe. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit

public typealias IWEventsHandler = ((_ sender: UIControl?) -> Void)

fileprivate class IWControlWrapper: NSObject {
    
    class func getHashKey(for controlEvents: UIControlEvents) -> String {
        return "\(controlEvents.rawValue)"
    }
    
    var controlEvents: UIControlEvents
    var handler: IWEventsHandler = { _ in }
    
    var hashKey: String { return "\(controlEvents.rawValue)" }
    
    init(withHandler handler: IWEventsHandler?, for controlEvents: UIControlEvents = .touchUpInside) {
        if let hd = handler {
            self.handler = hd
        }
        self.controlEvents = controlEvents
        super.init()
    }
    
    @objc func invoke(_ sender: UIControl) -> Void {
        self.handler(sender)
    }
    
    deinit {
        iPrint("The Target is dealloc.")
    }
    
}

private struct IWControlKey {
    static var dic: Void?
}

extension UIControl {
    /// (记录手势以及对应的操作).
    private var iwe_events: [String : IWControlWrapper?]? {
        get { return objc_getAssociatedObject(self, &IWControlKey.dic) as? [String: IWControlWrapper?] }
        set { objc_setAssociatedObject(self, &IWControlKey.dic, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    /// Events default is .touchUpInside.
    /// (触发事件, 默认手势为 .touchUpInside).
    ///
    /// - Parameters:
    ///   - controlEvents: Default is .touchUpInSide
    ///   - handler: Handler action
    public func iwe_addEvents(for controlEvents: UIControlEvents = .touchUpInside, _ handler: IWEventsHandler?) {
        if handler == nil { return }
        if iwe_events == nil { iwe_events = [String: IWControlWrapper?]() }
        
        let target = IWControlWrapper(withHandler: handler, for: controlEvents)
        iwe_events![target.hashKey] = target
        self.addTarget(target, action: #selector(IWControlWrapper.invoke(_:)), for: target.controlEvents)
    }
    
    /// Remove control events by UIControlEvents.
    /// (移除指定的事件).
    ///
    /// - Parameter controlEvents: UIControlEvents.
    public func iwe_removeEvents(for controlEvents: UIControlEvents = .touchUpInside) -> Void {
        if iwe_events == nil { iwe_events = [String: IWControlWrapper?]() }
        
        let key = IWControlWrapper.getHashKey(for: controlEvents)
        iwe_events?.keys.contains(key).founded({
            iwe_events!.removeValue(forKey: key);
            self.removeTarget(key, action: nil, for: controlEvents)
        })
    }
    
    /// Control events has been exists.
    /// (判断事件是否存在).
    ///
    /// - Parameter controlEvents: UIControlEvents.
    /// - Returns: There is a return to true, otherwise false is returned.
    public func iwe_hasHandler(for controlEvents: UIControlEvents = .touchUpInside) -> Bool {
        if iwe_events == nil { iwe_events = [String: IWControlWrapper?]() }
        
        let key = IWControlWrapper.getHashKey(for: controlEvents)
        return iwe_events![key].and(then: { $0.isSome }).or(false)
    }
}
    
#endif
