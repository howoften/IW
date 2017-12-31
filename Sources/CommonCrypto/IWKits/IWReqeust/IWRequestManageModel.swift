//
//  IWRequestManageModel.swift
//  haoduobaduo
//
//  Created by iWe on 2017/9/6.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

class IWRequestManageModel: NSObject {
    
    enum RequestStatus: Int {
        case error = -2
        case failed = -1
        case none = 0
        case succeed = 1
    }
    
    static var manageModel: IWRequestManageModel {
        return IWRequestManageModel()
    }
    
    var identity: String?
    var request: IWRequest?
    
    // Config use Request
    var urlString: String?
    var method: String?
    var httpBody: Data?
    var parameters: String?
    
    // Config use myself
    var status: RequestStatus = .none
    var attempts: Int = 0
    
    func setRequestInfo(withRequestInfo requestInfo: IWRequestInfo) {
        // 配置唯一标志
        identity = String.random32Bit
        requestInfo.identity = identity
        
        // 请求体
        request = requestInfo.request
        urlString = requestInfo.url.absoluteString
        method = requestInfo.method.rawValue
        httpBody = requestInfo.request?.urlRequest.httpBody
        parameters = urlString?.components(separatedBy: "?").last
    }
}
