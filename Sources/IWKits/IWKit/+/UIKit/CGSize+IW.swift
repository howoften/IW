//  Created by iWe on 2017/12/4.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

public final class IWSize<iSize> {
    /// (自身).
    public let size: iSize
    public init(_ size: iSize) {
        self.size = size
    }
}

public protocol IWSizeCompatible {
    associatedtype IWE
    var iwe: IWE { get }
}

public extension IWSizeCompatible {
    public var iwe: IWSize<Self> {
        get { return IWSize(self) }
    }
}

extension CGSize: IWSizeCompatible { }

extension IWSize where iSize == CGSize {
    
    /// Convert size to Bounds: CGRect, x&y is 0.
    /// (将 size 转换为 bounds: CGRect).
    public final var rect: CGRect {
        return MakeRect(0, 0, self.size.width, self.size.height)
    }
    
    /// Check size, ensure that no less than 0.
    /// (将 size 重新验证一遍, 确保不会小于 0).
    public final var fix: CGSize {
        return MakeSize(max(self.size.width, 0), max(self.size.height, 0))
    }
    
}

