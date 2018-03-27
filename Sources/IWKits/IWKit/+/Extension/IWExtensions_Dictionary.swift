//  Created by iWw on 2018/3/14.
//  Copyright © 2018年 iWe. All rights reserved.
//

#if os(iOS)
    import UIKit
#endif


// MARK:- Functions
public extension Dictionary {
    
    subscript (safe key: Key) -> Value? {
        return self.keys.contains(key) ? self[key] : nil
    }
    /// (转化字符串类型的 Cookies).
    public var toCookieValue: String {
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
    
    /// (: , 拼接. 例如: key:value,key1:value1).
    public var toString: String {
        return toOtherString(byParameters: false)
    }
    
    /// (= $ 拼接. 例如: key=value&key1=value1).
    public var toParameters: String {
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
    
    /// (失败返回 nil).
    public var toJSONString: String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            if let json = String.init(data: jsonData, encoding: String.Encoding.utf8) {
                return json.remove(["\n", "\\"])
            }
            return nil
        } catch {
            iPrint(error.localizedDescription)
            return nil
        }
    }
    
    /// (是否包含某个 Key).
    public func has(key: Key) -> Bool {
        return index(forKey: key) != nil
    }
    
    public mutating func removeAll(keys: [Key]) {
        keys.forEach({ removeValue(forKey: $0)})
    }
    
}


// MARK:- 操作
public extension Dictionary {
    
    public static func + (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
        var result = lhs
        rhs.forEach({ result[$0] = $1 })
        return result
    }
    
    public static func += (lhs: inout [Key: Value], rhs: [Key: Value]) {
        rhs.forEach { lhs[$0] = $1}
    }
    
    public static func - (lhs: [Key: Value], keys: [Key]) -> [Key: Value] {
        var result = lhs
        result.removeAll(keys: keys)
        return result
    }
    
    public static func -= (lhs: inout [Key: Value], keys: [Key]) {
        
        lhs.removeAll(keys: keys)
    }
    
}

public extension Dictionary where Key: ExpressibleByStringLiteral {
    
    /// (所有 Key 转换为小写).
    public mutating func lowercaseAllKeys() {
        // http://stackoverflow.com/questions/33180028/extend-dictionary-where-key-is-of-type-string
        for key in keys {
            if let lowercaseKey = String(describing: key).lowercased() as? Key {
                self[lowercaseKey] = removeValue(forKey: key)
            }
        }
    }
    
}
