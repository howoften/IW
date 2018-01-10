//
//  IWNibLoadable.swift
//  haoduobaduo
//
//  Created by iWe on 2017/9/6.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

public protocol IWNibLoadable: class {
    /// (返回 UINib).
    static var nib: UINib { get }
}

public extension IWNibLoadable {
    
    /// (返回 UINib).
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}

public extension IWNibLoadable where Self: UIView {
    
    /// (从 xib 加载 view).
    public static func loadFromNib() -> Self {
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("The nib \(nib) expected its root view to be of type \(self)")
        }
        return view
    }
}

