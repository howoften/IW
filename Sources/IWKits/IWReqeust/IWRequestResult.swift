//  Created by iWe on 2017/6/15.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

public class IWRequestResult: NSObject {
    
    public var requestInfo: IWRequestInfo!
    public var requestManage: IWRequestManage!
    
    /// Result datas
    public var data: Data?
    /// Data to Dictionary
    public var dictionary: [String: Any]?
    /// Data to Dictionary failed and try to String
    public var string: String?
    public var stringValue: String!
    
    /// Request error
    public var error: Error?
    
    public typealias successedHandler = (_ data: Data?, _ dictionary: [String: Any]?, _ result: IWRequestResult) -> Void
    public typealias failedHandler = (_ error: Error?) -> Void
    
    public var success: successedHandler?
    public var failed: failedHandler?
    
    public func cancel() {
        requestInfo.urlSessionDataTask.cancel()
    }
    
    /// Request result. The default does not handle request failure.
    public func result(success handler: successedHandler?) {
        self.success = handler
    }
    
    /// Request result.
    public func result(success: successedHandler?, failed: failedHandler?) {
        self.success = success
        self.failed = failed
    }
    
    /// Request failed.
    public func requestFailed(_ handler: failedHandler?) {
        self.failed = handler
    }
    
    /// Execute successed action.
    public func executeSuccessHandler() -> Void {
        
        printLog()
        
        if success != nil {
            var dic: [String: Any]? = nil
            if requestInfo.resultType == .json {
                dic = data?.toDictionary()
            }
            if dic != nil {
                self.dictionary = dic!
                iw.main.execution { self.success!(self.data, dic, self); self.success = nil; }
            } else {
                self.string = data?.iwe.string
                self.stringValue = data?.iwe.stringValue
                iw.main.execution { self.success!(self.data, nil, self); self.success = nil; }
            }
        }
        //success = nil
    }
    
    /// Execute failed action.
    public func executeFailHandler() -> Void {
        iw.main.execution { self.failed?(self.error) }
    }
    
    public func printLog() {
        
        if IWRequest.openPromptMode && !IWRequest.openDebugMode {
            // 提示模式输出
            promptContent()
        } else if IWRequest.openDebugMode {
            // 调试模式输出
            debugContent()
        }
    }
    
    public func promptContent() {
        
        if requestInfo.resultType == .json {
            var str = "      Request info: { " + (requestInfo.describe ?? "")
            str = str + "\n" + "       Requset URL: \(requestInfo.url.absoluteString) \n    Request method: \(requestInfo.method.rawValue) \n"
            if let httpBodyString = requestInfo.parametersString, httpBodyString != "" {
                str = str + "         POST Data: \(httpBodyString) \n"
            }
            if let urlParameters = requestInfo.urlParameters, urlParameters != "" {
                str = str + "          GET Data: \(urlParameters) \n"
            }
            
            if error == nil {
                str = str + "            Result: Succeed \n} \n"
            } else {
                str = str + "            Result: Failed, Error code[ \((error as NSError?)!.code) ], Error desc[ \(error?.localizedDescription ?? "No output error messages.") ] \n}\n"
            }
            print(str)
            return
        }
    }
    
    public func debugContent() {
        if requestInfo.resultType == .json {
            var str = "      Request info: { " + (requestInfo.describe ?? "")
            str = str + "\n" + "       Requset URL: \(requestInfo.url.absoluteString) \n    Request method: \(requestInfo.method.rawValue) \n"
            if let httpBodyString = requestInfo.parametersString, httpBodyString != "" {
                str = str + "         POST Data: \(httpBodyString) \n"
            }
            if let urlParameters = requestInfo.urlParameters, urlParameters != "" {
                str = str + "          GET Data: \(urlParameters) \n"
            }
            
            if error == nil {
                str = str + "            Result: Succeed \n\(backContent())"
            } else {
                str = str + "            Result: Failed, Error code[ \((error as NSError?)!.code) ], Error desc[ \(error?.localizedDescription ?? "No output error messages.") ] \n}\n"
            }
            print(str)
            return
        }
    }
    
    public func backContent() -> String {
        var str = ""
        if requestInfo.resultType == .json {
            if let dic = data!.toDictionary() {
                str = str + "     Returned data: \(String(describing: dic.toString)) \n} \n"
            } else {
                if let arr = data!.toArray() {
                    str = str + "     Returned data: \(String(describing: arr.toString)) \n} \n"
                } else {
                    if let string = String.init(data: data!, encoding: .utf8) {
                        str = str + "     Returned data: \n\(string)\n}"
                    } else {
                        str = str + "     Returned data: Data type data is not displayed. \n} \n"
                    }
                }
            }
        }
        return str
    }
}


public extension Data {
    
    func toDictionary() -> [String: Any]? {
        do {
            let dic = try JSONSerialization.jsonObject(with: self, options: .allowFragments)
            if let result = dic as? [String : Any] {
                return result
            }
            return nil
        } catch {
            iPrint("The Data to Dictionary failed", error: error)
        }
        return nil
    }
    
    func toArray() -> [Any]? {
        do {
            let dic = try JSONSerialization.jsonObject(with: self, options: .allowFragments)
            return dic as? [Any]
        } catch {
            iPrint("The Data to Array failed", error: error)
            
        }
        return nil
    }
}

