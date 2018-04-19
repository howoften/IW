//  Created by iWw on 2018/3/14.
//  Copyright © 2018年 iWe. All rights reserved.
//

#if os(iOS)
    import UIKit
#endif

// MARK:- Bool
public extension Bool {
    
    /// (值为 false 返回 true).
    public var isFalse: Bool {
        return !self
    }
    /// (值为 true 返回 true).
    public var isTrue: Bool {
        return self
    }
    
    /// Return 1 if true, else return 0.
    public var toInt: Int {
        return self ? 1 : 0
    }
    
    /// Return "true" if true, else return "false".
    public var toString: String {
        return description
    }
    
    /// Return inversed value of bool.
    public var inversed: Bool {
        return !self
    }
    
    public static var random: Bool {
        return arc4random_uniform(2) == 1
    }
}

public extension Bool {
    
    /// (bool = true).
    public mutating func enable() -> Void {
        self = true
    }
    /// (bool = false).
    public mutating func disable() -> Void {
        self = false
    }
    
    /// (bool = false).
    @discardableResult public mutating func toFalse() -> Bool {
        self = false
        return self
    }
    /// (bool = true).
    @discardableResult public mutating func toTrue() -> Bool {
        self = true
        return self
    }
    /// (切换值).
    @discardableResult public mutating func toggle() -> Bool {
        self = !self
        return self
    }
    
    /// (条件成立时执行 todo, 不成立时执行 else).
    public func founded(_ todo: (() -> Void), else: (() -> Void)? = nil) -> Void {
        if self { `todo`() } else { `else`?() }
    }
    /// (条件不成立时执行 todo, 成立时执行 else).
    public func unfounded(_ todo: (() -> Void), else: (() -> Void)? = nil) -> Void {
        if !self { `todo`() } else { `else`?() }
    }
    /// (条件成立时返回 return，不成立时返回 elseReturn).
    public func founded<T>(_ return: (() -> T), elseReturn: (() -> T)) -> T {
        return self ? `return`() : elseReturn()
    }
    /// (条件成立时返回 return，不成立时返回 elseReturn).
    public func founded<T>(_ return: @autoclosure () -> T, elseReturn: @autoclosure () -> T) -> T {
        return self ? `return`() : elseReturn()
    }
    
    /// (条件不成立时返回 return，成立时返回 elseReturn).
    public func unfounded<T>(_ return: (() -> T), elseReturn: (() -> T)) -> T {
        return !self ? `return`() : elseReturn()
    }
    /// (条件不成立时返回 return，成立时返回 elseReturn).
    public func unfounded<T>(_ return: @autoclosure () -> T, elseReturn: @autoclosure () -> T) -> T {
        return !self ? `return`() : elseReturn()
    }
    
    public func ope<T>(_ arg1: @autoclosure () -> T, _ arg2: @autoclosure () -> T) -> T {
        return self ? arg1() : arg2()
    }
    
    /// (或).
    public func or(_ other: @autoclosure () -> Bool) -> Bool {
        return self || other()
    }
    /// (或).
    public func or(_ other: (() -> Bool)) -> Bool {
        return self || other()
    }
    /// (且).
    public func and(_ other:@autoclosure () -> Bool) -> Bool {
        return self && other()
    }
    /// (且).
    public func and(_ other: (() -> Bool)) -> Bool {
        return self && other()
    }
    
}
