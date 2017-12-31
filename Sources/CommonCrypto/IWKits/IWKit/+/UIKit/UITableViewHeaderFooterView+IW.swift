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
    final func fixBackgroundColorWarning() -> Void {
        // view.backgroundView = UIView()
        // view.backgroundView!.backgroundColor = .clear
		view.tintColor = .clear
    }
    
}
