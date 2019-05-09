//  Created by iWw on 2018/3/14.
//  Copyright © 2018年 iWe. All rights reserved.
//

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif

// MARK:- Bool
public extension Bool {
    
    /// (值为 false 返回 true).
    var isFalse: Bool {
        return !self
    }
    /// (值为 true 返回 true).
    var isTrue: Bool {
        return self
    }
    
    /// Return 1 if true, else return 0.
    var toInt: Int {
        return self ? 1 : 0
    }
    
    /// Return "true" if true, else return "false".
    var toString: String {
        return description
    }
    
    /// Return inversed value of bool.
    var inversed: Bool {
        return !self
    }
    
    static var random: Bool {
        return arc4random_uniform(2) == 1
    }
}

public extension Bool {
    
    /// (bool = true).
    mutating func enable() -> Void {
        self = true
    }
    /// (bool = false).
    mutating func disable() -> Void {
        self = false
    }
    
    /// (bool = false).
    @discardableResult mutating func toFalse() -> Bool {
        self = false
        return self
    }
    /// (bool = true).
    @discardableResult mutating func toTrue() -> Bool {
        self = true
        return self
    }
    /// (切换值). Swift 4 已自带
//    @discardableResult mutating func toggle() -> Bool {
//        self = !self
//        return self
//    }
    
    /// (条件成立时执行 todo, 不成立时执行 else).
    func founded(_ todo: (() -> Void), else: (() -> Void)? = nil) -> Void {
        if self { `todo`() } else { `else`?() }
    }
    /// (条件不成立时执行 todo, 成立时执行 else).
    func unfounded(_ todo: (() -> Void), else: (() -> Void)? = nil) -> Void {
        if !self { `todo`() } else { `else`?() }
    }
    /// (条件成立时返回 return，不成立时返回 elseReturn).
    func founded<T>(_ return: (() -> T), elseReturn: (() -> T)) -> T {
        return self ? `return`() : elseReturn()
    }
    /// (条件成立时返回 return，不成立时返回 elseReturn).
    func founded<T>(_ return: @autoclosure () -> T, elseReturn: @autoclosure () -> T) -> T {
        return self ? `return`() : elseReturn()
    }
    
    /// (条件不成立时返回 return，成立时返回 elseReturn).
    func unfounded<T>(_ return: (() -> T), elseReturn: (() -> T)) -> T {
        return !self ? `return`() : elseReturn()
    }
    /// (条件不成立时返回 return，成立时返回 elseReturn).
    func unfounded<T>(_ return: @autoclosure () -> T, elseReturn: @autoclosure () -> T) -> T {
        return !self ? `return`() : elseReturn()
    }
    
    func map<T>(_ arg1: @autoclosure () -> T, _ arg2: @autoclosure () -> T) -> T {
        return self ? arg1() : arg2()
    }
    
    /// (或).
    func or(_ other: @autoclosure () -> Bool) -> Bool {
        return self || other()
    }
    /// (或).
    func or(_ other: (() -> Bool)) -> Bool {
        return self || other()
    }
    /// (且).
    func and(_ other:@autoclosure () -> Bool) -> Bool {
        return self && other()
    }
    /// (且).
    func and(_ other: (() -> Bool)) -> Bool {
        return self && other()
    }
    
}
