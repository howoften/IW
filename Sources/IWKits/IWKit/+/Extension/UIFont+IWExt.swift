//
//  UIFont+IWExt.swift
//  IWExtensionDemo
//
//  Created by iWw on 2018/2/26.
//  Copyright © 2018年 iWe. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
#endif

public extension UIFont {
    
    /// (文字类型: 正常、粗体、斜体、粗斜).
    public enum FontType: String {
        /// (正常).
        case regular = "Regular"
        /// (斜体).
        case italic = "Italic"
        /// (粗体).
        case bold = "Bold"
        /// (粗斜).
        case boldItalic = "BoldItalic"
    }
    
}

public extension UIFont {
    
    /// bold type.
    /// (粗体文字).
    public var bold: UIFont {
        return UIFont(descriptor: fontDescriptor.withSymbolicTraits(.traitBold)!, size: 0)
    }
    
    /// italic type.
    /// (斜体文字).
    public var italic: UIFont {
        return UIFont(descriptor: fontDescriptor.withSymbolicTraits(.traitItalic)!, size: 0)
    }
    
    /// (等宽字体).
    /// eg: UIFont.preferredFont(forTextStyle: .body).monospaced
    public var monospaced: UIFont {
        let settings = [[UIFontDescriptor.FeatureKey.featureIdentifier: kNumberSpacingType, UIFontDescriptor.FeatureKey.typeIdentifier: kMonospacedNumbersSelector]]
        
        let attributes = [UIFontDescriptor.AttributeName.featureSettings: settings]
        let newDescriptor = fontDescriptor.addingAttributes(attributes)
        return UIFont(descriptor: newDescriptor, size: 0)
    }
    
}

public extension UIFont {
    
    /// (获取字体).
    public static func fontFamily(_ name: String, type: FontType = .regular, size: CGFloat = 14.0) -> UIFont? {
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
