//
//  IWExtensions_URLRequest.swift
//  IWExtensionDemo
//
//  Created by iWw on 2018/3/14.
//  Copyright © 2018年 iWe. All rights reserved.
//

import Foundation

public extension URLRequest {
    
    public init?(urlString: String) {
        guard let url = URL(string: urlString) else { return nil }
        self.init(url: url)
    }
    
}
