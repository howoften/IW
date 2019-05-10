//  Created by iWw on 23/01/2018.
//  Copyright © 2018 iWe. All rights reserved.
//

#if os(macOS)
    import Cocoa
    public typealias IWSize = NSSize
#else
    import UIKit
    public typealias IWSize = CGSize
#endif


public extension IWSize {
    
    /// (是否为空, width<=0 or height<=0 则为空).
    var isEmpty: Bool {
        return isWidthEmpty || isHeightEmpty
    }
    
    /// (value.width <= 0).
    var isWidthEmpty: Bool {
        return self.width <= 0
    }
    
    /// (value.height <= 0).
    var isHeightEmpty: Bool {
        return self.height <= 0
    }
    
    /// Convert to CGRect: CGRect(x: 0, y: 0, width: value.width, height: value.height).
    var toBounds: IWRect {
        return MakeRect(0, 0, self.width, self.height)
    }
    
    /// Convert size to Bounds: CGRect, x&y is 0.
    /// (将 size 转换为 bounds: CGRect).
    var toRect: IWRect {
        return MakeRect(0, 0, self.width, self.height)
    }
    
    /// Check size, ensure that no less than 0.
    /// (将 size 重新验证一遍, 确保 width&height 均不会小于 0).
    var fix: IWSize {
        return MakeSize(max(self.width, 0), max(self.height, 0))
    }
    
}

public extension IWSize {
    
    /// (是否为空, width<=0 or height<=0 则为空).
    static func isEmpty(_ size: IWSize) -> Bool {
        return size.width <= 0 || size.height <= 0
    }
    
}
