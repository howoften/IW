//  Created by iWe on 2017/10/27.
//  Copyright © 2017年 iWe. All rights reserved.
//

/**
 time: 2017.10/27 at 11:48
 note: 输出日志配置
 Created by iwe. */

import UIKit

public final class IWLogConfiguration: NSObject {
	
	// 完全输出实例：
	// *** 1007236164 (IWKit.swift -> config -> 21):
    // info
	// ---
	// ***开始 ---结束
	// 1007236164 输出时间戳
	// IWKit.swift 文件名称
	// [config: 21] config 函数名称, 21所在行数
	// info 提示的信息
	
	public static let shared = IWLogConfiguration()
	
	/// 输出时间
	public var isOutputTime: Bool = true
	
	/// 输出文件名称
	public var isOutputFileName: Bool = true
	
	/// 输出方法名
	public var isOutputFunctionName: Bool = true
	
	/// 输出行数
	public var isOutputLine: Bool = true
	
	/// 保存至本地
    public var isSaveToLocal: Bool = false {
        didSet {
            if isSaveToLocal {
                // 开启日志记录
                enableRecordLog()
            }
        }
    }
    
    private func enableRecordLog() -> Void {
        let logPath = "\(IWSandbox.temp)".splicing("\(IWTime.current("YYYY/MM/dd/HH:mm:ss")).log")
        recordLogPath = logPath
        
        let isCreate = IWFileManage.default.createFile(atPath: logPath, contents: nil, attributes: nil)
        if isCreate {
            iPrint("The Record log path: \(logPath)")
        } else {
            iPrint("Record log creat failed.")
        }
    }
    
    /// 开启保存至本地后使用该路径
    public var recordLogPath: String!
    
    /// 开启保存至本地后使用该路径
    public var recordDocumentPath: String {
        return "\(IWSandbox.temp)"
    }
}
