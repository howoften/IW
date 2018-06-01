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
    
    /// (类似 or, 当条件(fn)不成立时, 以 `default` 作为返回值).
    public func map<T>(_ fn: (Wrapped) throws -> T, default: T) rethrows -> T {
        return try map(fn) ?? `default`
    }
    
    /// (类似 or, 当条件(fn)不成立时, 以返回的 `else()` 作为返回值).
    ///
    ///     let str: String? = "a"
    ///     str.map({ $0 == "a" }, else: { false }) -> true
    ///     str.map({ $0 == "c" }, else: { false }) -> false
    public func map<T>(_ fn: (Wrapped) throws -> T, else: () throws -> T) rethrows -> T {
        return try map(fn) ?? `else`()
    }
    
    /// (self 为 nil 时返回 nil, 否则返回可选值 B).
    public func and<B>(_ optional: B?) -> B? {
        guard self != nil else { return nil }
        return optional
    }
    
    /// (self 有值则传递至 then 闭包进行处理, 否则返回 nil).
    public func and<T>(then: (Wrapped) throws -> T?) rethrows -> T? {
        guard let unwrapped = self else { return nil }
        return try then(unwrapped)
    }
    
    /// (self 且 with 有值, 则返回解包后的结果「以元组类型返回」, 否则返回 nil).
    ///
    ///     let hello: String? = "hello"
    ///     let world: String? = "world"
    ///     hello.zip2(with: world) -> ("hello", "world")
    public func zip2<A>(with other: Optional<A>) -> (Wrapped, A)? {
        guard let first = self, let second = other else { return nil }
        return (first, second)
    }
    
    /// (self 且 with 且 another 都有值, 则返回解包后的结果「以元组类型返回」, 否则返回 nil).
    ///
    ///     let hello: String? = "hello"
    ///     let world: String? = "world"
    ///     let done: String? = "."
    ///     hello.zip3(with: world, another: done) -> ("hello", "world", ".")
    public func zip3<A, B>(with other: Optional<A>, another: Optional<B>) -> (Wrapped, A, B)? {
        guard let first = self,
            let second = other,
            let third = another else { return nil }
        return (first, second, third)
    }
    
    /// (self 有值则执行 some 闭包).
    public func on(some: (_ unwrapped: Wrapped) throws -> Void) rethrows {
        if self != nil { try some(self!) }
    }
    
    /// (self 为 nil 则执行 none 闭包).
    public func on(none: () throws -> Void) rethrows {
        if self == nil { try none() }
    }
    
    /// (self 有值且条件成立时返回自身, 否则返回 nil).
    ///
    ///     let str: String? = "a"
    ///     str.filter({ $0 == "a" }) -> Optional("a")
    ///     str.filter({ $0 == "0" }) -> nil
    public func filter(_ predicate: (Wrapped) throws -> Bool) rethrows -> Wrapped? {
        guard let unwrapped = self,
            try predicate(unwrapped) else { return nil }
        return self
    }
    
    /// (强制解包, 失败则触发 fatalError(message)).
    public func expect(_ message: String) -> Wrapped {
        guard let value = self else { fatalError(message) }
        return value
    }
    
    /// (also 条件成立时返回解包值, 否则返回 nil).
    public func also(_ also: (Wrapped) throws -> Bool) rethrows -> Wrapped? {
        guard let unwrapped = self, try also(unwrapped) else { return nil }
        return unwrapped
    }
}

extension Optional where Wrapped == Bool {
    public var orTrue: Bool {
        return true
    }
    public var orFalse: Bool {
        return false
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
