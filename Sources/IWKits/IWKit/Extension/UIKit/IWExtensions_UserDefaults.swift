//
//  IWExtensions_UserDefaults.swift
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


public extension UserDefaults {
    
    public subscript(key: String) -> Any? {
        get { return object(forKey: key) }
        set { set(newValue, forKey: key) }
    }
    
    public func string(forKey key: String) -> String? {
        return object(forKey: key) as? String
    }
    
    /// (传入字典自动存储, 返回同步结果 可忽略返回值).
    @discardableResult public func set(with keyValues: [String: Any?]) -> Bool {
        keyValues.forEach({ UserDefaults.standard.setValue($0.value, forKey: $0.key) })
        return UserDefaults.standard.synchronize()
    }
}
