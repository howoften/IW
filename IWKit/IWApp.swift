//
//  IWApp.swift
//  haoduobaduo
//
//  Created by iWe on 2017/9/20.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

class IWApp: NSObject {
	
	/// App version
	private static let ShortVersionKey = "CFBundleShortVersionString"
	/// App build version
	private static let BuildKey = "CFBundleVersion"
	/// App name
	private static let DisplayNameKey = "CFBundleDisplayName"
	
	private static var infoDictionary: [String: Any]? {
		return Bundle.main.infoDictionary
	}
	
	/// Version 关键词被OC占用 = =
	static var shortVersion: String? {
		return infoDictionary?[ShortVersionKey] as? String
	}
	
	/// Build 编译号
	static var build: String? {
		return infoDictionary?[BuildKey] as? String
	}
	
	/// App 名称
	static var name: String? {
		return infoDictionary?[DisplayNameKey] as? String
	}
	
}
