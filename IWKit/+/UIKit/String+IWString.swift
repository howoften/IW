//
//  String+IWString.swift
//  haoduobaduo
//
//  Created by iWw on 2017/11/22.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

public final class IWString<iString> {
    public let str: iString
    public init(_ str: iString) {
        self.str =  str
    }
}

public protocol IWStringCompatible {
    associatedtype IWE
    var iwe: IWE { get }
}

public extension IWStringCompatible {
    public var iwe: IWString<Self> {
        get { return IWString(self) }
    }
}

extension String: IWStringCompatible { }


extension IWString where iString == String {
    
    func substring(from: String.Index) -> String {
        return String(str[from...])
    }
    
    func substring(to: String.Index) -> String {
        return String(str[...to])
    }
    
    func substring(with range: Range<String.Index>) -> String {
        return String(str[range])
    }
    
}


extension IWString where iString == Substring {
    
    var toString: String {
        return String(str)
    }
}
