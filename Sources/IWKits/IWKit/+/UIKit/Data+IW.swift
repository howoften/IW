//
//  Data+IW.swift
//  haoduobaduo
//
//  Created by iWe on 2017/12/4.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

public final class IWData<iData> {
    /// (自身).
    public let data: iData
    public init(_ data: iData) {
        self.data = data
    }
}

public protocol IWDataCompatible {
    associatedtype IWE
    var iwe: IWE { get }
}

public extension IWDataCompatible {
    public var iwe: IWData<Self> {
        get { return IWData(self) }
    }
}

extension Data: IWDataCompatible { }

extension IWData where iData == Data {
    
    /// Convert to String use UTF8 encoding.
    /// (将 Data 转换为 UTF8 类型的字符串, 可能为 nil).
    final public var string: String? {
        return String.init(data: self.data, encoding: .utf8)
    }
    
    /// Convert to String use UTF8 encoding, if nil, than converted to empty str("").
    /// (将 Data 转换为 UTF8 类型的字符串, 为 nil 时自动转换为空 "").
    final public var stringValue: String {
        return self.string ?? ""
    }
    
}

