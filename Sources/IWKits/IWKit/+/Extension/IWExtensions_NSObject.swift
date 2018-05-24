//
//  IWExtensions_NSObject.swift
//  IWExtensionDemo
//
//  Created by iWw on 2018/5/24.
//  Copyright © 2018 iWe. All rights reserved.
//

import UIKit

extension NSObject {
    
    var currentViewController: UIViewController? {
        return UIViewController.IWE.current()
    }
    
}
