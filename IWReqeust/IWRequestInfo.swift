//
//  IWRequestInfo.swift
//  haoduobaduo
//
//  Created by iWe on 2017/8/17.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

class IWRequestInfo: NSObject {
    
    // MARK: 请求类型
    enum MethodType: String {
        case post = "POST"
        case get = "GET"
    }
    
    // MARK: 请求结果的类型
    enum ResultType: Int {
        case json = 0
        case image = 1
    }
    
    struct ResultTypeSuffix {
        static var images: [String] {
            return ["jpg", "png", "gif", "psd", "ai", "raw", "eps", "cdr"]
        }
        static var files: [String] {
            return ["zip", "rar", "7z", "txt", "doc", "pdf", "xls"]
        }
    }
    
    var url: URL! // URL
    var method: MethodType! // POST, GET
    
    var describe: String? // Custom describe
    
    /// Request parameters
    var parameters: Any?
    /// String of parameters
    var parametersString: String! = ""
    /// Subrange of parameters string in URL
    var urlParameters: String?
    /// 用于取消
    var urlSessionDataTask: URLSessionDataTask!
    
    /// Result type, defualt type is .json
    var resultType: ResultType = .json
    
    /// Config in IWRequestManageModel -> setRequestInfo
    var identity: String!
    /// Config in IWRequest
    var request: IWRequest!
}
