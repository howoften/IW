//  Created by iWw on 2018/3/14.
//  Copyright © 2018年 iWe. All rights reserved.
//

#if os(iOS)
    import UIKit
#endif

public extension Int {
    
    public var toString: String {
        return "\(self)"
    }
    
    /// (返回一个 0 ..< self 的区间).
    public var countableRange: CountableRange<Int> {
        return 0 ..< self
    }
    /// (返回一个 0 ... self 的区间).
    public var closeRange: ClosedRange<Int> {
        return 0 ... self
    }
    
    public var toCGFloat: CGFloat {
        return CGFloat(self)
    }
    
    /// (取一个从 from - to 之间的数)
    public static func random(from: Int = 0, to: Int) -> Int {
        guard from < to else { return 0 }
        return Int(arc4random() % UInt32(to)) + from
    }
    public static var random: Int {
        return Int(arc4random() % 100) + 1
    }
    
    /// (是否为质数).
    ///     质数定义为在大于1的自然数中，除了1和它本身以外不再有其他因数。
    public var isPrime: Bool {
        if self == 2 { return true }
        guard self > 1, self % 2 != 0 else { return false }
        
        let base = Int(sqrt(Double(self)))
        for i in Swift.stride(from: 3, through: base, by: 2) where self % i == 0 {
            return false
        }
        return true
    }
}
