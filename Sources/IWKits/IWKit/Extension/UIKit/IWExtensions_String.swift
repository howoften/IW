//  Created by iWw on 23/01/2018.
//  Copyright © 2018 iWe. All rights reserved.
//

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif

// MARK:- Var
public extension String {
    
    private static let lineBreaks: String = "\r\n"
    
    /// Convert to Int
    /// (转换为整数).
    ///     "123".toInt -> 123
    ///     "135abc35".toInt -> 135
    ///     "abc123".toInt -> 0
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
    public var toColor: IWColor {
        return .hex(self)
    }
    /// Convert to UIColor
    public func toColor(_ alpha: Float) -> IWColor {
        return .hex(self, alpha)
    }
    /// Convert to URL?
    public var toURL: URL? {
        return URL(string: self)
    }
    /// Convert to URL!
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
    /// Convert to [String]?
    public var toArray: [String]? {
        return self.map({ String($0) })
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
    /// Convert to FileURL
    /// (转换为 file url).
    public var toFileURL: URL {
        return URL(fileURLWithPath: self)
    }
    
    /// (base64 加密, 失败返回 nil).
    public var base64EncodedString: String? {
        return data(using: .utf8)?.base64EncodedString()
    }
    public var base64Encode: Data? {
        return data(using: .utf8)
    }
    /// (base64 解密, 失败返回 nil).
    public var base64Decode: String? {
        guard let decodeData = Data(base64Encoded: self) else { return nil }
        return String(data: decodeData, encoding: .utf8)
    }
    /// (URL 编码).
    public var urlEncode: String? {
//        guard #available(iOS 9, *) else {
//            let legalURLCharactersToBeEscaped: CFString = "&=;+!@#$()',*" as CFString
//            let str = CFURLCreateStringByAddingPercentEscapes(nil, self as CFString, nil, legalURLCharactersToBeEscaped, CFStringBuiltInEncodings.UTF8.rawValue) as String
//            return str
//        }
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    /// (URL 解码).
    public var urlDecode: String {
        return removingPercentEncoding ?? self
    }
    
    /// (获取最后一个字符串).
    public var lastCharacter: String {
        return (self.count == 1).founded({ self }, elseReturn: { self[self.index(before: self.endIndex)...].toString })
    }
    /// (移除最后一个字符串).
    public var removeLastCharacter: String {
        return (self == "").founded({ self }, elseReturn: { var str = self; str.remove(at: self.index(before: self.endIndex)); return str })
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
        // http://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
        let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"// "^[A-Z0-9a-z._%+-]+@[A-Za-z]{2,4}$"
        return self =~ email
    }
    
    /// (随机生成一个 32 位字符串).
    public static var random32Bit: String {
        return String.random(32)
    }
    
    /// (是否包含字母).
    public var hasLetters: Bool {
        return rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
    }
    /// (是否包含数字).
    public var hasNumbers: Bool {
        return rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
    }
    
    /// (是否只包含字母).
    public var isAlphabetic: Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        return hasLetters && !hasNumbers
    }
    /// (是否只包含数字).
    public var isAlphaNumeric: Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        let comps = components(separatedBy: .alphanumerics)
        return comps.joined(separator: "").count == 0 && hasLetters && hasNumbers
    }
    
    /// (是否为有效的 URL 链接).
    public var isValidUrl: Bool {
        return self.toURL.isSome
    }
    /// (是否包含有效的 scheme).
    ///
    ///     "http://www.google.com".isVaildSchemedUrl -> true
    ///     "https://www.google.com".isVaildSchemedUrl -> true
    ///     "www.google.com".isVaildSchemedUrl -> false
    public var isVaildSchemedUrl: Bool {
        return toURL.and(then: { $0.scheme.isSome }).or(false)
    }
    /// (是否为有效的 https 链接).
    ///
    ///     "https://www.google.com".isValidHttpsUrl -> true
    ///     "www.google.com".isValidHttpsUrl -> false
    public var isValidHttpsUrl: Bool {
        return toURL.and(then: { $0.scheme == "https" }).or(false)
    }
    /// (是否为有效的 http 链接).
    ///
    ///     "http://www.google.com".isValidHttpUrl -> true
    ///     "www.google.com".isValidHttpUrl -> false
    public var isValidHttpUrl: Bool {
        return toURL.and(then: { $0.scheme == "http" }).or(false)
    }
    /// (是否为有效的文件路径).
    ///
    ///     "file://User/photo.png".isValidFileURL -> true
    public var isValidFileUrl: Bool {
        return self.toURL.and(then: { $0.isFileURL }).or(false)
    }
}

public protocol GetPrametersValueWithFuzzyNames {
    var str: String { get }
    var strs: [String] { get }
}
extension String: GetPrametersValueWithFuzzyNames {
    public var str: String {
        return self
    }
    public var strs: [String] {
        return [self]
    }
}

extension Array: GetPrametersValueWithFuzzyNames where Element: StringProtocol {
    public var strs: [String] {
        return self as! [String]
    }
    public var str: String {
        return self.first! as! String
    }
}


// MARK:- Functions
public extension String {
    
    /// (正则表达式).
    public func matches(_ predicate: String) -> Bool {
        return self =~ predicate
    }
    
    public func toFileURL(isDirectory: Bool) -> URL {
        return URL(fileURLWithPath: self, isDirectory: isDirectory)
    }
    
    #if os(iOS)
    /// (计算文本 size).
    ///
    /// - Parameters:
    ///   - maskSize: 范围
    ///   - attributes: 样式, 例如: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]
    /// - Returns: 返回计算完成的 size
    public func toSize(with maskSize: CGSize, options: NSStringDrawingOptions, attributes: [NSAttributedStringKey: Any]?) -> CGSize {
        return (self as NSString).boundingRect(with: maskSize, options: options, attributes: attributes, context: nil).size
    }
    #endif
    
    /// (精确提取对应的参数值, 例如: "index.php?id=1214".getParameterValue("id"), 结果为 1214 ).
    public func getParameterValue(exactName: String) -> String? {
        return IWRegex.expression("\(exactName)=[^&]+", content: self).and(then: { $0.components(separatedBy: "=").last })
    }
    
    /// (模糊提取对应参数的值，支持 String or [String] 仅返回第一个匹配到的结果).
    /// eg: "index.php?id=1214".getParameterValue("id"), 结果为 1214
    ///
    /// - Parameter fuzzyName: 模糊参数名, eg: "id" or ["id", "ids"]
    /// - Returns: 返回匹配到的第一个结果
    public func getParameterValue(fuzzyName: GetPrametersValueWithFuzzyNames?) -> String? {
        guard let names = fuzzyName else { return nil }

        var filter: [String?] = []
        names.strs.enumerateNested { (str, stop) in
            let regex = IWRegex.expression("\(str)=[^&]+", content: self)
            if regex.isSome {
                filter.append(regex!.components(separatedBy: "=").last)
                stop = true
            }
        }
        return filter.count > 0 ? filter.first! : nil
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
        return (self as NSString).appendingPathComponent(path)
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
        #if os(iOS)
            UIPasteboard.general.string = self
        #elseif os(macOS)
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(self, forType: .string)
        #endif
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
        assert(integer < 16, "要转换的数必须是16进制里的个位数，即小于16，但你写的是 \(integer)")
        let hex = ["A", "B", "C", "D", "E", "F"]
        return (integer >= 10).founded({ hex[integer - 10] }, elseReturn: { "\(integer)" })
    }
    
    #if swift(>=4.1) // swift4.1 将 IndexDistance 更改为 Int
    public func index(offsetBy: Int) -> String.Index {
        return self.index(self.startIndex, offsetBy: offsetBy)
    }
    #else
    public func index(offsetBy: String.IndexDistance) -> String.Index {
        return self.index(self.startIndex, offsetBy: offsetBy)
    }
    #endif
    
    #if os(iOS)
    /// (发送邮件).
    /// Send email.
    public func sendEmail() {
        let mailAddress = self
        "mailto:\(mailAddress)".toURL.unwrapped({ openURL($0) })
    }
    
    /// (拨打电话).
    /// Call.
    public func call() {
        let phoneNumber = self
        "tel:\(phoneNumber)".toURL.unwrapped({ openURL($0) })
    }
    
    /// (在 Safari 中打开).
    /// Open in Safari.
    public func openURLInSafari() {
        self.toURL.unwrapped({openURL($0)})
    }
    
    /// (在 App Store 中打开, value 为 app 的 id)
    /// Open in AppStore.
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
    #endif
    
    /// (本地语言).
    public func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
    /// (返回出现次数最多的字符).
    public func mostCommonCharacter() -> Character? {
        let mostCommon = removeSpace.replaceLineBreaks.reduce(into: [Character: Int]()) {
            let count = $0[$1].or(0)
            $0[$1] = count + 1
            }.max { $0.1 < $1.1 }?.0
        return mostCommon
    }
    
    /// (返回词组).
    /// From SwifterSwift.
    ///     "Swift is so faster".words() -> ["Swift", "is", "so", "faster"]
    ///     "我 今天 吃了五碗饭".words() -> ["我", "今天", "吃了五碗饭"]
    ///     "我,今天,吃了五碗饭".words() -> ["我", "今天", "吃了五碗饭"]
    ///     "我-今天-吃了五碗饭".words() -> ["我", "今天", "吃了五碗饭"]
    ///     "我,今天-吃了五碗饭".words() -> ["我", "今天", "吃了五碗饭"]
    ///     "我今天吃了五碗饭".words() -> ["我今天吃了五碗饭"]
    public func words() -> [String] {
        // https://stackoverflow.com/questions/42822838
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = components(separatedBy: chararacterSet)
        return comps.filter { !$0.isEmpty }
    }
    
    /// (随机生成字符串).
    public static func random(_ length: Int) -> String {
        guard length.isPositive else { return "" }
        let base = "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789"
        var randomString = ""
        for _ in 1 ... length {
            let randomIndex = arc4random_uniform(UInt32(base.count))
            let randomCharacter = Array(base)[Int(randomIndex)]
            randomString.append(randomCharacter)
        }
        return randomString
    }
    
    public func POST(_ paramters: Any? = nil, success: IWRequestResult.successedHandler?, failed: IWRequestResult.failedHandler? = nil) {
        IWRequest.post(self, parameters: paramters).result(success: { (data, dic, result) in
            iw.queue.main {
                success?(data, dic, result)
            }
        }) { (error) in
            iw.queue.main {
                failed?(error)
            }
        }
    }
    public func GET(_ parameters: Any? = nil, success: IWRequestResult.successedHandler?, failed: IWRequestResult.failedHandler?) {
        IWRequest.get(self, parameters: parameters).result(success: { (data, dic, result) in
            iw.queue.main {
                success?(data, dic, result)
            }
        }) { (error) in
            iw.queue.main {
                failed?(error)
            }
        }
    }
}

// MARK:- NSAttributedString
/// From SwifterSwift
public extension String {
    
    #if !os(tvOS) && !os(watchOS)
    /// (转化为粗体文字).
    public var bold: NSAttributedString {
        #if os(macOS)
            return NSMutableAttributedString(string: self, attributes: [.font: NSFont.boldSystemFont(ofSize: NSFont.systemFontSize)])
        #else
            return NSMutableAttributedString(string: self, attributes: [.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)])
        #endif
    }
    #endif
    
    /// (下划线).
    public var underline: NSAttributedString {
        return NSAttributedString(string: self, attributes: [.underlineStyle : NSUnderlineStyle.styleSingle.rawValue])
    }
    
    #if os(iOS)
    /// (斜体).
    public var italic: NSAttributedString {
        return NSMutableAttributedString(string: self, attributes: [.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)])
    }
    #endif
    
    public func colored(with color: IWColor) -> NSAttributedString {
        return NSMutableAttributedString(string: self, attributes: [.foregroundColor: color])
    }
}

// MARK:- Subscript
public extension String {
    
    public subscript(safe indexOf: Int) -> Character? {
        guard indexOf >= 0, indexOf < count else { return nil }
        return self[index(startIndex, offsetBy: indexOf)]
    }
    public subscript(safe range: CountableRange<Int>) -> String? {
        guard let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) else { return nil }
        guard let upperIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) else { return nil }
        return String(self[lowerIndex ..< upperIndex])
    }
    public subscript(safe range: ClosedRange<Int>) -> String? {
        guard let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) else { return nil }
        guard let upperIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound + 1, limitedBy: endIndex) else { return nil }
        return String(self[lowerIndex..<upperIndex])
    }
    
}

public extension Substring {
    
    public var toString: String {
        return String(self)
    }
}
