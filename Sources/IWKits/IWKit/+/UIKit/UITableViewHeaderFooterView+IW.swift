//
//  IWTableViewHeaderFooterView.swift
//  haoduobaduo
//
//  Created by iWe on 2017/8/24.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

extension IWView where View: UITableViewHeaderFooterView {
    
    /// Use in init(func `awakeFromNib` or `init`).
    /// (修复背景颜色 Xcode 警告, 用在 awakeFromNib 或者 init 中).
    final func fixBackgroundColorWarning() -> Void {
        view.backgroundView = UIView(frame: view.bounds)
        view.backgroundView!.backgroundColor = .clear
    }
    
}
