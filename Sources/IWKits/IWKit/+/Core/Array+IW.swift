//  Created by iWw on 2017/11/21.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

public final class IWArray<Arr> {
    /// (自身).
    public let arr: Arr
    public init(_ arr: Arr) {
        self.arr =  arr
    }
}

public protocol IWArrayCompatible {
    associatedtype IWE
    var iwe: IWE { get }
}

public extension IWArrayCompatible {
    public var iwe: IWArray<Self> {
        get { return IWArray(self) }
    }
}

extension Array: IWArrayCompatible { }

extension IWArray where Arr: Collection {
    
    /// Convert to value,value.
    final public var toString: String {
        return toOtherString(byType: .string, nil)
    }
    /// Convert to value&value.
    final public var toParameters: String {
        return toOtherString(byType: .parameters, nil)
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
        for obj: Any in arr {
            var temp = ""
            if obj is String {
                temp = obj as! String
            }
            if obj is Dictionary<String, Any> {
                temp = "{" + (obj as! [String: Any]).toParameters + "}"
            }
            if obj is Array<Any> {
                temp = "[" + (obj as! [Any]).toParameters + "]"
            }
            str += (temp + connect)
        }
        return str.removeLastCharacter
    }
    
    /// Convert to string.
    /// (转换为字符串).
    final public var toURLString: String {
        var tempString = ""
        for obj: Any in arr {
            if obj is [String: Any] {
                let dic = obj as! [String: Any]
                for (key, value) in dic {
                    tempString += "\(key):\(value)"
                }
            } else {
                tempString += "\(obj)"
            }
        }
        tempString = tempString.removeLastCharacter
        return tempString
    }
    
    
    /// Traversing a multidimensional array in a one-dimensional array.
    /// (将多维数组按照一维数组进行遍历).
    final public func enumerateNested(_ handler: ((_ obj: Any, _ stop: inout Bool) -> Void)) -> Void {
        var stop = false
        for object: Any in arr {
            if object is Array<Any> {
                (object as! Array<Any>).iwe.enumerateNested(handler)
            } else {
                handler(object, &stop)
            }
            if stop {
                break
            }
        }
    }
}

