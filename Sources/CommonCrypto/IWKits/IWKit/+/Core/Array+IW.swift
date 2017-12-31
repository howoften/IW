//
//  IWArrayBase.swift
//  haoduobaduo
//
//  Created by iWw on 2017/11/21.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

public final class IWArray<Arr> {
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

extension IWArray where Arr == Array<Any> {
    
    var toString: String {
        return toOtherString(byType: .string, nil)
    }
    var toParameters: String {
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
			str = str + temp + connect
		}
		return str.removeLastCharacter
	}
	
    var toURLString: String {
        var tempString = ""
        for obj: Any in arr {
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
	
	
	/// 将多维数组按照一维数组进行遍历
	func enumerateNested(_ handler: ((_ obj: Any, _ stop: inout Bool) -> Void)) -> Void {
		var stop = false
		for i in 0 ..< self.arr.count {
			let object = self.arr[i]
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
