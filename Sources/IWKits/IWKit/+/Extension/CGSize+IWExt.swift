//  Created by iWw on 23/01/2018.
//  Copyright © 2018 iWe. All rights reserved.
//

import UIKit

public extension CGSize {
    
    /// (是否为空, width<=0 or height<=0 则为空).
    public var isEmpty: Bool {
        return isWidthEmpty || isHeightEmpty
    }
    
    /// (value.width <= 0).
    public var isWidthEmpty: Bool {
        return self.width <= 0
    }
    
    /// (value.height <= 0).
    public var isHeightEmpty: Bool {
        return self.height <= 0
    }
    
    /// Convert to CGRect: CGRect(x: 0, y: 0, width: value.width, height: value.height).
    public var toBounds: CGRect {
        return MakeRect(0, 0, self.width, self.height)
    }
    
    /// Convert size to Bounds: CGRect, x&y is 0.
    /// (将 size 转换为 bounds: CGRect).
    public var toRect: CGRect {
        return MakeRect(0, 0, self.width, self.height)
    }
    
    /// Check size, ensure that no less than 0.
    /// (将 size 重新验证一遍, 确保 width&height 均不会小于 0).
    public var fix: CGSize {
        return MakeSize(max(self.width, 0), max(self.height, 0))
    }
    
}

public extension CGSize {
    
    /// (是否为空, width<=0 or height<=0 则为空).
    public static func isEmpty(_ size: CGSize) -> Bool {
        return size.width <= 0 || size.height <= 0
    }
    
}
