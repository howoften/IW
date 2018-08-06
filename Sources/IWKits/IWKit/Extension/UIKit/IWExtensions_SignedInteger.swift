//  Created by iWw on 2018/3/14.
//  Copyright © 2018年 iWe. All rights reserved.
//

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif


public extension SignedInteger {
    
    /// (取绝对值).
    public var abs: Self { return Swift.abs(self) }
    /// (是否为正数, int > 0).
    public var isPositive: Bool { return self > 0 }
    /// (是否为负数, int < 0).
    public var isNegative: Bool { return self < 0 }
    /// (是否为偶数, (int % 2) == 0).
    public var isEven: Bool { return (self % 2) == 0 }
    /// (是否为奇数, (int % 2) != 0).
    public var isOdd: Bool { return (self % 2) != 0 }
    /// (Bool, value > 0?).
    public var bool: Bool {
        return self > 0
    }
    
    public var timeStr: String {
        guard self > 0 else { return "0 sec" }
        if self < 60 { return "\(self) sec" }
        if self < 3600 { return "\(self / 60) min" }
        let hours = self / 3600
        let mins = (self % 3600) / 60
        if hours != 0, mins == 0 {
            return "\(hours) h"
        }
        return "\(hours)h \(mins)m"
    }
    
    public var toSize: IWSize {
        let wh = CGFloat(Int(self))
        return MakeSize(wh, wh)
    }
    
}
