//
//  IWNaverModel.swift
//  IWExtensionDemo
//
//  Created by iWw on 2018/4/14.
//  Copyright © 2018年 iWe. All rights reserved.
//

import UIKit

public class IWNaverInfo: NSObject {
    
    public enum NaverType {
        case points
        case tabbar
        case toRoot
        case unknow
    }
    
    /// (完整 URL).
    public var url: URL!
    /// (URL scheme).
    public var scheme: String!
    /// (URL host).
    public var host: String!
    /// (URL params 提交的参数).
    public var params: String?
    /// (URL 路径, 字符串数组).
    public var pathComponents: [String]!
    /// (URL 最后一个路径).
    public var lastPath: String!
    
    public var naverType: NaverType = .unknow
    
    /// (上一个 VC 类名).
    public var previousVC: String?
    /// (上一个 VC 的实例).
    public weak var previousVCInstance: UIViewController?
}
