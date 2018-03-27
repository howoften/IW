//  Created by iWw on 2018/3/14.
//  Copyright © 2018年 iWe. All rights reserved.
//

#if os(iOS)
    import UIKit
#endif

// MARK:- Var
public extension Array {
    
    /// (, 拼接. 例如: value1,value2,value3).
    public var toString: String {
        return toOtherString(byType: .string, nil)
    }
    
    /// (& 拼接. 例如: value1&value2&value3).
    public var toParameters: String {
        return toOtherString(byType: .parameters, nil)
    }
    
    public var toURLString: String {
        var tempString = ""
        for obj: Any in self {
            if obj is [String: Any] {
                let dic = obj as! [String: Any]
                for (key, value) in dic {
                    tempString = tempString + "\(key):\(value)"
                }
            } else {
                tempString = tempString + "\(obj)"
            }
        }
        tempString = tempString.removeLastCharacter
        return tempString
    }
    
    
}

// MAKR:- private function
public extension Array {
    
    private enum ToOtherType {
        case parameters
        case string
        case custom
    }
    private func toOtherString(byType: ToOtherType, _ custom: String?) -> String {
        var connect = ""
        if byType == .parameters {
            connect = "&"
        } else if byType == .custom {
            if custom != nil { connect = custom! }
        } else {
            connect = ","
        }
        var str = ""
        for obj: Any in self {
            var temp = ""
            if obj is String { temp = obj as! String }
            if obj is Dictionary<String, Any> { temp = "{" + (obj as! [String: Any]).toParameters + "}" }
            if obj is Array { temp = "[" + (obj as! [Any]).toParameters + "]" }
            str = str + temp + connect
        }
        return str.removeLastCharacter
    }
    
}

// MARK:- Function
public extension Array {
    
    subscript (safe index: Int) -> Element? {
        return (0 ..< count).contains(index) ? self[index] : nil
    }
    /// (like self[safe: index]).
    public func item(at index: Int) -> Element? {
        // From SwifterSwift: https://github.com/SwifterSwift/
        guard startIndex ..< endIndex ~= index else { return nil }
        return self[index]
    }
    /// (插入一条数据到第一个, insert(elemnt, at: 0)).
    public mutating func insertFront(_ newElement: Element) -> Void {
        // From SwifterSwift: https://github.com/SwifterSwift/
        insert(newElement, at: 0)
    }
    
    /// (交换两个 index 的位置).
    ///
    ///     [1, 2, 3, 4, 5].safeSwap(from: 3, to: 0) -> [4, 2, 3, 1, 5]
    public mutating func safeSwap(from index: Int, to toIndex: Int) {
        // From SwifterSwift: https://github.com/SwifterSwift/
        guard index != toIndex,
            startIndex ..< endIndex ~= index,
            startIndex ..< endIndex ~= toIndex else { return }
        swapAt(index, toIndex)
    }
    
    /// (返回条件成立的第一个位置).
    ///
    ///     ["1", "3", "7", "2", "5", "4", "3"].firstIndex({ $0 == "3" }) -> 1
    public func firstIndex(where condition: (Element) throws -> Bool) rethrows -> Int? {
        // From SwifterSwift: https://github.com/SwifterSwift/
        for (index, value) in lazy.enumerated() {
            if try condition(value) { return index }
        }
        return nil
    }
    
    /// (反向判断, 返回条件成立的第一个位置).
    ///
    ///     ["1", "3", "7", "2", "5", "4", "3"].lastIndex({ $0 == "3" }) -> 6
    public func lastIndex(where condition: (Element) throws -> Bool) rethrows -> Int? {
        // From SwifterSwift: https://github.com/SwifterSwift/
        for (index, value) in lazy.enumerated().reversed() {
            if try condition(value) { return index }
        }
        return nil
    }
    
    /// (返回条件成立的所有位置).
    ///
    ///     ["1", "3", "7", "2", "5", "4", "3"].indices({ $0 == "3" }) -> [1, 6]
    public func indices(where condition: (Element) throws -> Bool) rethrows -> [Int]? {
        // From SwifterSwift: https://github.com/SwifterSwift/
        var indicies: [Int] = []
        for (index, value) in lazy.enumerated() {
            if try condition(value) { indicies.append(index) }
        }
        return indicies.isEmpty ? nil : indicies
    }
    
    /// (所有条件都成立时返回 true).
    ///
    ///     [2, 2, 4].all(matching: { $0 % 2 == 0 }) -> true
    ///     [1, 2, 4].all(matching: { $0 % 2 == 0 }) -> false
    public func all(matching condition: (Element) throws -> Bool) rethrows -> Bool {
        // From SwifterSwift: https://github.com/SwifterSwift/
        return try !contains { try !condition($0) }
    }
    
    /// (所有条件都不成立时返回 true).
    ///
    ///     [2, 2, 4].none(matching: { $0 % 2 == 0 }) -> false
    ///     [1, 3, 5, 7].none(matching: { $0 % 2 == 0 }) -> true
    public func none(matching condition: (Element) throws -> Bool) rethrows -> Bool {
        // From SwifterSwift: https://github.com/SwifterSwift/
        return try !contains { try condition($0) }
    }
    
    /// (返回条件成立的个数).
    public func count(where condition: (Element) throws -> Bool) rethrows -> Int {
        // From SwifterSwift: https://github.com/SwifterSwift/
        var count = 0
        for element in self {
            if try condition(element) { count += 1 }
        }
        return count
    }
    
    public func forEachReversed(_ body: (Element) throws -> Void) rethrows {
        // From SwifterSwift: https://github.com/SwifterSwift/
        try reversed().forEach({ try body($0) })
    }
    
    /// (条件成立时触发 body 闭包).
    public func forEach(where condition: (Element) throws -> Bool, body: (Element) throws -> Void) rethrows {
        // From SwifterSwift: https://github.com/SwifterSwift/
        for element in self where try condition(element) {
            try body(element)
        }
    }
}

// MARK:- Equatable
public extension Array where Element: Equatable {
    
    public mutating func removeAll(_ item: Element) {
        // From SwifterSwift: https://github.com/SwifterSwift/
        self = filter({ $0 != item })
    }
    
    public mutating func removeAll(_ items: [Element]) {
        // From SwifterSwift: https://github.com/SwifterSwift/
        guard !items.isEmpty else { return }
        self = filter({ !items.contains($0) })
    }
    
    /// (合并重复项).
    public mutating func mergeDuplicates() {
        // From SwifterSwift: https://github.com/SwifterSwift/
        // Thanks to https://github.com/sairamkotha for improving the method
        self = reduce(into: [Element](), {
            if !$0.contains($1) { $0.append($1) }
        })
    }
}

// MARK:- Numeric
public extension Array where Element: Numeric {
    
    /// (求和).
    public func sum() -> Element {
        var total: Element = 0
        for i in 0 ..< count { total += self[i] }
        return total
    }
    
}

// MARK:- FloatingPoint
public extension Array where Element: FloatingPoint {
    
    /// (求平均值).
    public func average() -> Element {
        guard !isEmpty else { return 0 }
        var total: Element = 0
        for i in 0..<count {
            total += self[i]
        }
        return total / Element(count)
    }
    
}
