//  Created by iWw on 2018/3/14.
//  Copyright © 2018年 iWe. All rights reserved.
//

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif

public extension FloatingPoint {
    
    /// (取绝对值).
    public var abs: Self { return Swift.abs(self) }
    /// (是否为正数).
    public var isPositive: Bool { return self > 0 }
    /// (是否为负数).
    public var isNegative: Bool { return self < 0 }
    /// (向上取整).
    public var ceil: Self { return Foundation.ceil(self) }
    /// (向下取整).
    public var floor: Self { return Foundation.floor(self) }
    
}
