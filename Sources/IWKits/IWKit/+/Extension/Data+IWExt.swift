//  Created by iWw on 23/01/2018.
//  Copyright © 2018 iWe. All rights reserved.
//

import UIKit

public extension Data {
    
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
