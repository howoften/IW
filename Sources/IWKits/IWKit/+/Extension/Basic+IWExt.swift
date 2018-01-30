//  Created by iWw on 23/01/2018.
//  Copyright © 2018 iWe. All rights reserved.
//

import UIKit

// MARK:- Dictionary
public extension Dictionary {
    
    subscript (safe key: Key) -> Value? {
        return self.keys.contains(key) ? self[key] : nil
    }
    
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
}

// MARK:- Array
public extension Array {
    
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


// MARK:- Double
public extension Double {
    
    var toString: String {
        return "\(self)"
    }
    
}

// MARK:- Int
public extension Int {
    
    var toString: String {
        get { return "\(self)" }
    }
    var toAnyObject: AnyObject {
        get { return self as AnyObject }
    }
}



// MARK:- Float
public extension Float {
    
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


// MARK:- Bool
public extension Bool {
    
    mutating func toggle() -> Void {
        self = !self
    }
    
    /// (true 时执行todo, false 时执行 else).
    func `true`(_ todo: () -> Void, else: (() -> Void)? = nil) -> Void {
        if self { `todo`() } else { `else`?() }
    }
    /// (false 时执行todo, true 时执行 else).
    func `false`(_ todo: () -> Void, else: (() -> Void)? = nil) -> Void {
        if !self { `todo`() } else { `else`?() }
    }
    
    func `true`<T>(_ return: () -> T, elseReturn: () -> T) -> T {
        return self ? `return`() : elseReturn()
    }
    func `true`<T>(_ return: @autoclosure () -> T, elseReturn: @autoclosure () -> T) -> T {
        return self ? `return`() : elseReturn()
    }
    
    func `false`<T>(_ return: () -> T, elseReturn: () -> T) -> T {
        return !self ? `return`() : elseReturn()
    }
    func `false`<T>(_ return: @autoclosure () -> T, elseReturn: @autoclosure () -> T) -> T {
        return !self ? `return`() : elseReturn()
    }
    
    /// (或).
    func or(_ other:@autoclosure () -> Bool) -> Bool {
        return self || other()
    }
    /// (或).
    func or(_ other: () -> Bool) -> Bool {
        return self || other()
    }
    /// (且).
    func and(_ other:@autoclosure () -> Bool) -> Bool {
        return self && other()
    }
    /// (且).
    func and(_ other: () -> Bool) -> Bool {
        return self && other()
    }
}
