//  Created by iWw on 2018/3/14.
//  Copyright © 2018年 iWe. All rights reserved.
//

#if os(iOS)
    import UIKit
#endif

public extension Double {
    
    public var toInt: Int {
        return Int(self)
    }
    public var toFloat: Float {
        return Float(self)
    }
    public var toCGFloat: CGFloat {
        return CGFloat(self)
    }
    
    public var toString: String {
        return "\(self)"
    }
    /// (保留两位小数).
    public var retain: String {
        return String(format: "%.2f", self)
    }
    /// (保留 digit 位小数).
    public func retain(_ digit: Int) -> String {
        return String(format: "%.\(digit)f", self)
    }
    
}
