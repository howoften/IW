//  Created by iWe on 2017/9/28.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

public final class IWFont<Font> {
    /// (自身).
    public let font: Font
    public init(_ font: Font) {
        self.font =  font
    }
}

public protocol IWFontCompatible {
    associatedtype IWE
    var iwe: IWE { get }
}

public extension IWFontCompatible {
    public var iwe: IWFont<Self> {
        get { return IWFont(self) }
    }
}

extension UIFont: IWFontCompatible { }

public extension IWFont where Font: UIFont {
    
    enum FontType: String {
        case regular = "Regular"
        case italic = "Italic"
        case bold = "Bold"
        case boldItalic = "BoldItalic"
    }
    
    /// (获取字体).
    final class func fontFamily(_ name: String, type: FontType = .regular, size: CGFloat = 14.0) -> UIFont? {
        let fontFamily = UIFont.fontNames(forFamilyName: name)
        for font in fontFamily {
            let str = name + "-\(type.rawValue)"
            if font == str {
                return UIFont(name: font, size: size)
            }
        }
        return nil
    }
    
}

