//
//  IWExtensions_Error.swift
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


public extension Error {
    
    /// (NSError().code).
    public var code: Int {
        return (self as NSError).code
    }
    /// (Error().localizedDescription).
    public var description: String {
        return localizedDescription
    }
    
}
