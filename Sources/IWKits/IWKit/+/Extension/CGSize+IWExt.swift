//  Created by iWw on 23/01/2018.
//  Copyright © 2018 iWe. All rights reserved.
//

import UIKit

public extension CGSize {
    
    /// (是否为空, width<=0 or height<=0 则为空).
    public var isEmpty: Bool {
        return self.width <= 0 || self.height <= 0
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
    public var bounds: CGRect {
        return toBounds
    }
}

public extension CGSize {
    
    /// (是否为空, width<=0 or height<=0 则为空).
    public static func isEmpty(_ size: CGSize) -> Bool {
        return size.width <= 0 || size.height <= 0
    }
    
}
