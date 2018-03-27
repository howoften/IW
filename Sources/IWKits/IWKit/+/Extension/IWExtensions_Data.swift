//  Created by iWw on 23/01/2018.
//  Copyright © 2018 iWe. All rights reserved.
//

import UIKit

public extension Data {
    
    /// (base64 解码, 成功返回解码值, 失败则崩溃).
    public var base64DecodeValue: String {
        return base64Decode!
    }
    
    /// (base64 解码, 成功返回解码值, 失败返回 nil).
    public var base64Decode: String? {
        let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters)
        if data != nil {
            let decodeDataString = String(data: data!, encoding: .utf8)
            return decodeDataString ?? nil
        }
        return nil
    }
    
    /// (转换为 utf8 字符串, 失败则崩溃).
    public var stringValue: String {
        return string!
    }
    /// (转换为 utf8 字符串, 失败返回 nil).
    public var string: String? {
        return String(data: self, encoding: .utf8)
    }
    
    /// (转换为 json, 失败则崩溃).
    public var jsonValue: Any {
        return json!
    }
    /// (转换为 json, 失败返回 nil).
    public var json: Any? {
        return try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
    }
    
    /// (格式化为 token).
    public var deviceToken: String {
        let deviceToNS = NSData(data: self)
        return deviceToNS.description.remove(["<", ">", " "])
    }
}
