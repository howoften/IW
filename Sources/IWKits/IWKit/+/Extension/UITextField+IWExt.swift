//  Created by iWw on 23/01/2018.
//  Copyright © 2018 iWe. All rights reserved.
//

import UIKit


public extension UITextField {
    
    /// (placeholder 文字颜色).
    var placeholderColor: UIColor {
        get { return value(forKeyPath: "_placeholderLabel.textColor") as! UIColor }
        set { setValue(newValue, forKeyPath: "_placeholderLabel.textColor") }
    }
    
    /// (placeholder 字体大小).
    var placeholderFontSize: Float {
        get { return (value(forKeyPath: "_placeholderLabel.font") as! CGFloat).toFloat }
        set { setValue(UIFont.systemFont(ofSize: newValue.toCGFloat), forKeyPath: "_placeholderLabel.font") }
    }
    
    /// (左 内边距).
    func leftPadding(_ padding: CGFloat) {
        let view = UIView(frame: MakeRect(0, 0, padding, 1))
        view.backgroundColor = .clear
        leftView = view
        leftViewMode = .always
    }
    /// (右 内边距).
    func rightPadding(_ padding: CGFloat) {
        let view = UIView(frame: MakeRect(0, 0, padding, 1))
        view.backgroundColor = .clear
        rightView = view
        rightViewMode = .always
    }
    
}

