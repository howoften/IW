//  Created by iWw on 2018/3/14.
//  Copyright © 2018年 iWe. All rights reserved.
//

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif

public extension CGColor {
    
    #if !os(macOS)
    public var toUIColor: UIColor? {
        return UIColor(cgColor: self)
    }
    #endif
    
    #if os(macOS)
    public var toNSColor: NSColor? {
    return NSColor(cgColor: self)
    }
    #endif
}
