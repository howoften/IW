//  Created by iWe on 2017/6/14.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit
import Foundation
import WebKit

private let kDefaultTimeFormat = "YYYY-MM-dd HH:mm:ss"

class IWTime: NSObject {
    
    /// Returns device current timestamp by String.
    ///
    /// - Returns: Device current timestamp by String.
    class func current(_ formatter: String = kDefaultTimeFormat) -> String {
        let date = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = formatter
        return dateformatter.string(from: date)
    }
    
    static var currentTimestamp: String {
        return Date().timeIntervalSince1970.toString
    }
    
    class func time(with timestamp: String) -> String {
        let conformTimestamp = Date(timeIntervalSince1970: timestamp.toDouble)
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = kDefaultTimeFormat
        let timeString = timeFormat.string(from: conformTimestamp)
        return timeString
    }
}

class IWStatus: NSObject {
    
    // Use these, you must set 'View controller-based status bar appearance': 'NO' to 'Info.plist'.
    class func toWhiteStyle() {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    class func toBlackStyle() {
        UIApplication.shared.statusBarStyle = .default
    }
    
    // 返回一个和StatusBar大小一致的UIView
    class func bgView(_ bgColor: UIColor = .white) -> UIView {
        let v = UIView(frame: CGRect.init(x: 0, y: 0, width: ikScreenW, height: .statusBarHeight))
        v.backgroundColor = bgColor
        return v
    }
	
	static var style: UIStatusBarStyle {
		get { return UIApplication.shared.statusBarStyle }
		set {
			if newValue == .default {
				toBlackStyle()
			} else {
				toWhiteStyle()
			}
		}
	}
    
}


class IWRegex: NSObject {
    
    class func match(_ matches: String, _ content: String) -> Bool {
        let regex = try? NSRegularExpression.init(pattern: matches, options: .caseInsensitive)
        if let matches = regex?.matches(in: content, options: .init(rawValue: 0), range: NSMakeRange(0, content.count)) {
            return matches.count > 0
        }
        return false
    }
    
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


class IWSandbox: NSObject {
    
    static var documents: String {
        return self.system(with: .documentDirectory)
    }
    static var caches: String {
        return self.system(with: .cachesDirectory)
    }
    static var temp: String {
        return NSTemporaryDirectory()
    }
    private class func system(with type: FileManager.SearchPathDirectory) -> String {
		if let result = NSSearchPathForDirectoriesInDomains(type, .userDomainMask, true).first {
			return result
		}
        return ""
    }
}


class IWFileManage: FileManager {
    
    class func create(_ directory: String, in rootDirectory: String) -> Bool {
        
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
    
    class func createFile(atPath path: String, contents data: Data?, attributes attr: [FileAttributeKey : Any]? = nil) -> Bool {
        return FileManager.default.createFile(atPath: path, contents: data, attributes: attr)
    }
    
}


class IWSheetAlert: NSObject {
    
    /// Default added cancel action
    class func show(_ title: String?, _ message: String?, configure:((_: UIAlertController) -> Void)?) {
        let sheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        sheet.addAction(cancel)
        
        configure?(sheet)
        
        sheet.modalPresentationStyle = .popover
		
		// Add by iwe, in 2017.11/13. Get tips from Bugly. The reference solution: http://www.jianshu.com/p/c67d5bb31067 .
		if IWDevice.isiPad {
			sheet.popoverPresentationController?.sourceView = UIViewController.IWE.current()?.view
			sheet.popoverPresentationController?.sourceRect = MakeRect(0, 0, 1.0, 1.0)
		}
		
        UIViewController.IWE.current()?.iwe.modal(sheet)
    }
}


class IWCookies: NSObject {
    
    class func cookies(for url: URL) -> String? {
        
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


class IWCaches: NSObject {
    
    static var webSiteDiskAndMemoryCaches: [String]? {
        if #available(iOS 9.0, *) {
            return [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache]
        } else {
            // Fallback on earlier versions
            return nil
        }
    }
    
    static var allWebSiteDataCaches: [String]? {
        if #available(iOS 9.0, *) {
            return [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeCookies, WKWebsiteDataTypeSessionStorage, WKWebsiteDataTypeLocalStorage]
        } else {
            // Fallback on earlier versions
            return nil
        }
    }
    
    class func clearCaches(_ ios9CacheType: [String]? = nil) {
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
            if iOSVersion >= 8 && iOSVersion < 9 {
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
            
            if iOSVersion >= 7 && iOSVersion < 8 {
                do {
                    try FileManager.default.removeItem(atPath: webkitFolderInCachesfs)
                } catch {
                    iPrint("iOS 7 Clear web caches failed: \(error)")
                }
            }
        }
        
    }
}
