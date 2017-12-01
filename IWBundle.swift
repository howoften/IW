//
//  IWBundle.swift
//  haoduobaduo
//
//  Created by iWe on 2017/9/28.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

class IWBundle: NSObject {
	
	static let shared: IWBundle = IWBundle()
	
	let bundleName = "IWBundle.bundle"
	var bundlePath: Bundle? {
		if let path = Bundle.main.resourcePath?.splicing(self.bundleName) {
			return Bundle(path: path)
		}
		return nil
	}
	
	func imagePath(_ name: String, _ ext: String = "png") -> String? {
		var tempName = name
		if !tempName.hasPrefix("iW") {
			tempName = "IWImage_" + tempName
		}
		return bundlePath?.path(forResource: tempName, ofType: ext)
	}
	
	func image(_ name: String, _ ext: String = "png") -> UIImage? {
		if let pt = imagePath(name, ext) {
			return UIImage(contentsOfFile: pt)
		}
		return nil
	}
	
	func filePath(_ name: String, _ ext: String) -> String? {
		return bundlePath?.path(forResource: name, ofType: ext)
	}
}
