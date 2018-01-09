//
//  IWRequestInfo.swift
//  haoduobaduo
//
//  Created by iWe on 2017/8/17.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

public class IWRequestInfo: NSObject {
    
    // MARK: 请求类型
    public enum MethodType: String {
        case post = "POST"
        case get = "GET"
    }
    
    // MARK: 请求结果的类型
    public enum ResultType: Int {
        case json = 0
        case image = 1
    }
    
    public struct ResultTypeSuffix {
        static var images: [String] {
            return ["jpg", "png", "gif", "psd", "ai", "raw", "eps", "cdr"]
        }
        static var files: [String] {
            return ["zip", "rar", "7z", "txt", "doc", "pdf", "xls"]
        }
    }
    
    public var url: URL! // URL
    public var method: MethodType! // POST, GET
    
    public var describe: String? // Custom describe
    
    /// Request parameters
    public var parameters: Any?
    /// String of parameters
    public var parametersString: String! = ""
    /// Subrange of parameters string in URL
    public var urlParameters: String?
    /// 用于取消
    public var urlSessionDataTask: URLSessionDataTask!
    
    /// Result type, defualt type is .json
    public var resultType: ResultType = .json
    
    /// Config in IWRequestManageModel -> setRequestInfo
    public var identity: String!
    /// Config in IWRequest
    public var request: IWRequest!
}
