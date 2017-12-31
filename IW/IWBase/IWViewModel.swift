//
//  IWViewModel.swift
//  haoduobaduo
//
//  Created by iWe on 2017/8/23.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

class IWViewModel: NSObject {
    
    typealias SuccessHandler = (_ value: Any?) -> Void
    typealias ErrorHandler = (_ value: Any?) -> Void
    typealias FailureHandler = (_ error: Error?) -> Void
    
    var successBlock: SuccessHandler?
    var errorBlock: ErrorHandler?
    var failureBlock: FailureHandler?
    
    func model(successHandler: SuccessHandler?, errorHandler: ErrorHandler?, failureHandler: FailureHandler?) {
        
        successBlock = successHandler
        errorBlock = errorHandler
        failureBlock = failureHandler
    }
    
}
