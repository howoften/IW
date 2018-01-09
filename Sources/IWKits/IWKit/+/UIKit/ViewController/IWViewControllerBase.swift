//
//  IWViewControllerBase.swift
//  haoduobaduo
//
//  Created by iWe on 2017/9/19.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

public final class IWViewController<ViewController> {
	public let vc: ViewController
	public init(_ viewController: ViewController) {
		self.vc =  viewController
	}
}

public protocol IWViewControllerCompatible {
	associatedtype IWE
	var iwe: IWE { get }
}

public extension IWViewControllerCompatible {
	public var iwe: IWViewController<Self> {
		return IWViewController(self)
	}
}

extension UIViewController: IWViewControllerCompatible { }
