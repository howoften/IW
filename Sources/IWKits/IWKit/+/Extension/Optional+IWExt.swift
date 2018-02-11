//  Created by iWw on 23/01/2018.
//  Copyright © 2018 iWe. All rights reserved.
//

import UIKit

/// (可选类型).
extension Optional {
    /// Returns true if the optional is empty.
    /// (是否为空).
    public var isNone: Bool {
        switch self {
        case .none: return true
        default: return false
        }
    }
    
    /// Returns true if the optional is not empty.
    /// (是否有值).
    public var isSome: Bool {
        switch self {
        case .some(_): return true
        default: return false
        }
    }
    
    /// Returns value.
    /// (返回解析值, 若目标值为nil 则直接崩溃).
    public var unwrapValue: Wrapped {
        if self.isSome { return self! }
        fatalError("Unexpectedly found nil while unwrapping an Optional value (解析失败, 目标值为nil).")
    }
    
    /// Return the value of the Optional or the `default` parameter
    /// (如果目标有值则返回目标值, 否则返回defualt).
    public func or(_ default: Wrapped) -> Wrapped {
        return self ?? `default`
    }
    
    /// Returns the unwrapped value of the optional *or*
    /// the result of an expression `else`
    /// I.e. optional.or(else: print("Arrr"))
    public func or(else: @autoclosure () -> Wrapped) -> Wrapped {
        return self ?? `else`()
    }
    
    /// Returns the unwrapped value of the optional *or*
    /// the result of calling the closure `else`
    /// I.e. optional.or(else: {
    /// ... do a lot of stuff
    /// })
    public func or(else: () -> Wrapped) -> Wrapped {
        return self ?? `else`()
    }
    
    /// Returns the unwrapped contents of the optional if it is not empty
    /// If it is empty, throws exception `throw`
    public func or(throw exception: Error) throws -> Wrapped {
        guard let unwrapped = self else { throw exception }
        return unwrapped
    }
    
    
    /// (强解析, 有值则处理事件, 值为 nil 时会直接崩溃).
    public func forceUnwrapped(_ todo: (Wrapped) -> Void) -> Void {
        guard let unwrapped = self else {
            fatalError("目标值为nil")
        }
        `todo`(unwrapped)
    }
    
    /// (弱解析, 有值则处理事件, 值为 nil 则执行 else).
    public func unwrapped(_ todo: (Wrapped) -> Void, else: (() -> Void)? = nil) -> Void {
        guard let unwapped = self else {
            `else`?()
            return
        }
        `todo`(unwapped)
    }
    
    /// Maps the output *or* returns the default value if the optional is nil
    /// - parameter fn: The function to map over the value
    /// - parameter or: The value to use if the optional is empty
    public func map<T>(_ fn: (Wrapped) throws -> T, default: T) rethrows -> T {
        return try map(fn) ?? `default`
    }
    
    /// Maps the output *or* returns the result of calling `else`
    /// - parameter fn: The function to map over the value
    /// - parameter else: The function to call if the optional is empty
    public func map<T>(_ fn: (Wrapped) throws -> T, else: () throws -> T) rethrows -> T {
        return try map(fn) ?? `else`()
    }
    
    /// Tries to unwrap `self` and if that succeeds continues to unwrap the parameter `optional`
    /// and returns the result of that.
    public func and<B>(_ optional: B?) -> B? {
        guard self != nil else { return nil }
        return optional
    }
    
    /// Executes a closure with the unwrapped result of an optional.
    /// This allows chaining optionals together.
    public func and<T>(then: (Wrapped) throws -> T?) rethrows -> T? {
        guard let unwrapped = self else { return nil }
        return try then(unwrapped)
    }
    
    /// Zips the content of this optional with the content of another
    /// optional `other` only if both optionals are not empty
    public func zip2<A>(with other: Optional<A>) -> (Wrapped, A)? {
        guard let first = self, let second = other else { return nil }
        return (first, second)
    }
    
    /// Zips the content of this optional with the content of another
    /// optional `other` only if both optionals are not empty
    public func zip3<A, B>(with other: Optional<A>, another: Optional<B>) -> (Wrapped, A, B)? {
        guard let first = self,
            let second = other,
            let third = another else { return nil }
        return (first, second, third)
    }
    
    /// Executes the closure `some` if and only if the optional has a value
    public func on(some: () throws -> Void) rethrows {
        if self != nil { try some() }
    }
    
    /// Executes the closure `none` if and only if the optional has no value
    public func on(none: () throws -> Void) rethrows {
        if self == nil { try none() }
    }
    
    /// Returns the unwrapped value of the optional only if
    /// - The optional has a value
    /// - The value satisfies the predicate `predicate`
    public func filter(_ predicate: (Wrapped) -> Bool) -> Wrapped? {
        guard let unwrapped = self,
            predicate(unwrapped) else { return nil }
        return self
    }
    
    /// Returns the wrapped value or crashes with `fatalError(message)`
    public func expect(_ message: String) -> Wrapped {
        guard let value = self else { fatalError(message) }
        return value
    }
    
    /// (alse 条件成立时返回解包值, 否则返回 nil).
    public func also(_ also: (Wrapped) throws -> Bool) rethrows -> Wrapped? {
        guard let unwrapped = self else { return nil }
        return try also(unwrapped) ? unwrapped : nil
    }
}

extension Optional where Wrapped == String {
    /// (Wrapped == String. 返回 "").
    public var orEmpty: String { return self ?? "" }
}

extension Optional where Wrapped == Error {
    /// Only perform `else` if the optional has a non-empty error value
    public func or(_ else: (Error) -> Void) {
        guard let error = self else { return }
        `else`(error)
    }
}


extension Optional where Wrapped: Collection {
    /// (解包值, 若目标值为 nil, 则返回 0).
    public var unwrapCount: Int {
        return Int(self?.count ?? 0)
    }
}
