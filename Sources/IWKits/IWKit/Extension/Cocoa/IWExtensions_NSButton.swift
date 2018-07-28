//
//  IWExtensions_NSButton.swift
//  IWExtensionDemo
//
//  Created by iWw on 2018/7/28.
//  Copyright © 2018 iWe. All rights reserved.
//

#if os(macOS)
import Cocoa

public extension NSButton {
    
    /// (设置标题颜色).
    public func setTitleColor(_ color: NSColor) -> Void {
        let attrTitle = NSMutableAttributedString.init(attributedString: self.attributedTitle)
        let len = attrTitle.length
        let range = NSMakeRange(0, len)
        attrTitle.addAttributes([NSAttributedStringKey.foregroundColor : color], range: range)
        attrTitle.fixAttributes(in: range)
        self.attributedTitle = attrTitle
        //self.setNeedsDisplay()
    }
    
}
#endif
