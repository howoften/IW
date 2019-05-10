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
    
    /// (.origin.x).
    var x: CGFloat {
        get { return self.origin.x }
        set { self.origin.x = newValue }
    }
    /// (.origin.y).
    var y: CGFloat {
        get { return self.origin.y }
        set { self.origin.y = newValue }
    }
    /// (.size.width).
    var width: CGFloat {
        get { return self.size.width }
        set { self.size.width = newValue }
    }
    /// (size.height).
    var height: CGFloat {
        get { return self.size.height }
        set { self.size.height = newValue }
    }
    
}

#if os(macOS)

public extension IWRect {
    
    /// (屏幕大小, screen frame size).
    static let screenSize: IWSize = { return NSScreen.main.expect("The main? is null.").frame.size }()
    
}

#else

public extension IWRect {
    
    /// (屏幕大小, sceren bounds).
    static let screenBounds: IWRect = { return iw.screen.bounds }()
    
}

#endif

