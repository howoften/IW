//
//  IWExtensions_CAAnimation.swift
//  IWExtensionDemo
//
//  Created by iWw on 2018/3/14.
//  Copyright © 2018年 iWe. All rights reserved.
//

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif


public extension CAAnimation {
    
    private struct Key {
        static var keepStateAtEndKey: Void?
    }
    
}

public extension CAAnimation {
    
    
    /// (保持动画结束后的状态).
    var isKeepStateAtEnd: Bool {
        get { return objc_getAssociatedObject(self, &Key.keepStateAtEndKey).or(false) as! Bool }
        set { objc_setAssociatedObject(self, &Key.keepStateAtEndKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN); setKeepStateAtEnd(with: newValue) }
    }
    
}

public extension CAAnimation {
    
    private func setKeepStateAtEnd(with keep: Bool) {
        if keep {
            self.fillMode = kCAFillModeForwards
            self.isRemovedOnCompletion = !keep
        } else {
            self.fillMode = kCAFillModeRemoved
            self.isRemovedOnCompletion = keep
        }
    }
    
}
