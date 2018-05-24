//
//  IWExtensions_UITableView.swift
//  IWExtensionDemo
//
//  Created by iWw on 2018/4/29.
//  Copyright © 2018年 iWe. All rights reserved.
//

#if os(iOS)

import UIKit

private extension UITableView {
    
    private struct Key {
        static var AutoRecordCellHeightKey: Void?
        static var CacheCellHeightKey: Void?
    }
    
}

public extension UITableView {
    
    /// (自动记录&缓存 cell 高度).
    public var autoRecordCellHeight: Bool {
        get { return (objc_getAssociatedObject(self, &Key.AutoRecordCellHeightKey) as? Bool).or(false) }
        set { objc_setAssociatedObject(self, &Key.AutoRecordCellHeightKey, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
    
    /// (记录&缓存的 cell 高度).
    public var cacheCellHeights: [IndexPath: CGFloat] {
        get { return (objc_getAssociatedObject(self, &Key.CacheCellHeightKey) as? [IndexPath: CGFloat]).or([:]) }
        set { objc_setAssociatedObject(self, &Key.CacheCellHeightKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    /// (记录 cell 高度).
    public func save(cellHeight: CGFloat, with indexPath: IndexPath) {
        if cacheCellHeights.has(key: indexPath) {
            guard let ch = cacheCellHeights[indexPath], ch != cellHeight else { return }
            cacheCellHeights[indexPath] = cellHeight
        } else {
            cacheCellHeights[indexPath] = cellHeight
        }
    }
    
    /// (提取 cell 高度).
    public func cacheHeight(with indexPath: IndexPath, `default`: CGFloat) -> CGFloat {
        guard cacheCellHeights.has(key: indexPath) else { return `default` }
        //print("获取缓存高度 \(cacheCellHeights[indexPath]!)")
        return cacheCellHeights[indexPath]!
    }
}

#endif
