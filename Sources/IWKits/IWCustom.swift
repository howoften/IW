//  Created by iWe on 2017/6/14.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit
import Foundation
import WebKit

/// Timestamp correlation.
/// (时间戳相关).
public class IWTime: NSObject {
    
    public static let _timeFormat = "YYYY-MM-dd HH:mm:ss"
    
    /// Returns device current timestamp by String, can set formatter.
    /// (以字符串方式返回设备当前的时间戳, 可自定义格式, 默认为: YYYY-MM-dd HH:mm:ss, 单位: 秒).
    public final class func current(_ formatter: String = _timeFormat) -> String {
        let date = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = formatter
        return dateformatter.string(from: date)
    }
    
    /// Returns device current timestamp by String.
    /// (返回当前时间戳)
    public static var currentTimestamp: String {
        return Date().timeIntervalSince1970.toString
    }
    
    /// Return the timestamp of the specified format.
    /// (返回指定格式的时间戳).
    public final class func time(with timestamp: String) -> String {
        let conformTimestamp = Date(timeIntervalSince1970: timestamp.toDouble)
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = _timeFormat
        let timeString = timeFormat.string(from: conformTimestamp)
        return timeString
    }
}

/// UIStatusBar correlation.
/// (状态栏相关).
public class IWStatus: NSObject {
    
    // Use these, you must set 'View controller-based status bar appearance': 'NO' to 'Info.plist'.
    public final class func toWhiteStyle() {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    public final class func toBlackStyle() {
        UIApplication.shared.statusBarStyle = .default
    }
    
    /// Return a UIView that is the same as the StatusBar size.
    /// (返回一个和 StatusBar 大小一致的 UIView).
    public final class func bgView(_ bgColor: UIColor = .white) -> UIView {
        let v = UIView(frame: CGRect.init(x: 0, y: 0, width: .screenWidth, height: .statusBarHeight))
        v.backgroundColor = bgColor
        return v
    }
    
    /// Set UIStatusBarStyle.
    public static var style: UIStatusBarStyle {
        get { return UIApplication.shared.statusBarStyle }
        set { newValue == .default ? toBlackStyle() : toWhiteStyle() }
    }
    
}

/// Regex correlation.
/// (正则表达式相关).
public class IWRegex: NSObject {
    
    /// is contain matching text?
    /// (是否包含匹配的文本).
    /// matches: expression(表达式)
    /// content: 被查找的文本
    class func match(_ matches: String, _ content: String) -> Bool {
        let regex = try? NSRegularExpression.init(pattern: matches, options: .caseInsensitive)
        if let matches = regex?.matches(in: content, options: .init(rawValue: 0), range: NSMakeRange(0, content.count)) {
            return matches.count > 0
        }
        return false
    }
    
    /// Matching exp, return finded str.
    /// (匹配表达式, 返回找到的字符串).
    class func expression(_ expression: String, content: String) -> String? {
        let tempBody = content
        do {
            let regex = try NSRegularExpression.init(pattern: expression, options: .caseInsensitive)
            let firstMatch = regex.firstMatch(in: tempBody, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSMakeRange(0, tempBody.count))
            if let match = firstMatch {
                return (tempBody as NSString).substring(with: match.range)
            }
            return nil
        } catch {
            return nil
        }
    }
    
}

/// Sanbox correlation.
/// (沙盒相关).
public class IWSandbox: NSObject {
    
    /// Return documentDirectory path.
    /// (返回文档路径).
    public static var documents: String {
        return self.system(with: .documentDirectory)
    }
    /// Return cachesDirectory path.
    /// (返回缓存路径).
    public static var caches: String {
        return self.system(with: .cachesDirectory)
    }
    /// Return NSTemporaryDirectory path.
    /// (返回临时文件夹路径).
    public static var temp: String {
        return NSTemporaryDirectory()
    }
    private class func system(with type: FileManager.SearchPathDirectory) -> String {
        if let result = NSSearchPathForDirectoriesInDomains(type, .userDomainMask, true).first {
            return result
        }
        return ""
    }
}

/// Related to the operation of the file.
/// (文件操作相关).
public class IWFileManage: FileManager {
    
    /// (根据directory创建文件夹, rootDirectory为欲创建的文件夹的根目录).
    public final class func create(_ directory: String, in rootDirectory: String) -> Bool {
        
        var createSuccess = false
        
        let completedPath = rootDirectory.splicing(directory)
        var previousPath = rootDirectory
        
        var isDirectory: ObjCBool = ObjCBool(false)
        let isExists = FileManager.default.fileExists(atPath: completedPath, isDirectory: &isDirectory)
        
        var createError = false
        let array = directory.components(separatedBy: "/")
        
        if !isExists {
            while !createSuccess {
                for directoryName in array {
                    if directoryName != "" {
                        let tempDir = previousPath.splicing(directoryName)
                        do {
                            try FileManager.default.createDirectory(atPath: tempDir, withIntermediateDirectories: true, attributes: nil)
                            continue
                        } catch {
                            createError = true
                            iPrint("Create directory at path: '\(tempDir)' failed.")
                        }
                        
                        previousPath = tempDir
                    }
                }
                if !createError {
                    createSuccess = true
                }
            }
        } else {
            if isDirectory.boolValue {
                createSuccess = true
            }
        }
        return createSuccess
    }
    
    /// (创建文件).
    ///
    /// - Parameters:
    ///   - path: 路径
    ///   - data: 内容
    ///   - attr: 参数
    /// - Returns: 创建成功(true)/失败(false)
    class func createFile(atPath path: String, contents data: Data?, attributes attr: [FileAttributeKey : Any]? = nil) -> Bool {
        return FileManager.default.createFile(atPath: path, contents: data, attributes: attr)
    }
    
}


/// .actionSheet style alert.
/// (提示框相关).
public class IWSheetAlert: NSObject {
    
    /// Default added cancel action.
    class func show(_ title: String?, _ message: String?, configure:((_: UIAlertController) -> Void)?) {
        let sheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        sheet.addAction(cancel)
        
        configure?(sheet)
        
        sheet.modalPresentationStyle = .popover
        
        // Add by iwe, in 2017.11/13. Get tips from Bugly. The reference solution: http://www.jianshu.com/p/c67d5bb31067 .
        if IWDevice.isiPad {
            sheet.popoverPresentationController?.sourceView = UIViewController.IWE.current()?.view
            // 2018.02/06. 修正: 使其默认在屏幕中间显示
            sheet.popoverPresentationController?.sourceRect = MakeRect(.screenWidth / 2, .screenWidth - .tabbarHeightNormal, 0.5, 0.5)
        }
        
        UIViewController.IWE.current()?.iwe.modal(sheet)
    }
}

/// (Cookie相关).
public class IWCookies: NSObject {
    
    /// (获取对应URL的Cookies, 访问过该URL才会有Cookies).
    public final class func cookies(for url: URL) -> String? {
        var cookieValue = ""
        let mDictionary = NSMutableDictionary()
        
        let cookiesOption = HTTPCookieStorage.shared.cookies(for: url)
        if let cookies = cookiesOption {
            for cookie in cookies {
                mDictionary.setObject(cookie.value, forKey: cookie.name as NSCopying)
            }
            cookieValue = (mDictionary as! [String: Any]).toCookieValue
            return cookieValue
        }
        return nil
    }
}

/// (WebView缓存相关).
public class IWCaches: NSObject {
    
    public static var webSiteDiskAndMemoryCaches: [String]? {
        if #available(iOS 9.0, *) {
            return [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache]
        } else {
            // Fallback on earlier versions
            return nil
        }
    }
    
    public static var allWebSiteDataCaches: [String]? {
        if #available(iOS 9.0, *) {
            return [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeCookies, WKWebsiteDataTypeSessionStorage, WKWebsiteDataTypeLocalStorage]
        } else {
            // Fallback on earlier versions
            return nil
        }
    }
    
    public final class func clearCaches(_ ios9CacheType: [String]? = nil) {
        let libraryDir = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
        let bundleID = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
        let webkitFolderInLib = libraryDir.splicing("/WebKit")
        let webkitFolderInCaches = libraryDir.splicing("/Caches/\(bundleID)/WebKit")
        let webkitFolderInCachesfs = libraryDir.splicing("/Caches/\(bundleID)/fsCachedData")
        
        if #available(iOS 9.0, *) {
            if ios9CacheType != nil {
                let dataTypes = Set.init(ios9CacheType!)
                let dateFrom = Date.init(timeIntervalSince1970: 0)
                WKWebsiteDataStore.default().removeData(ofTypes: dataTypes, modifiedSince: dateFrom, completionHandler: {
                    iPrint("iOS 9 and after Cleared.")
                })
            }
        } else {
            // Fallback on earlier versions
            if iw.system.version.toInt >= 8 && iw.system.version.toInt < 9 {
                do {
                    try FileManager.default.removeItem(atPath: webkitFolderInCaches)
                    do {
                        try FileManager.default.removeItem(atPath: webkitFolderInLib)
                        return
                    } catch {
                        iPrint("iOS 8 Clear web caches failed: \(error)")
                    }
                } catch {
                    iPrint("iOS 8 Clear web caches failed: \(error)")
                }
            }
            
            if iw.system.version.toInt >= 7 && iw.system.version.toInt < 8 {
                do {
                    try FileManager.default.removeItem(atPath: webkitFolderInCachesfs)
                } catch {
                    iPrint("iOS 7 Clear web caches failed: \(error)")
                }
            }
        }
        
    }
}
