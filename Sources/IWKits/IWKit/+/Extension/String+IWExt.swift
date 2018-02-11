//  Created by iWw on 23/01/2018.
//  Copyright © 2018 iWe. All rights reserved.
//

import UIKit

public extension String {
    
    private static let lineBreaks: String = "\r\n"
    
    /// Convert to Int
    public var toInt: Int {
        let text = self as NSString
        return text.integerValue
    }
    /// Convert to Float
    public var toFloat: Float {
        let text = self as NSString
        return text.floatValue
    }
    /// Convert to UIColor
    public var toColor: UIColor {
        return .iwe_hex(self)
    }
    /// Convert to UIColor
    public func toColor(_ alpha: Float) -> UIColor {
        return .iwe_hex(self, alpha)
    }
    /// Convert to URL
    public var toURL: URL? {
        return URL(string: self)
    }
    public var toURLValue: URL {
        return toURL!
    }
    /// Convert to URLRequest
    public var toURLRequest: URLRequest? {
        return self.toURL.and(then: { URLRequest(url: $0) })
    }
    public var toURLRequestValue: URLRequest {
        return toURLRequest!
    }
    /// Convert to AnyClass
    public var toAnyClass: AnyClass? {
        return NSClassFromString(self)
    }
    public var toAnyClassValue: AnyClass {
        return toAnyClass!
    }
    /// Convert to NSString
    public var toNSString: NSString {
        return self as NSString
    }
    /// Convert to double
    public var toDouble: Double {
        return (self as NSString).doubleValue
    }
    /// Convert to time and formatter: YYYY-MM-dd HH:mm:ss
    public var toDateTime: String {
        return IWTime.time(with: self)
    }
    public var toFileURL: URL {
        return URL(fileURLWithPath: self)
    }
    
    /// (base64 加密, 失败返回 nil).
    public var base64Encode: String? {
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        let dataString = data?.base64EncodedString(options: .endLineWithLineFeed)
        return dataString
    }
    /// (base64 解密, 失败返回 nil).
    public var base64Decode: String? {
        let data = Data.init(base64Encoded: self, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
        if data != nil {
            let decodeDataString = String.init(data: data!, encoding: String.Encoding.utf8)
            return decodeDataString
        }
        return nil
    }
    /// (URL 编码).
    public var urlEncode: String? {
        guard #available(iOS 9, *) else {
            let legalURLCharactersToBeEscaped: CFString = ":&=;+!@#$()',*" as CFString
            let str = CFURLCreateStringByAddingPercentEscapes(nil, self as CFString, nil, legalURLCharactersToBeEscaped, CFStringBuiltInEncodings.UTF8.rawValue) as String
            return str
        }
        let nsstr = self as NSString
        return nsstr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    /// (URL 解码).
    public var urlDecode: String? {
        return self.removingPercentEncoding
    }
    
    /// (获取最后一个字符串).
    public var lastCharacter: String {
        return (self.count == 1).true({ self }, elseReturn: { self[self.index(before: self.endIndex)...].toString })
    }
    /// (移除最后一个字符串).
    public var removeLastCharacter: String {
        return (self == "").true({ self }, elseReturn: { var str = self; str.remove(at: self.index(before: self.endIndex)); return str })
    }
    
    /// (移除所有空格).
    public var removeSpace: String {
        return remove(" ")
    }
    /// (移除所有换行).
    public var replaceLineBreaks: String {
        return replace("\r", to: "").replace("\n", to: "")
    }
    
    /// (获取文件名, 无扩展名).
    public var lastPathNotHasPathExtension: String? {
        return (self as NSString).pathComponents.last.and(then: { ($0 as NSString).deletingPathExtension })
    }
    /// (获取扩展名).
    public var pathExtension: String {
        return (self as NSString).pathExtension
    }
    /// (获取文件名, 有扩展名).
    public var lastPath: String {
        return (self as NSString).lastPathComponent
    }
    
    
    /// (第一个字符大写).
    public var uppercaseFirstCharecters: String {
        return self.uppercased(with: Locale.current)
    }
    /// (是否全为数字).
    public var isNumber: Bool {
        return self =~ "^\\d$"
    }
    /// (是否为电话号码).
    public var isPhoneNumber: Bool {
        return isCMCC.or(isCUCC).or(isCTCC)
    }
    /// (是否为移动号码段).
    public var isCMCC: Bool {
        let cmcc = "^((13)[4-9]|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8])|(198))\\d{8}$"
        let fictitious_cmcc = "^(170[3,5-6])\\d{7}$" // 虚拟号码段
        return (self =~ cmcc).or(self =~ fictitious_cmcc)
    }
    /// (是否为联通号码段).
    public var isCUCC: Bool {
        let cucc = "^((13)[0-2]|(145)|(15[5,6])|(166)|(17[5,6])|(18[5,6]))\\d{8}$"
        let fictitious_cucc = "^(170[4,7-9])\\d{7}|(171)\\d{8}$" // 虚拟号码段
        return (self =~ cucc).or(self =~ fictitious_cucc)
    }
    /// (是否为电信号码段).
    public var isCTCC: Bool {
        let ctcc = "^((133)|(149)|(153)|(17[3,7])|(18[0,1,9])|(199))\\d{8}$"
        let fictitious_ctcc = "^(170[0-2])\\d{7}$" // 虚拟号码段
        return (self =~ ctcc).or(self =~ fictitious_ctcc)
    }
    
    /// (是否为电子邮件).
    public var isEmail: Bool {
        let email = "^[A-Z0-9a-z._%+-]+@[A-Za-z]{2,4}$"
        return self =~ email
    }
    public func matches(_ predicate: String) -> Bool {
        return self =~ predicate
    }
    
    /// (随机生成一个 32 位字符串).
    public static var random32Bit: String {
        var string = ""
        for _ in 0 ..< 32 {
            let number = arc4random() % 36;
            if number < 10 {
                let figure = arc4random() % 10
                let tempString = "\(figure)"
                string = string + tempString
            } else {
                let figure = (arc4random() % 26) + 97
                let character = figure
                let tempString = "\(character)"
                string = string + tempString
            }
        }
        return string
    }
}



public extension String {
    
    public func toFileURL(isDirectory: Bool) -> URL {
        return URL(fileURLWithPath: self, isDirectory: isDirectory)
    }
    
    /// (计算文本 size).
    ///
    /// - Parameters:
    ///   - maskSize: 范围
    ///   - attributes: 样式, 例如: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]
    /// - Returns: 返回计算完成的 size
    public func toSize(with maskSize: CGSize, options: NSStringDrawingOptions, attributes: [NSAttributedStringKey: Any]?) -> CGSize {
        return (self as NSString).boundingRect(with: maskSize, options: options, attributes: attributes, context: nil).size
    }
    
    /// (提取对应的参数值, 例如: "index.php?id=1214".getParameterValue("id"), 结果为 1214 ).
    public func getParameterValue(_ parameter: String?) -> String? {
        return parameter.and(then: { IWRegex.expression($0 + "=[^&]+", content: self) }).and(then: { $0.components(separatedBy: "=").last })
    }
    
    /// (反向移除字符).
    ///
    /// - Parameter withNumber: 反向移除几个
    /// - Returns: 移除后的字符串
    public func reverseRemove(characters withNumber: Int) -> String {
        var str = self
        (0 ..< withNumber).forEach({ _ in str = str.removeLastCharacter })
        return str
    }
    
    /// (移除某个字符串).
    public func remove(_ string: String) -> String {
        return replace(string, to: "")
    }
    /// (移除包含在 strings 里面的的字符串).
    public func remove(_ strings: [String]) -> String {
        var temp = self
        strings.forEach({ temp = temp.replace($0, to: "") })
        return temp
    }
    /// (拼接路径/链接).
    public func splicing(_ path: String) -> String {
        let nsstr = self as NSString
        return nsstr.appendingPathComponent(path)
    }
    
    public func `is`(in equleTo: [String]) -> Bool {
        return equleTo.contains(where: { self == $0 })
    }
    public func containsEx(in contains: [String]) -> Bool {
        return contains.contains(where: { self.contains($0) })
    }
    public func hasPrefixEx(_ prefixs: [String]) -> Bool {
        return prefixs.contains(where: { self.hasPrefix($0) })
    }
    
    public func replace(_ string: String, to: String) -> String {
        return self.replacingOccurrences(of: string, with: to)
    }
    
    /// (拷贝至剪切板).
    public func copyToPasteboard() -> Void {
        UIPasteboard.general.string = self
    }
    
    public static func hexString(withInteger integer: NSInteger) -> String {
        var tempInteger = integer
        var hexStr = ""
        var remainder: NSInteger = 0
        for _ in 0 ..< 9 {
            remainder = tempInteger % 16
            tempInteger = tempInteger / 16
            let letter = self.hexLetterString(withInteger: remainder)
            hexStr = "\(letter)\(hexStr)"
            if integer == 0 {
                break
            }
        }
        return hexStr
    }
    
    /// (10进制转16进制, integer < 16).
    public static func hexLetterString(withInteger integer: NSInteger) -> String {
        assert(integer < 16, "要转换的数必须是16进制里的个位数，即小于16，但你写的是\(integer)")
        let hex = ["A", "B", "C", "D", "E", "F"]
        return (integer >= 10).true({ hex[integer - 10] }, elseReturn: { "\(integer)" })
    }
    
    public func index(offsetBy: String.IndexDistance) -> String.Index {
        return self.index(self.startIndex, offsetBy: offsetBy)
    }
    
    /// (发送邮件).
    public func sendEmail() {
        let mailAddress = self
        "mailto:\(mailAddress)".toURL.unwrapped({ openURL($0) })
    }
    
    /// (拨打电话).
    public func call() {
        let phoneNumber = self
        "tel:\(phoneNumber)".toURL.unwrapped({ openURL($0) })
    }
    
    /// (在 Safari 中打开).
    public func openURLInSafari() {
        self.toURL.unwrapped({openURL($0)})
    }
    
    /// (在 App Store 中打开, value 为 app 的 id)
    public func openInAppStore() {
        "itms-apps://itunes.apple.com/cn/app/id\(self)".toURL.unwrapped({openURL($0)})
    }
    
    private func openURL(_ url: URL) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(url)
        }
    }
    
    public func POST(_ paramters: Any? = nil, success: IWRequestResult.successedHandler?, failed: IWRequestResult.failedHandler? = nil) {
        IWRequest.post(self, parameters: paramters).result(success: { (data, dic, result) in
            iw.main.execution {
                success?(data, dic, result)
            }
        }) { (error) in
            iw.main.execution {
                failed?(error)
            }
        }
    }
    public func GET(_ parameters: Any? = nil, success: IWRequestResult.successedHandler?, failed: IWRequestResult.failedHandler?) {
        IWRequest.get(self, parameters: parameters).result(success: { (data, dic, result) in
            iw.main.execution {
                success?(data, dic, result)
            }
        }) { (error) in
            iw.main.execution {
                failed?(error)
            }
        }
    }
}

public extension Substring {
    
    public var toString: String {
        return String(self)
    }
}
