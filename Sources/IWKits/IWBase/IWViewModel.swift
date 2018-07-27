//  Created by iWe on 2017/8/23.
//  Copyright © 2017年 iWe. All rights reserved.
//

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif

open class IWViewModel: NSObject {
    
    public typealias SuccessHandler = (_ value: Any?) -> Void
    public typealias ErrorHandler = (_ value: Any?) -> Void
    public typealias FailureHandler = (_ error: Error?) -> Void
    
    public var successBlock: SuccessHandler?
    public var errorBlock: ErrorHandler?
    public var failureBlock: FailureHandler?
    
    /// (回调处理).
    ///
    /// - Parameters:
    ///   - successHandler: 成功.
    ///   - errorHandler: 错误.
    ///   - failureHandler: 失败.
    public func model(successHandler: SuccessHandler?, errorHandler: ErrorHandler?, failureHandler: FailureHandler?) {
        successBlock = successHandler
        errorBlock = errorHandler
        failureBlock = failureHandler
    }
    
    open var numberOfSections: Int {
        return 0
    }
    open func numberOfRows(in section: Int) -> Int {
        return 0
    }
    open func cellModel<T: NSObject>(with indexPath: IndexPath) -> T? {
        return nil
    }
}

