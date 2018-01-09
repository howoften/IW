//  Created by iWe on 2017/6/15.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

public class IWRequest: NSObject {
    
    // 开启调试模式, 开启后输出所有信息
    public static var openDebugMode: Bool = false
    // 开启提示模式, 开启后输出关键信息
    public static var openPromptMode: Bool = true
    
    public typealias IWRequestSuccessedHandler = (Data?) -> Void
    public typealias IWRequestFailedHandler = (Error?) -> Void
    
    fileprivate var session: URLSession!
    fileprivate lazy var responseData: Data = {
        return Data()
    }()
    public var urlRequest: URLRequest!
    
    // 结果
    fileprivate var result: IWRequestResult = IWRequestResult()
    // 请求信息
    fileprivate var info: IWRequestInfo = IWRequestInfo()
    
    
    // MARK:- 配置POST
    fileprivate func config(post url: URL, parameters: Any?, desc: String?) -> Void {
        self.config(by: .post, url: url, parameters: parameters, desc: desc)
    }
    // MARK:- 配置GET
    fileprivate func config(get url: URL, parameters: Any?, desc: String?) -> Void {
        self.config(by: .get, url: url, parameters: parameters, desc: desc)
    }
    
    // MARK:- Configure URLRequest by method, url and parameters.
    fileprivate func config(by method: IWRequestInfo.MethodType, url: URL, parameters: Any?, desc: String?) -> Void {
        
        urlRequest = URLRequest.init(url: url)
        var sendParameters = parameters
        
        urlRequest.httpMethod = method.rawValue
        
        if sendParameters != nil {
            
            let requestData: Data? = handlerReqeustData(sendParameters!)
            
            if method == .get {
                if sendParameters is String {
                    urlRequest.url = (url.absoluteString + "?" + (sendParameters as! String)).toURL
                } else if sendParameters is [String: Any] {
                    urlRequest.url = (url.absoluteString + "?" + (sendParameters as! [String: Any]).toParameters).toURL
                }
                
                sendParameters = nil
            } else {
                urlRequest.httpBody = requestData
            }
        }
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 6.0
        let operationQueue = OperationQueue.init()
        operationQueue.maxConcurrentOperationCount = 1
        
        session = URLSession.init(configuration: sessionConfig, delegate: self, delegateQueue: operationQueue)
		
        let dataTask = session.dataTask(with: urlRequest)
        
        // Config(Record) Request info
        recordRequstInfo(parameters, desc: desc, dataTask: dataTask)
        
        if IWRequest.openPromptMode {
            // Tips desc
            if let urlStr = urlRequest.url { print("Start request: \(urlStr)") }
        }
		
		// Add info to RequestManage instance
		IWRequestManage.add(info)
		
        // Resume
        dataTask.resume()
    }
    
    /// 处理请求的数据
    fileprivate func handlerReqeustData(_ parameters: Any) -> Data? {
        var requestData: Data?
        if parameters is [String: Any] {
            let p = (parameters as! [String: Any]).toParameters
            requestData = p.data(using: String.Encoding.utf8)
        }
        if parameters is String {
            requestData = (parameters as! String).data(using: String.Encoding.utf8)
        }
        return requestData
    }
    
    fileprivate func requestResult() -> IWRequestResult {
        return self.result
    }
}

public extension IWRequest {
    
    public func retry() {
        responseData = Data()
        IWRequestManage.requestStatusIsFailed(withRequestInfo: info) ? session.dataTask(with: urlRequest).cancel() : session.dataTask(with: urlRequest).resume()
    }
}

extension IWRequest {
    
    // MARK:- Record result from URLRequest and parameters.
    /// 记录请求信息
    fileprivate func recordRequstInfo(_ parameters: Any?, desc: String?, dataTask: URLSessionDataTask) -> Void {
        info.describe = desc
        info.urlSessionDataTask = dataTask
        info.method = IWRequestInfo.MethodType(rawValue: urlRequest.httpMethod!)
        info.url = urlRequest.url
        if let httpBody = urlRequest.httpBody {
            info.parameters = String.init(data: httpBody, encoding: .utf8)
            info.parametersString = info.parameters as? String
        }
        let urlString = info.url.absoluteString
        if urlString.contains("?") && urlString.contains("=") {
            let tempParameters = urlRequest.url!.absoluteString.components(separatedBy: "?")
            info.urlParameters = tempParameters.last!
        }
        
        if urlString.pathExtension.containsEx(in: IWRequestInfo.ResultTypeSuffix.images) {
            info.resultType = .image
        } else {
            info.resultType = .json
        }
        info.request = self
    }
    
}

public extension IWRequest {
    fileprivate class func request() -> IWRequest {
        return IWRequest()
    }
    // MARK: Class POST
    public class func post(_ url: String, parameters: Any? = nil, desc: String? = nil) -> IWRequestResult {
        let request = IWRequest.request()
        request.config(post: url.toURL, parameters: parameters, desc: desc)
        return request.requestResult()
    }
    // MARK: Class GET
    public class func get(_ url: String, parameters: Any? = nil, desc: String? = nil) -> IWRequestResult {
        let request = IWRequest.request()
        request.config(get: url.toURL, parameters: parameters, desc: desc)
        return request.requestResult()
    }
}


extension IWRequest: URLSessionDataDelegate {
    // MARK:- URLSessionDataDelegate
    // MARK: Did receive completion
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        completionHandler(URLSession.ResponseDisposition.allow)
    }
    
    // MARK: Did receive
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        responseData.append(data)
    }
    
    // MARK: Did complete
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        result.requestInfo = info
        if error == nil {
            // Success
            IWRequestManage.requestSucceed(info)
            result.data = self.responseData
            result.executeSuccessHandler()
            return
        }
        // Has error
        if (error as NSError?)?.code == -999 {
            if let manageModel = IWRequestManage.requestManageModel(withRequestInfo: info), manageModel.attempts >= 3 {
                result.error = error
                result.executeFailHandler()
            }
            return
        }
        IWRequestManage.requestError(info)
    }
}

extension IWRequest: URLSessionTaskDelegate {
    
    // 进度
    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
    }
}
