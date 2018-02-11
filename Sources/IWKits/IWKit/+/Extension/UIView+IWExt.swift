//  Created by iWw on 23/01/2018.
//  Copyright © 2018 iWe. All rights reserved.
//

import UIKit

extension UIView {
    
    public var x: CGFloat {
        get { return self.frame.origin.x }
        set { self.frame.origin.x = newValue }
    }
    public var y: CGFloat {
        get { return self.frame.origin.y }
        set { self.frame.origin.y = newValue }
    }
    
    public var width: CGFloat {
        get { return self.frame.width }
        set { self.frame.size.width = newValue }
    }
    public var height: CGFloat {
        get { return self.frame.height }
        set { self.frame.size.height = newValue }
    }
    
    public var left: CGFloat {
        get { return self.frame.origin.x }
        set { self.frame.origin.x = newValue }
    }
    public var right: CGFloat {
        get { return self.frame.origin.x + self.frame.size.width }
        set { self.frame.origin.x = newValue - self.frame.size.width }
    }
    
    public var top: CGFloat {
        get { return self.frame.origin.y }
        set { self.frame.origin.y = newValue }
    }
    public var bottom: CGFloat {
        get { return self.frame.origin.y + self.frame.size.height }
        set { self.frame.origin.y = newValue - self.frame.size.height }
    }
    
    static var xib: UIView? {
        let path = _xibPath()
        if path != nil {
            let className = String(describing: self)
            let nib = UINib(nibName: className, bundle: nil).instantiate(withOwner: 0, options: nil).last
            if let nibFile = nib {
                return nibFile as? UIView
            }
        }
        return nil
    }
    private final class func _xibPath() -> String? {
        let className = String(describing: self)
        let path = Bundle.main.path(forResource: className, ofType: ".nib")
        guard let filePath = path else {
            return nil
        }
        if FileManager.default.fileExists(atPath: filePath) {
            return filePath
        }
        
        return nil
    }
    
}
