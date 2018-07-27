//  Created by iWw on 2018/3/14.
//  Copyright © 2018年 iWe. All rights reserved.
//

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif

// MARK:- Var
public extension URL {
    
    /// (以字典形式返回链接中提交的参数)
    public var submissionParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false), let queryItems = components.queryItems else { return nil }
        
        var items: [String: String] = [:]
        for queryItem in queryItems {
            items[queryItem.name] = queryItem.value
        }
        return items
    }
    
}


// MARK:- Functions
public extension URL {
    
    /// (添加参数到链接后).
    ///
    ///     let url = URL(string: "https://www.google.com")!
    ///     let param = ["q": "IWExtension"]
    ///     url.appendingQueryParameters(param) -> "https://google.com?q=Swifter%20Swift"
    public func appendingQueryParameters(_ parameters: [String: String]) -> URL {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        var items = urlComponents.queryItems ?? []
        items += parameters.map({ URLQueryItem(name: $0, value: $1) })
        urlComponents.queryItems = items
        return urlComponents.url!
    }
    
}
