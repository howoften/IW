//  Created by iWw on 23/01/2018.
//  Copyright © 2018 iWe. All rights reserved.
//

import UIKit

public extension UIColor {
    
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
