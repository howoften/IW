//  Created by iWe on 2017/8/15.
//  Copyright © 2017年 iWe. All rights reserved.
//

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif

public final class IWView<View> {
    public let view: View
    public init(_ view: View) {
        self.view =  view
    }
}

public protocol IWViewCompatible {
    associatedtype IWE
    var iwe: IWE { get }
}

public extension IWViewCompatible {
    public var iwe: IWView<Self> {
        get { return IWView(self) }
    }
}

#if os(macOS)
extension NSView: IWViewCompatible { }
#else
extension UIView: IWViewCompatible { }
#endif

extension IWView where View: UIView {
    
    @discardableResult public func isHidden(_ hidden: Bool) -> IWObserver {
        let ob = IWObserver.init(self.view)
        ob.do(self.view.isHidden = hidden)
        return ob
    }
}

extension IWView where View: UIButton {
    
    @discardableResult public func isEnable(_ enable: Bool) -> IWObserver {
        let ob = IWObserver.init(self.view)
        ob.do(self.view.isEnabled = enable)
        return ob
    }
    
}

public class IWObserver: NSObject {
    
    public var view: UIView!
    public var doSomething: (() -> Void)?
    
    public convenience init(_ view: UIView) {
        self.init()
        self.view = view
    }
    
    public func `do`(_ something: @autoclosure @escaping () -> Void) -> Void {
        self.doSomething = something
    }
    
    public func `where`(_ condition: @autoclosure () -> Bool) -> Void {
        if condition() { self.doSomething?() }
    }
    
}
