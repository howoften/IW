//
//  IWLocalAuthentication.swift
//  haoduobaduo
//
//  Created by iWw on 2017/11/29.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit
import LocalAuthentication

public class IWLocalAuthentication: NSObject {
    
	enum AuthenticationResult: Int {
		
		case passed = 1         	   // 验证通过 / 成功
		case passedButInfoChanged = 11 // 验证通过 / 但是信息发生过变更(指纹(人脸)变更: 新增/删除)
		
		case failed = -1         // 验证失败
        case userCancel = -2     // 点击取消
        case userFallback = -3   // fallback, 识别出错时点击"输入密码"或"自定义"的按钮
		case systemCancel = -4	 // 系统取消
		
		case passcodeNotSet = -5 // 未设置密码
		case authenticationModuleNotAvailable = -6 	 // face id / touch id 不可用
		case authenticationModuleNotEnrolled = -7	 // face id / touch id 未注册
		case authenticationModuleLockout	= -8	 // face id / touch id 被锁定
		
		case appCancel = -9		 // app 取消
		
		case deviceNotSupoort = -99	 // 设备不支持
    }
	
	// SharedInstance
	static let shared: IWLocalAuthentication = IWLocalAuthentication()
	
	private var policy: LAPolicy {
		var po = LAPolicy.deviceOwnerAuthenticationWithBiometrics
		if #available(iOS 9.0, *) {
			po = LAPolicy.deviceOwnerAuthentication
		}
		return po
	}
	
	private var domainStateDataSavedPath: String {
		return IWSandbox.documents.splicing("iwe_local_authentication")
	}
	
	var laContext: LAContext {
		return LAContext.init()
	}
	
	var runningLaContext: LAContext?
	
	/// 旧的认证信息, 通过 initLocalAuthentication 进行初始化, 之后每次指纹认证成功都会刷新一遍
	var oldDomainState: Data?
	
	/// 是否支持本地认证
	private var isSupportLocalAuthentication: Bool {
		var errorPointer: NSError?
		return laContext.canEvaluatePolicy(policy, error: &errorPointer)
	}
	
	/// 初始化本地认证信息, 用于记录认证信息是否变更
	func initLocalAuthentication() -> Void {
		if !IWFileManage.default.fileExists(atPath: domainStateDataSavedPath) {
			var errorPointer: NSError?
			let ct = self.laContext
			if #available(iOS 9.0, *), ct.canEvaluatePolicy(policy, error: &errorPointer) {
				if let domainState = ct.evaluatedPolicyDomainState {
					oldDomainState = domainState
					self.saveDomainState(domainState)
				}
			}
		}
		
		do {
			let d = try Data.init(contentsOf: URL.init(fileURLWithPath: domainStateDataSavedPath), options: Data.ReadingOptions.alwaysMapped)
			oldDomainState = d
		} catch {
			iPrint(error: error)
		}
		
	}
	
	/// 本地认证功能
	///
	/// - Parameters:
	///   - tips: 认证失败后的按钮文字, 默认为: "输入密码"
	///   - localizedReason: 提示信息, 默认为: "认证识别"
	///   - handler: 认证结果
	func authentication(tips: String? = nil, localizedReason: String = "安全校验", _ handler: @escaping ((_ authResult: AuthenticationResult) -> Void)) -> Void {
		
		let context = self.laContext
		self.runningLaContext = context
        /**
         用来设置识别错误后的弹出框的按钮文字
         不设置默认文字为‘输入密码’
         设置为空(""), 将不会显示指纹错误后的弹出框
         */
		if let tip = tips {
			context.localizedFallbackTitle = tip
		}
		
		guard isSupportLocalAuthentication else {
			handler(.deviceNotSupoort)
			return
		}
		
        context.evaluatePolicy(policy, localizedReason: localizedReason) { (success, error) in
            if success {
				if self.isLocalAuthenticationChanged(withContext: context) {
					iPrint("The Local Authentication passed, But the info changed.")
					handler(.passedButInfoChanged)
					return
				}
				iPrint("The Local Authentication passed.")
                handler(.passed)
				return
            }
			iPrint("The Local Authentication has error", error: error)
			if let t = AuthenticationResult.init(rawValue: (error! as NSError).code) {
				handler(t)
				return
			}
			handler(.failed)
        }
    }
	
	/// 指纹变更后处理成功使用, 切记！
	func updateLocalAuthenticationInfos() -> Void {
		if #available(iOS 9.0, *), let context = runningLaContext {
			if let domainState = context.evaluatedPolicyDomainState {
				saveDomainState(domainState)
			}
		}
	}
	
	/// 本地认证信息是否变更, 需要 iOS9 及以上支持本地认证的设备
	private func isLocalAuthenticationChanged(withContext context: LAContext) -> Bool {
		guard #available(iOS 9.0, *) else { return false }
		guard let od = oldDomainState else { return false }
		if let domainState = context.evaluatedPolicyDomainState, domainState != od {
			return true
		}
		return false
	}
	
	/// 保存 DomainState 到本地
	private func saveDomainState(_ domainState: Data) -> Void {
		let filePathURL = URL.init(fileURLWithPath: domainStateDataSavedPath)
		do {
			try domainState.write(to: filePathURL)
			oldDomainState = domainState
			iPrint("The Domain State Info saved.")
		} catch {
			iPrint(error: error)
		}
	}
}
