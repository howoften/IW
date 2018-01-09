//
//  IWBundle.swift
//  haoduobaduo
//
//  Created by iWe on 2017/9/28.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

public class IWBundle: NSObject {
	
	public static let shared: IWBundle = IWBundle()
	
    public let bundleName = "IWBundle.bundle"
	public var bundlePath: Bundle? {
		if let path = Bundle.main.resourcePath?.splicing(self.bundleName) {
			return Bundle(path: path)
		}
		return nil
	}
	
    public final func imagePath(_ name: String, _ ext: String = "png") -> String? {
		var tempName = name
		if !tempName.hasPrefix("iW") {
			tempName = "IWImage_" + tempName
		}
		return bundlePath?.path(forResource: tempName, ofType: ext)
	}
	
	public final func image(_ name: String, _ ext: String = "png") -> UIImage? {
		if name.contains("@") {
			if let pt = imagePath(name, ext) {
				return UIImage(contentsOfFile: pt)
			}
		}
		var n = ""
		let scale = UIScreen.main.scale
		if scale <= 2 {
			n = "\(name)@2x"
		} else {
			n = "\(name)@3x"
		}
		if let pt = imagePath(n, ext) {
			return UIImage(contentsOfFile: pt)
		}
		return nil
	}
	
	public final func filePath(_ name: String, _ ext: String) -> String? {
		return bundlePath?.path(forResource: name, ofType: ext)
	}
}
