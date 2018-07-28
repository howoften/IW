//
//  IWExtensions_NSView.swift
//  IWExtensionDemo
//
//  Created by iWw on 2018/7/28.
//  Copyright © 2018 iWe. All rights reserved.
//

#if os(macOS)
import Cocoa

public extension NSView {
    
    /// (从 xib 初始化视图).
    public class func fromNib<T: NSView>() -> T? {
        var viewArray: NSArray? = NSArray()
        let nibName = String(describing: self)
        guard Bundle.main.loadNibNamed(NSNib.Name(rawValue: nibName), owner: nil, topLevelObjects: &viewArray) else {
            return nil
        }
        return viewArray!.first(where: { $0 is T }) as? T
    }
    
    /// (设置背景颜色).
    public var bgColor: CGColor? {
        get { return self.layer?.backgroundColor }
        set { if (!self.wantsLayer) { self.wantsLayer = true }; self.layer?.backgroundColor = newValue }
    }
    
}

#endif
