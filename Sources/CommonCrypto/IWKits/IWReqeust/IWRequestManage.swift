//
//  IWRequestManage.swift
//  haoduobaduo
//
//  Created by iWe on 2017/8/17.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

class IWRequestManage: NSObject {
    
    static var manager: IWRequestManage = IWRequestManage()
    
    fileprivate var mRequestModels: [IWRequestManageModel] = []
}

fileprivate extension IWRequestManage {
    
    /// 添加请求
    func add(_ requestInfo: IWRequestInfo) {
        let model = findModel(withRequestInfo: requestInfo)
        if let md = model {
            if md.status != .failed {
                self.addRequestToManage(requestInfo)
                return
            }
        }
        self.addRequestToManage(requestInfo)
    }
    
    /// 请求错误
    func requestError(_ requestInfo: IWRequestInfo) {
        let model = findModel(withIdentity: requestInfo.identity)
        if let md = model {
            if md.status != .failed {
                // unfailed
                if md.attempts < 3 {
                    md.status = .error
                    md.attempts += 1
                    md.request?.retry()
                    return
                }
                // 尝试次数大于or等于三次时, 标记为失败
                md.status = .failed
            }
        }
    }
    
    /// 请求成功
    func requestSucceed(_ requestInfo: IWRequestInfo) {
        let model = findModel(withIdentity: requestInfo.identity)
        if let md = model {
            md.status = .succeed
        }
    }
    
}

fileprivate extension IWRequestManage {
    
    func addRequestToManage(_ requestInfo: IWRequestInfo) {
        let model = generateTheRequestModel(withRequestInfo: requestInfo, status: .none, attemps: 0)
        self.mRequestModels.append(model)
    }
    
    /// 通过请求信息查询管理模型
    func findModel(withRequestInfo requestInfo: IWRequestInfo) -> IWRequestManageModel? {
        if mRequestModels.count > 0 {
            for model in mRequestModels {
                if requestInfo.url.absoluteString == model.urlString {
                    if requestInfo.request?.urlRequest.httpBody == model.httpBody, requestInfo.urlParameters == model.parameters {
                        return model
                    }
                }
            }
        }
        return nil
    }
    
    /// 通过标志查询管理模型
    func findModel(withIdentity identity: String) -> IWRequestManageModel? {
        if mRequestModels.count > 0 {
            for model in mRequestModels {
                if model.identity == identity {
                    return model
                }
            }
        }
        return nil
    }
    
    /// 初始化一个管理模型
    func generateTheRequestModel(withRequestInfo requestInfo: IWRequestInfo, status: IWRequestManageModel.RequestStatus, attemps: Int) -> IWRequestManageModel {
        let model = IWRequestManageModel.manageModel
        model.setRequestInfo(withRequestInfo: requestInfo)
        model.status = status
        model.attempts = attemps
        return model
    }
}

extension IWRequestManage {
    
    final class func add(_ requestInfo: IWRequestInfo) {
        manager.add(requestInfo)
    }
    
    final class func requestError(_ requestInfo: IWRequestInfo) {
        manager.requestError(requestInfo)
    }
    
    final class func requestSucceed(_ requestInfo: IWRequestInfo) {
        manager.requestSucceed(requestInfo)
    }
    
    final class func requestManageModel(withRequestInfo requestInfo: IWRequestInfo) -> IWRequestManageModel? {
        return manager.findModel(withIdentity: requestInfo.identity)
    }
    
    final class func requestStatusIsFailed(withRequestInfo requestInfo: IWRequestInfo) -> Bool {
        let model = manager.findModel(withRequestInfo: requestInfo)
        if let md = model {
            if md.status == .failed {
                return true
            }
        }
        return false
    }
    
}
