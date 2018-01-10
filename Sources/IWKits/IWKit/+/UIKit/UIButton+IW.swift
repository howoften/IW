//
//  UIButton+IWView.swift
//  haoduobaduo
//
//  Created by iWe on 2017/9/20.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

public extension IWView where View: UIButton {
    
    /// Set fontSize with systemFont.
    /// (字体大小).
    var fontSize: Float {
        get { return Float(view.titleLabel?.font.pointSize ?? 17.0)  }
        set { view.titleLabel?.font = .systemFont(ofSize: CGFloat(newValue)) }
    }
    
    /// Set title for normal.
    /// (normal状态下的标题).
    var title: String? {
        get { return view.titleLabel?.text }
        set { view.setTitle(newValue, for: .normal) }
    }
    
    /// Set titleColor for normal.
    /// (normal状态下的字体颜色).
    var titleColor: UIColor? {
        get { return view.currentTitleColor }
        set { view.setTitleColor(newValue, for: .normal) }
    }
    
    /// (设置对应状态的字体颜色).
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - state: 状态
    func titleColor(_ color: UIColor?, _ state: UIControlState = .normal) -> Void {
        view.setTitleColor(color, for: state)
    }
    
    /// Set titleLabel alignment.
    /// (字体对齐方式).
    var titleAlignment: NSTextAlignment {
        get { return view.titleLabel?.textAlignment ?? .left }
        set { view.titleLabel?.textAlignment = newValue }
    }
    
    /// Set backgroundColor.
    /// (背景颜色).
    func bgColor(_ color: UIColor) {
        view.backgroundColor = color
        titleColor(.white)
    }
    
}

