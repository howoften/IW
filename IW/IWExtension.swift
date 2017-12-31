//  Created by iWe on 2017/6/9.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit
import Foundation
import WebKit

extension UIView {
    
//    func track(_ attribute: String) -> Void {
//        NotificationCenter.default.addObserver(self, forKeyPath: attribute, options: [.new, .old], context: nil)
//    }
//    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//
//    }
	
    var x: CGFloat {
        get { return self.frame.origin.x }
        set { self.frame.origin.x = newValue }
    }
    var y: CGFloat {
        get { return self.frame.origin.y }
        set { self.frame.origin.y = newValue }
    }
    
    var width: CGFloat {
        get { return self.frame.width }
        set { self.frame.size.width = newValue }
    }
    var height: CGFloat {
        get { return self.frame.height }
        set { self.frame.size.height = newValue }
    }
    
    var left: CGFloat {
        get { return self.frame.origin.x }
        set { self.frame.origin.x = newValue }
    }
    var right: CGFloat {
        get { return self.frame.origin.x + self.frame.size.width }
        set { self.frame.origin.x = newValue - self.frame.size.width }
    }
    
    var top: CGFloat {
        get { return self.frame.origin.y }
        set { self.frame.origin.y = newValue }
    }
    var bottom: CGFloat {
        get { return self.frame.origin.y + self.frame.size.height }
        set { self.frame.origin.y = newValue - self.frame.size.height }
    }
	
	static var xib: UIView? {
		let path = _xibPath()
		if path != nil {
			let className = String(describing: self)
			let nib = UINib(nibName: className, bundle: nil).instantiate(withOwner: 0, options: nil).last
			if let nibFile = nib {
				return nibFile as? UIView
			}
		}
		return nil
	}
	private final class func _xibPath() -> String? {
		let className = String(describing: self)
		let path = Bundle.main.path(forResource: className, ofType: ".nib")
		guard let filePath = path else {
			return nil
		}
		if FileManager.default.fileExists(atPath: filePath) {
			return filePath
		}
		
		return nil
	}
    
    
	
}

extension CGFloat {
    
    var toFloat: Float { return Float(self) }
    
	static let estimated: CGFloat = -1
	
	/**
	 time: 2017.10/10 at 09:34 
	 note: 根据 iPhoneX SafeAreaGuide 进行了修正
	 Changed by iwe. */
	static var tabbarHeight: CGFloat {
		guard let vc = UIViewController.IWE.current() else { return 0 }
		guard let tabBar = vc.tabBarController?.tabBar else { return 0 }
		if !iw.isTabbarExists || tabBar.isHidden {
			if IWDevice.isiPhoneX {
				return .bottomSpacing
			}
			return 0
		}
		return tabBar.height
	}
	static var navBarHeight: CGFloat {
		guard let vc = UIViewController.IWE.current() else { return 0 }
		guard let navBar = vc.navigationController?.navigationBar else { return 0 }
		if navBar.isHidden {
			return statusBarHeight
		}
		return navBar.height + statusBarHeight
	}
	static var statusBarHeight: CGFloat {
		return UIApplication.shared.statusBarFrame.height
	}
	
	/**
	 导航栏 titleView 尽可能充满屏幕，余留的边距
	 iPhone5s/iPhone6(iOS8/iOS9/iOS10) margin = 8
	 iPhone6p(iOS8/iOS9/iOS10) margin = 12
	
	 iPhone5s/iPhone6(iOS11) margin = 16
	 iPhone6p(iOS11) margin = 20
	*/
	static var titleViewMargin: CGFloat {
		return iw.system.version.toInt >= 11 ? (self.screenWidth > 375 ? 20 : 16) : (self.screenWidth > 375 ? 12 : 8)
	}
	
	/**
	 导航栏左右navigationBarItem余留的边距
	 iPhone5s/iPhone6(iOS8/iOS9/iOS10) margin = 16
	 iPhone6p(iOS8/iOS9/iOS10) margin = 20
	*/
	static var itemMargin: CGFloat {
		return self.screenWidth > 375 ? 20 : 16
	}
	
	/**
	 导航栏titleView和navigationBarItem之间的间距
	 iPhone5s/iPhone6/iPhone6p(iOS8/iOS9/iOS10) iterItemSpace = 6
	*/
	static let interItemSpace: CGFloat = 6
	
	/**
	 time: 2017.10/10 at 09:30 
	 note: 根据 iPhoneX SafeAreaGuide 修正底部间距
	 Created by iwe. */
	static let bottomSpacing: CGFloat = (IWDevice.isiPhoneX ? 34 : 0)
	
	static let min: CGFloat = CGFloat.leastNormalMagnitude
    
    static let screenHeight: CGFloat = { return iw.screenHeight }()
    static let screenWidth: CGFloat = { return iw.screenWidth }()
	//static let screenBounds: CGRect = { return iw.screenBounds }()
	
	static var safeAreaHeight: CGFloat {
		var safeAh = screenHeight
		safeAh -= navBarHeight
		safeAh -= tabbarHeight
		return safeAh
	}
	
}

extension Float {
    
    var toCGFloat: CGFloat {
        get { return CGFloat(self) }
    }
    var retain: String {
        return String(format: "%0.2f", self)
    }
    func retain(_ digit: Int) -> String {
        return String(format: "%0.\(digit)f", self)
    }
}

extension Int {
    
    var toString: String {
        get { return String(describing: self) }
    }
    var toAnyObject: AnyObject {
        get { return self as AnyObject }
    }
}

extension UIColor {
	
	static var iwe_tinyBlack: UIColor {
		return "#3f4458".toColor
	}
	
	static var iwe_orangeRed: UIColor {
		return "#ff4500".toColor
	}
	
	static var iwe_adadad: UIColor {
		return "#adadad".toColor
	}

	static var iwe_gainsboro: UIColor {
		return "#dcdcdc".toColor
	}
	
	class button: UIColor {
		class var `default`: UIColor {
			return UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1)
		}
	}
	
	class func iwe_hex(_ hex: String, _ alpha: Float = 1.0) -> UIColor {
		var color = UIColor.red
		var cStr : String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
		
		if cStr.hasPrefix("#") {
            let index = cStr.index(after: cStr.startIndex)
			cStr = cStr[index...].toString //cStr.iwe.substring(from: index)
		}
		if cStr.count != 6 {
			return UIColor.black
		}
		
		let rRange = cStr.startIndex ..< cStr.index(cStr.startIndex, offsetBy: 2)
        let rStr = cStr[rRange].toString //cStr.iwe.substring(with: rRange)
        
		let gRange = cStr.index(cStr.startIndex, offsetBy: 2) ..< cStr.index(cStr.startIndex, offsetBy: 4)
		let gStr = cStr[gRange].toString //cStr.iwe.substring(with: gRange)
		
		let bIndex = cStr.index(cStr.endIndex, offsetBy: -2)
		let bStr = cStr[bIndex...].toString //cStr.iwe.substring(from: bIndex)
		
		var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
		Scanner(string: rStr).scanHexInt32(&r)
		Scanner(string: gStr).scanHexInt32(&g)
		Scanner(string: bStr).scanHexInt32(&b)
		
		color = UIColor(red: CGFloat(r) / 255.0,
		                green: CGFloat(g) / 255.0,
		                blue: CGFloat(b) / 255.0,
		                alpha: CGFloat(alpha))
		return color
	}
	
    func alpha(_ value: Float) -> UIColor {
        return self.withAlphaComponent(value.toCGFloat)
    }
	
	
}

extension String {
	
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
    var toURL: URL {
        return URL(string: self)!
    }
    /// Convert to URLRequest
    var toURLRequest: URLRequest {
        return URLRequest(url: self.toURL)
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
    func toFileURL(isDirectory: Bool) -> URL {
        return URL(fileURLWithPath: self, isDirectory: isDirectory)
    }
    /// GET parameters
    func getParameterValue(_ parameter: String?) -> String? {
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
		var str = self
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
    func reverseRemove(characters withNumber: Int) -> String {
        var str = self
        for _ in 0 ..< withNumber {
            str = str.removeLastCharacter
        }
        return str
    }
    func remove(_ string: String) -> String {
        return replace(string, to: "")
    }
    func remove(_ strings: [String]) -> String {
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
    
    
    
    func POST(_ paramters: Any? = nil, success: IWRequestResult.successedHandler?, failed: IWRequestResult.failedHandler? = nil) {
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
    func GET(_ parameters: Any? = nil, success: IWRequestResult.successedHandler?, failed: IWRequestResult.failedHandler?) {
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
    
    
    
    func `is`(in equleTo: [String]) -> Bool {
        var isEqule = false
        for str in equleTo {
            if self == str {
                isEqule = true
                break
            }
        }
        return isEqule
    }
    func containsEx(in contains: [String]) -> Bool {
        var isEqule = false
        for str in contains {
            if self.contains(str) {
                isEqule = true
                break
            }
        }
        return isEqule
    }
    
    
    func hasPrefixEx(_ prefixs: [String]) -> Bool {
        var has = false
        for str in prefixs {
            if self.hasPrefix(str) {
                has = true
                break
            }
        }
        return has
    }
    
    
    
    func copyToPasteboard() -> Void {
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

extension String {
    
    func index(offsetBy: String.IndexDistance) -> String.Index {
        return self.index(self.startIndex, offsetBy: offsetBy)
    }
    
    func sendEmail() {
        let mailAddress = self
        let mailURL = "mailto:\(mailAddress)".toURL
        openURL(mailURL)
    }
    
    /// Dial this number
    func call() {
        let phoneNumber = self
        let phoneURL = "tel:\(phoneNumber)".toURL
        openURL(phoneURL)
    }
    
    func openURLInSafari() {
        openURL(self.toURL)
    }
    
    /// 在 App Store 中打开, self 为 app 的 id
    func openInAppStore() {
        
        let site = "itms-apps://itunes.apple.com/cn/app/id\(self)".toURL
        openURL(site)
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

extension Data {
    
    var base64Decode: String {
        let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters)
        if data != nil {
            let decodeDataString = String(data: data!, encoding: .utf8)
            return decodeDataString ?? ""
        }
        return ""
    }
    
    var stringValue: String {
        return String(data: self, encoding: .utf8) ?? ""
    }
    
    var deviceToken: String {
        let deviceToNS = NSData(data: self)
        return deviceToNS.description.remove(["<", ">", " "]) 
    }
}

private var kUINib_nibNameKey: Void?
private var kUINib_nibBundleKey: Void?
extension UINib {
    
    @IBInspectable var nibName: String {
        get { return objc_getAssociatedObject(self, &kUINib_nibNameKey) as! String }
        set { objc_setAssociatedObject(self, &kUINib_nibNameKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }
    
    @IBInspectable var bundle: Bundle? {
        get { return objc_getAssociatedObject(self, &kUINib_nibBundleKey) as? Bundle }
        set { objc_setAssociatedObject(self, &kUINib_nibBundleKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    /// Initializes a UINIB with a name and bundle.
    convenience init(withName name: String, bundle: Bundle?) {
        let fixName = name.components(separatedBy: ".").last!
        self.init(nibName: fixName, bundle: bundle)
        self.nibName = fixName
        self.bundle = bundle
    }
    
    open func navigationShouldPopOnBackButton() -> Bool {
        return true
    }
}

extension UIAlertController {
    
    class func show(_ title: String? = "提示", message: String?, config: ((_ alert: UIAlert) -> Void)?) -> Void {
        UIAlert.alert(title: title, message: message, config: config)
    }
    
    class func showInternetError(_ error: Error? = nil) {
        var msg = ""
        if let e = error {
            msg = e.localizedDescription
        } else {
            msg = "网络错误, 请稍后再试!"
        }
        UIAlert.alert(title: "提示", message: msg, config: nil)
    }
    
    class func alert(title: String? = "提示", message: String?, config: ((_ alert: UIAlert) -> Void)?) -> Void {
        let alertController = UIAlert(title: title, message: message, preferredStyle: .alert)
        if config != nil {
            config!(alertController)
        } else {
            alertController.addConfirm(handler: nil)
        }
        alertController.show()
    }
    
    func addCancel(title: String? = "取消", handler: ((_ action: UIAlertAction) -> Void)?) {
        let cancel = UIAlertAction(title: title, style: .cancel, handler: handler)
        addAction(cancel)
    }
    
    func addConfirm(title: String? = "确定", style: UIAlertActionStyle = .default, handler: ((_ action: UIAlertAction) -> Void)?) {
        let confirm = UIAlertAction(title: title, style: style, handler: handler)
        addAction(confirm)
    }
    
    func show() {
		UIViewController.IWE.current()?.present(self, animated: true, completion: nil)
    }
}


extension Double {
    
    var toString: String {
        return String(self)
    }
    
}

extension Array {
    
    subscript (safe index: Int) -> Element? {
        return (0 ..< count).contains(index) ? self[index] : nil
    }
    
    var toString: String {
     	return toOtherString(byType: .string, nil)
    }
    
    var toParameters: String {
        return toOtherString(byType: .parameters, nil)
    }
    
    var toURLString: String {
        
        var tempString = ""
        for obj: Any in self {
            if obj is [String: Any] {
                let dic = obj as! [String: Any]
                for (key, value) in dic {
                    tempString = tempString + "\(key):\(value)"
                }
            } else {
                tempString = tempString + "\(obj)"
            }
        }
        tempString = tempString.removeLastCharacter
        return tempString
    }
    
    private enum IWArrayToOtherType {
        case parameters
        case string
        case custom
    }
    private func toOtherString(byType: IWArrayToOtherType, _ custom: String?) -> String {
        var connect = ""
        if byType == .parameters {
            connect = "&"
        } else if byType == .custom {
            if custom != nil {
                connect = custom!
            }
		} else {
			connect = ","
		}
        var str = ""
        for obj: Any in self {
            var temp = ""
            if obj is String {
                temp = obj as! String
            }
            if obj is Dictionary<String, Any> {
                temp = "{" + (obj as! [String: Any]).toParameters + "}"
            }
            if obj is Array {
                temp = "[" + (obj as! [Any]).toParameters + "]"
            }
            str = str + temp + connect
        }
        return str.removeLastCharacter
    }
}


extension Dictionary {
    
    var toCookieValue: String {
        var temp = ""
        for (keyHas, valueHas) in self {
            
            let key = keyHas as! String
            
            if valueHas is [Any] {
                temp = temp + "\(key)=[\((valueHas as! [Any]).toURLString)];"
            } else if valueHas is [String: Any] {
                temp = temp + "\(key)={\((valueHas as! [String: Any]).toString)};"
            } else {
                temp = temp + "\(key)=\(valueHas);"
            }
        }
        return temp
    }
    
    var toString: String {
        return toOtherString(byParameters: false)
    }
    
    var toParameters: String {
        return toOtherString(byParameters: true)
    }
    
    private func toOtherString(byParameters: Bool) -> String {
        var tempEqual = ": "
        var tempConnect = ", "
        if byParameters {
            tempEqual = "="
            tempConnect = "&"
        }
        var str = ""
        
        for (key, value) in self {
            var temp = ""
            if value is Dictionary<String, Any> {
                if byParameters {
                    temp = "{" + (value as! Dictionary).toParameters + "}"
                } else {
                    temp = "{" + (value as! Dictionary).toString + "}"
                }
            } else {
                if value is Array<Any> {
                    temp = "[" + (value as! Array<Any>).toParameters + "]"
                } else {
                    temp = String.init(describing: value)
                }
            }
            str = str + String(describing: key) + tempEqual + temp + tempConnect
        }
        if byParameters {
            return str.removeLastCharacter
        }
        return str.removeLastCharacter.removeLastCharacter
    }
	
	var toJSONString: String {
		do {
			let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
			if let json = String.init(data: jsonData, encoding: String.Encoding.utf8) {
				return json.remove(["\n", "\\"])
			}
			return ""
		} catch {
			iPrint(error.localizedDescription)
			return ""
		}
	}
    
    /* // 同Array, for-in能达到同样效果, 此方法不再显示
    func enumerate(_ handler: (_ key: String, _ value: Any, _ stop: inout Bool) -> Void) -> Void {
        var stopEnum = false
        for key in self.keys {
            if stopEnum {
                break
            }
            let value = self[key]!
            handler(key as! String, value as Any, &stopEnum)
        }
    }
     */
}

extension Substring {
    
    var toString: String {
        return String(self)
    }
}

extension UITextField {
    
    var placeholderColor: UIColor {
        get { return value(forKeyPath: "_placeholderLabel.textColor") as! UIColor }
        set { setValue(newValue, forKeyPath: "_placeholderLabel.textColor") }
    }
    
    var placeholderFontSize: Float {
        get { return (value(forKeyPath: "_placeholderLabel.font") as! CGFloat).toFloat }
        set { setValue(UIFont.systemFont(ofSize: newValue.toCGFloat), forKeyPath: "_placeholderLabel.font") }
    }
    
    func leftPadding(_ padding: CGFloat) {
        let view = UIView(frame: MakeRect(0, 0, padding, 1))
        view.backgroundColor = .clear
        leftView = view
        leftViewMode = .always
    }
    func rightPadding(_ padding: CGFloat) {
        let view = UIView(frame: MakeRect(0, 0, padding, 1))
        view.backgroundColor = .clear
        rightView = view
        rightViewMode = .always
    }
	
//	open override var intrinsicContentSize: CGSize {
//		return UILayoutFittingExpandedSize
//	}
	
}


extension UITableView {
    
    func enumerate(_ handler: (_ cell: UITableViewCell?, _ section: Int, _ row: Int, _ stop: inout Bool) -> Void) -> Void {
        var stopEnum = false
        let sectionsCount = numberOfSections
        for section in 0 ..< sectionsCount {
            let rowsCount = numberOfRows(inSection: section)
            for row in 0 ..< rowsCount {
                if stopEnum {
                    break
                }
                let indexPath = IndexPath(row: row, section: section)
                let cell = cellForRow(at: indexPath)
                handler(cell, section, row, &stopEnum)
            }
        }
    }
	
}

extension UIPageControl {
    
    var minimumHeight: CGFloat {
        return size(forNumberOfPages: numberOfPages).height - 24
    }
    
    var minimumWidth: CGFloat {
        return size(forNumberOfPages: numberOfPages).width
    }
    
}

private var kUIImageView_imageNameKey: Void?
private let kImageCacheFolderPath = "IWImageCache"
extension UIImageView {
    
    @IBInspectable var imageName: String? {
        get { return objc_getAssociatedObject(self, &kUIImageView_imageNameKey) as? String }
        set { objc_setAssociatedObject(self, &kUIImageView_imageNameKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }
    
    
    /// Set image with URL
    ///
    /// - Parameters:
    ///   - url: URL or URLString
    ///   - placeholder: Location Image Name
    func image<T>(withURL url: T?, placeholder: String = "") {
        
        if !(url.self is String) && !(url.self is URL) {
            if placeholder != "" { image = UIImage(named: placeholder) }
            return
        }
        
        var urlString = ""
        if url.self is String { urlString = (url as! String) }
        if url.self is URL { urlString = (url as! URL).absoluteString }
        
        //imageName = urlString.lastPathNotHasPathExtension
        // 以完整的地址命名, 更大程度的避免了重复文件名的几率
        imageName = urlString.replace(":", to: "_").replace("/", to: "_").replace("?", to: "_")
        
        extractImageData(with: imageName) { (isExists, data) in
            if !isExists {
                IWRequest.get(urlString, parameters: nil, desc: nil).result(success: { (imgData, _, result) in
                    if imgData != nil {
                        let img = UIImage(data: imgData!)
                        if img != nil {
                            iw.main.execution { self.image = img }
                            self.save(image: imgData!)
                        } else {
                            if placeholder != "" {
                                iw.main.execution { self.image = UIImage(named: placeholder) }
                            }
                        }
                    }
                }, failed: { (error) in
                    if error != nil {
                        iPrint(error: error)
                    }
                })
            }
        }
        
    }
    
    // 解析图片
    private func extractImageData(with name: String?, result: (_ isExists: Bool, _ data: Data?) -> Void) -> Void {
        let pathOption = imageLocalPath.splicing(name ?? "")
		if FileManager.default.fileExists(atPath: pathOption) {
			self.image = UIImage(contentsOfFile: pathOption)
			return
		}
        result(false, nil)
    }
    // 图片缓存路径
    private var imageLocalPath: String {
		let addPath = IWSandbox.caches.splicing(kImageCacheFolderPath)
		let bCreateDir = IWFileManage.create(kImageCacheFolderPath, in: IWSandbox.caches)
		if !bCreateDir {
			iPrint("The sandbox created birectory failed.")
		}
		return addPath
    }
    // 保存图片
    private func save(image data: Data) {
        let imageFilepath = self.imageLocalPath.splicing(self.imageName ?? "")
        do {
            let writePath = URL(fileURLWithPath: imageFilepath)
            try data.write(to: writePath, options: .atomicWrite)
        } catch {
            iPrint("The remote image cache failed.")
        }
    }
}


extension CGSize {
	
	static func isEmpty(_ size: CGSize) -> Bool {
		return size.width <= 0 || size.height <= 0
	}
	
}

extension CGRect {
	
	static let screenBounds: CGRect = { return iw.screenBounds }()
}
