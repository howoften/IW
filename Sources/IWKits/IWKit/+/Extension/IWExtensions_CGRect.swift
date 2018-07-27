//  Created by iWw on 23/01/2018.
//  Copyright © 2018 iWe. All rights reserved.
//

#if os(macOS)
    import Cocoa
    public typealias IWRect = NSRect
#else
    import UIKit
    public typealias IWRect = CGRect
#endif

public extension IWRect {
    
    #if os(iOS)
    /// (屏幕大小, scrren bounds).
    public static let screenBounds: IWRect = { return iw.screen.bounds }()
    #endif
    
    /// (.origin.x).
    public var x: CGFloat {
        get { return self.origin.x }
        set { self.origin.x = newValue }
    }
    /// (.origin.y).
    public var y: CGFloat {
        get { return self.origin.y }
        set { self.origin.y = newValue }
    }
    /// (.size.width).
    public var width: CGFloat {
        get { return self.size.width }
        set { self.size.width = newValue }
    }
    /// (size.height).
    public var height: CGFloat {
        get { return self.size.height }
        set { self.size.height = newValue }
    }
}
