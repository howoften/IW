//  Created by iWw on 23/01/2018.
//  Copyright © 2018 iWe. All rights reserved.
//

import UIKit

public extension String {
    
    private static let lineBreaks: String = "\r\n"
    
    /// Convert to Int
    var toInt: Int {
        let text = self as NSString
        return text.integerValue
    }
    /// Convert to Float
    var toFloat: Float {
        let text = self as NSString
        return text.floatValue
    }
    /// Convert to UIColor
    var toColor: UIColor {
        return .iwe_hex(self)
    }
    /// Convert to UIColor
    func toColor(_ alpha: Float) -> UIColor {
        return .iwe_hex(self, alpha)
    }
    /// Convert to URL
    var toURL: URL? {
        return URL(string: self)
    }
    /// Convert to URLRequest
    var toURLRequest: URLRequest? {
        if let u = self.toURL {
            return URLRequest(url: u)
        }
        return nil
    }
    /// Convert to AnyClass
    var toAnyClass: AnyClass? {
        return NSClassFromString(self)
    }
    /// Convert to NSString
    var toNSString: NSString {
        return self as NSString
    }
    /// Convert to double
    var toDouble: Double {
        return (self as NSString).doubleValue
    }
    /// Convert to time and formatter: YYYY-MM-dd HH:mm:ss
    var toDateTime: String {
        return IWTime.time(with: self)
    }
    var toFileURL: URL {
        return URL(fileURLWithPath: self)
    }
    public func toFileURL(isDirectory: Bool) -> URL {
        return URL(fileURLWithPath: self, isDirectory: isDirectory)
    }
    /// GET parameters
    public func getParameterValue(_ parameter: String?) -> String? {
        if let p = parameter {
            if let parameterBodies = IWRegex.expression(p + "=[^&]+", content: self) {
                return parameterBodies.components(separatedBy: "=").last
            }
        }
        return nil
    }
    
    
    var base64Encode: String {
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        let dataString = data?.base64EncodedString(options: .endLineWithLineFeed)
        return dataString ?? ""
    }
    var base64Decode: String {
        let data = Data.init(base64Encoded: self, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
        if data != nil {
            let decodeDataString = String.init(data: data!, encoding: String.Encoding.utf8)
            return decodeDataString ?? ""
        }
        return ""
    }
    var urlEncode: String {
        
        guard #available(iOS 9, *) else {
            let legalURLCharactersToBeEscaped: CFString = ":&=;+!@#$()',*" as CFString
            let str = CFURLCreateStringByAddingPercentEscapes(nil, self as CFString, nil, legalURLCharactersToBeEscaped, CFStringBuiltInEncodings.UTF8.rawValue) as String
            return str
        }
        let nsstr = self as NSString
        return nsstr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    var urlDecode: String {
        return self.removingPercentEncoding ?? ""
    }
    
    var lastCharacter: String {
        if self.count == 1 {
            return self
        }
        let str = self
        return str[str.index(before: str.endIndex)...].toString
    }
    
    var removeLastCharacter: String {
        if self == "" {
            return self
        }
        var str = self
        str.remove(at: str.index(before: str.endIndex))
        return str
    }
    public func reverseRemove(characters withNumber: Int) -> String {
        var str = self
        for _ in 0 ..< withNumber {
            str = str.removeLastCharacter
        }
        return str
    }
    public func remove(_ string: String) -> String {
        return replace(string, to: "")
    }
    public func remove(_ strings: [String]) -> String {
        var temp = self
        for str in strings {
            temp = temp.replace(str, to: "")
        }
        return temp
    }
    var removeSpace: String {
        return replace(" ", to: "")
    }
    func replace(_ string: String, to: String) -> String {
        return self.replacingOccurrences(of: string, with: to)
    }
    var replaceLineBreaks: String {
        return replace("\r", to: "").replace("\n", to: "")
    }
    var replaceWhiteSpaceAndNewline: String {
        let str = self
        return str.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    
    var lastPathNotHasPathExtension: String {
        let nsstr = self as NSString
        if let last = nsstr.pathComponents.last {
            let lastNSStr = last as NSString
            return lastNSStr.deletingPathExtension
        }
        return ""
    }
    var pathExtension: String {
        let nsstr = self as NSString
        return nsstr.pathExtension
    }
    var lastPath: String {
        let nsstr = self as NSString
        return nsstr.lastPathComponent
    }
    
    
    func splicing(_ path: String) -> String {
        let nsstr = self as NSString
        return nsstr.appendingPathComponent(path)
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
    
    
    
    var uppercaseFirstCharecters: String {
        let str = self
        return str.uppercased(with: Locale.current)
    }
    
    
    
    public func `is`(in equleTo: [String]) -> Bool {
        var isEqule = false
        for str in equleTo {
            if self == str {
                isEqule = true
                break
            }
        }
        return isEqule
    }
    public func containsEx(in contains: [String]) -> Bool {
        var isEqule = false
        for str in contains {
            if self.contains(str) {
                isEqule = true
                break
            }
        }
        return isEqule
    }
    
    
    public func hasPrefixEx(_ prefixs: [String]) -> Bool {
        var has = false
        for str in prefixs {
            if self.hasPrefix(str) {
                has = true
                break
            }
        }
        return has
    }
    
    
    
    public func copyToPasteboard() -> Void {
        UIPasteboard.general.string = self
    }
    
    
    
    var isNumber: Bool {
        return self =~ "^\\d$"
    }
    var isPhoneNumber: Bool {
        // CMCC 移动
        let cm_num = "^((13)[4-9]|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1703)|(170[5-6])\\d{7}$"
        // CU 联通
        let cu_num = "^((13[0-2])|(145)|(15[5-6])|(171)|(176)|(18[5,6]))\\d{8}|(1704)|(170[7-9])\\d{7}$"
        // CT 电信
        let ct_num = "^((133)|(153)|(177)|(18[0,1,9]))\\d{8}|(170[0-2])\\d{7}$"
        
        return ((self =~ cm_num) || (self =~ cu_num) || (self =~ ct_num))
    }
    var isEmail: Bool {
        let email = "^[A-Z0-9a-z._%+-]+@[A-Za-z]{2,4}$"
        return self =~ email
    }
    func matches(_ predicate: String) -> Bool {
        return self =~ predicate
    }
    
    static var random32Bit: String {
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
    
    static func hexString(withInteger integer: NSInteger) -> String {
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
    
    static func hexLetterString(withInteger integer: NSInteger) -> String {
        assert(integer < 16, "要转换的数必须是16进制里的个位数，也即小于16，但你传给我是\(integer)")
        var letter: String = ""
        switch integer {
        case 10:
            letter = "A"
        case 11:
            letter = "B"
        case 12:
            letter = "C"
        case 13:
            letter = "D"
        case 14:
            letter = "E"
        case 15:
            letter = "F"
        default:
            letter = "\(integer)"
        }
        return letter
    }
}

public extension String {
    
    func index(offsetBy: String.IndexDistance) -> String.Index {
        return self.index(self.startIndex, offsetBy: offsetBy)
    }
    
    func sendEmail() {
        let mailAddress = self
        "mailto:\(mailAddress)".toURL.unwrapped({ openURL($0) })
    }
    
    /// Dial this number
    func call() {
        let phoneNumber = self
        "tel:\(phoneNumber)".toURL.unwrapped({ openURL($0) })
    }
    
    func openURLInSafari() {
        self.toURL.unwrapped({openURL($0)})
    }
    
    /// 在 App Store 中打开, self 为 app 的 id
    func openInAppStore() {
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
}

public extension Substring {
    
    var toString: String {
        return String(self)
    }
}
