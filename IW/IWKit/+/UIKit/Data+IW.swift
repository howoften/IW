//
//  Data+IW.swift
//  haoduobaduo
//
//  Created by iWe on 2017/12/4.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

public final class IWData<iData> {
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
	
	/// 将 Data 转换为 UTF8 类型的字符串, 可能为 nil
	final var string: String? {
		return String.init(data: self.data, encoding: .utf8)
	}
	
	/// 将 Data 转换为 UTF8 类型的字符串, 为 nil 时自动转换为空 ""
	final var stringValue: String {
		return self.string ?? ""
	}
	
}
