//
//  DispatchQueue+IWExt.swift
//  IWExtensionDemo
//
//  Created by iWw on 2018/3/12.
//  Copyright © 2018年 iWe. All rights reserved.
//

#if os(iOS)
    import UIKit
#endif

public extension DispatchQueue {
    
    private static var _onceToken = [String]()
    
    /// (DispatchQueue.once()).
    public static func once(token: String, block: () -> Void) -> Void {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        
        if _onceToken.contains(token) { return }
        
        _onceToken.append(token)
        block()
    }
    
}
