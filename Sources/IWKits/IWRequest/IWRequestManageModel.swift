//  Created by iWe on 2017/9/6.
//  Copyright © 2017年 iWe. All rights reserved.
//

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif

public class IWRequestManageModel: NSObject {
    
    public enum RequestStatus: Int {
        case error = -2
        case failed = -1
        case none = 0
        case succeed = 1
    }
    
    public static var manageModel: IWRequestManageModel {
        return IWRequestManageModel()
    }
    
    public var identity: String?
    public var request: IWRequest?
    
    // Config use Request
    public var urlString: String?
    public var method: String?
    public var httpBody: Data?
    public var parameters: String?
    
    // Config use myself
    public var status: RequestStatus = .none
    public var attempts: Int = 0
    
    public func setRequestInfo(withRequestInfo requestInfo: IWRequestInfo) {
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
