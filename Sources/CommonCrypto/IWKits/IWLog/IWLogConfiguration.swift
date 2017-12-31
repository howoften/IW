//
//  IWLogConfiguration.swift
//  haoduobaduo
//
//  Created by iWe on 2017/10/27.
//  Copyright © 2017年 iWe. All rights reserved.
//

/**
 time: 2017.10/27 at 11:48
 note: 输出日志配置
 Created by iwe. */

import UIKit

class IWLogConfiguration: NSObject {
	
	// 完全输出实例：
	// *** 1007236164 (IWKit.swift -> config -> 21):
    // info
	// ---
	// ***开始 ---结束
	// 1007236164 输出时间戳
	// IWKit.swift 文件名称
	// [config: 21] config 函数名称, 21所在行数
	// info 提示的信息
	
	static let shared = IWLogConfiguration()
	
	// 输出时间
	var isOutputTime: Bool = true
	
	// 输出文件名称
	var isOutputFileName: Bool = true
	
	// 输出方法名
	var isOutputFunctionName: Bool = true
	
	// 输出行数
	var isOutputLine: Bool = true
	
	// 保存至本地
    var isSaveToLocal: Bool = false {
        didSet {
            if isSaveToLocal {
                // 开启日志记录
                enableRecordLog()
            }
        }
    }
    
    private func enableRecordLog() -> Void {
        let logPath = "\(IWSandbox.temp)".splicing("\(IWTime.current("YYYY-MM-dd_HH-mm-ss")).log")
        recordLogPath = logPath
        
        let isCreate = IWFileManage.default.createFile(atPath: logPath, contents: nil, attributes: nil)
        if isCreate {
            iPrint("The Record log path: \(logPath)")
        } else {
            iPrint("Record log creat failed.")
        }
    }
    
    var recordLogPath: String!
    
    var recordDocumentPath: String {
        return "\(IWSandbox.temp)"
    }
}
