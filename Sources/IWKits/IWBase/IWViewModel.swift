//
//  IWViewModel.swift
//  haoduobaduo
//
//  Created by iWe on 2017/8/23.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

public class IWViewModel: NSObject {
    
    public typealias SuccessHandler = (_ value: Any?) -> Void
    public typealias ErrorHandler = (_ value: Any?) -> Void
    public typealias FailureHandler = (_ error: Error?) -> Void
    
    var successBlock: SuccessHandler?
    var errorBlock: ErrorHandler?
    var failureBlock: FailureHandler?
    
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
    
}
