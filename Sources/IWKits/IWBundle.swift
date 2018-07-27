//  Created by iWe on 2017/9/28.
//  Copyright © 2017年 iWe. All rights reserved.
//

#if os(iOS)
import UIKit

/// (IWBundle.bundle 资源相关).
public class IWBundle: NSObject {
    
    public static let shared: IWBundle = IWBundle()
    
    let bundleName = "IWBundle.bundle"
    var bundlePath: Bundle? {
        if let path = Bundle.main.resourcePath?.splicing(self.bundleName) {
            return Bundle(path: path)
        }
        return nil
    }
    
    final public func imagePath(_ name: String, _ ext: String = "png") -> String? {
        var tempName = name
        if !tempName.hasPrefix("iW") {
            tempName = "IWImage_" + tempName
        }
        return bundlePath?.path(forResource: tempName, ofType: ext)
    }
    
    final public func image(_ name: String, _ ext: String = "png") -> UIImage? {
        if name.contains("@") {
            if let pt = imagePath(name, ext) {
                return UIImage(contentsOfFile: pt)
            }
        }
        var n = ""
        let scale = UIScreen.main.scale
        if scale <= 2 {
            n = "\(name)@2x"
        } else {
            n = "\(name)@3x"
        }
        if let pt = imagePath(n, ext) {
            return UIImage(contentsOfFile: pt)
        }
        return nil
    }
    
    final public func filePath(_ name: String, _ ext: String) -> String? {
        return bundlePath?.path(forResource: name, ofType: ext)
    }
}

#endif
