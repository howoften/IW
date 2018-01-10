//
//  String+IWString.swift
//  haoduobaduo
//
//  Created by iWw on 2017/11/22.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit
import CCommonCrypto

public final class IWString<iString> {
    /// (自身).
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

public extension IWString where iString == String {
    
    /// (从 from 开始截取字符串).
    func substring(from: String.Index) -> String {
        return String(self.str[from...])
    }
    /// (从开始截取到to字符串).
    func substring(to: String.Index) -> String {
        return String(self.str[...to])
    }
    /// (截取range范围中的字符串).
    func substring(with range: Range<String.Index>) -> String {
        return String(self.str[range])
    }
    /// (去除空格和换行符).
    var trim: String {
        return (self.str as NSString).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    /// (去除空格).
    var trimWithSpace: String {
        return (self.str as NSString).replacingOccurrences(of: "\\s", with: "", options: NSString.CompareOptions.regularExpression, range: NSMakeRange(0, self.str.count))
    }
    /// (去除换行符).
    var trimLineBreakCharacter: String {
        return (self.str as NSString).replacingOccurrences(of: "[\r\n]", with: " ", options: NSString.CompareOptions.regularExpression, range: NSMakeRange(0, self.str.count))
    }
    /// (md5加密).
    var md5: String {
        let cStr = self.str.cString(using: String.Encoding.utf8)
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
        let md5String = NSMutableString();
        for i in 0 ..< 16{
            md5String.appendFormat("%02x", buffer[i])
        }
        free(buffer)
        return md5String as String
    }
    /// (秒时间转换为: 分:秒).
    func timeWithMinsAndSecs(fromSecs secs: Double) -> String {
        let min = floor(secs / 60)
        let sec = floor(secs - min * 60)
        return "\(min):\(sec)"
    }
    /// (加载 Path 文件内容, 确保 str 为文件路径).
    var loadFileContents: String? {
        if let data = FileManager.default.contents(atPath: self.str) {
            return data.iwe.stringValue
        }
        return nil
    }
    
    
}


public extension IWString where iString == Substring {
    /// (转化为String).
    var toString: String {
        return String(str)
    }
}
