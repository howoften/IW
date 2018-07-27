//  Created by iWw on 2018/3/13.
//  Copyright © 2018年 iWe. All rights reserved.
//

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif
import Security

public class IWKeyChainManager: NSObject {
    
    /// 增
    @discardableResult public static func save(service: String, value: Any) -> Bool {
        var keyChain = self.searchInfoInKeyChain(by: service)
        if SecItemCopyMatching(keyChain as CFDictionary, nil) == noErr {
            SecItemDelete(keyChain as CFDictionary)
        }
        keyChain[kSecValueData] = NSKeyedArchiver.archivedData(withRootObject: value)
        if SecItemAdd(keyChain as CFDictionary, nil) == noErr {
            iPrint("IWKeyChainManager.save: \(service)->\(value) saved.")
            return true
        } else {
            iPrint("IWKeyChainManager.save: \(service)->\(value) failed.")
            return false
        }
    }
    
    /// (查).
    public static func load(service: String) -> Any? {
        var keyChain = self.searchInfoInKeyChain(by: service)
        keyChain[kSecReturnData] = kCFBooleanTrue
        keyChain[kSecMatchLimit] = kSecMatchLimitOne
        
        var ret: Any?
        var keyData: CFTypeRef?
        if SecItemCopyMatching(keyChain as CFDictionary, &keyData) == noErr {
            guard let kd = keyData as? Data else { return nil }
            ret = NSKeyedUnarchiver.unarchiveObject(with: kd)
        } else {
            iPrint("IWKeyChainManager.load: \(service) item not founded.")
        }
        return ret
    }
    
    /// (将查询转换为字符串).
    public static func loadString(service: String) -> String? {
        return self.load(service: service) as? String
    }
    
    /// (删).
    @discardableResult public static func delete(service: String) -> Bool {
        let keyChain = self.searchInfoInKeyChain(by: service)
        if SecItemDelete(keyChain as CFDictionary) == noErr {
            iPrint("IWKeyChainManager.delete: \(service) deleted.")
            return true
        } else {
            iPrint("IWKeyChainManager.delete: \(service) failed.")
            return false
        }
    }
    
    /// (改).
    @discardableResult public static func update(service: String, value: Any) -> Bool {
        let keyChain = self.searchInfoInKeyChain(by: service)
        let changes = [kSecValueData: NSKeyedArchiver.archivedData(withRootObject: value)]
        if SecItemUpdate(keyChain as CFDictionary, changes as CFDictionary) == noErr {
            iPrint("IWKeyChainManager.update: \(service)->\(value) updated.")
            return true
        } else {
            iPrint("IWKeyChainManager.update: \(service)->\(value) failed.")
            return false
        }
    }
    
    private static func searchInfoInKeyChain(by service: String) -> [CFString: Any] {
        return [kSecClass: kSecClassGenericPassword,
                kSecAttrService: service,
                kSecAttrAccount: service,
                kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock]
    }
}
