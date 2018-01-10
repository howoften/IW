//
//  UILabel+IWView.swift
//  haoduobaduo
//
//  Created by iWe on 2017/9/20.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

public extension IWView where View: UILabel {
    
    /// (将目标UILabel的样式属性设置到当前UILabel上).
    /// (将会复制的样式属性包括：font、textColor、backgroundColor、lineBreakMode、textAlignment).
    ///
    /// - Parameter as: 要从哪个目标UILabel上复制样式
    final func same(as label: UILabel) -> Void {
        self.view.font = label.font
        self.view.textColor = label.textColor
        self.view.backgroundColor = label.backgroundColor
        self.view.lineBreakMode = label.lineBreakMode
        self.view.textAlignment = label.textAlignment
    }
    
}

