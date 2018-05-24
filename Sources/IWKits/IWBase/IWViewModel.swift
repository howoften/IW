//  Created by iWe on 2017/8/23.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

public class IWViewModel: NSObject {
    
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
    
    /// ---------------------------------------------- TableView
    public var customDataSource: [Any]?
    @discardableResult init(_ arr: [Any]) {
        super.init()
        self.customDataSource = arr
    }
    public var numberOfSection = 0
    private func _analysisNumberOfSectionInCustomDataSource() {
        self.numberOfSection = customDataSource.unwrapCount
    }
    public func analysisNumberOfRowsInCustomDataSource(section: Int) -> Int { return 0 }
    
    public var tbView: UITableView!
    init(bind tableView: UITableView) {
        super.init()
        self.tbView = tableView
    }
    /// ---------------------------------------------- TableView END
    
}

