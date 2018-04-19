//
//  IWJSON.swift
//  IWExtensionDemo
//
//  Created by iWw on 2018/4/8.
//  Copyright © 2018年 iWe. All rights reserved.
//

import UIKit

public class IWJSON: NSObject {
    
    private var jsonData: Data!
    
    public var data: Data! {
        return jsonData
    }
    public var json: String! {
        return String.init(data: jsonData, encoding: .utf8)
    }
    
    public convenience init(withData data: Data) {
        self.init()
        self.jsonData = data
    }
    
    public convenience init(withJSON json: String, encoding: String.Encoding = .utf8) {
        self.init()
        
        guard let dataForJSON = json.data(using: encoding) else {
            fatalError("Convert to Data failed.")
        }
        self.jsonData = dataForJSON
    }
    
    public func decodeTo<T>(_ type: T.Type) -> T where T: Decodable {
        do {
            let tModel = try JSONDecoder().decode(type, from: jsonData)
            return tModel
        } catch {
            iPrint(error: error)
        }
        fatalError("The decode failed.")
    }
    
    public func decode<T: Decodable>(_ decodeType: T.Type = T.self) -> T {
        do {
            let tModel = try JSONDecoder().decode(decodeType, from: jsonData)
            return tModel
        } catch {
            iPrint(error: error)
        }
        fatalError("The decode failed.")
    }
    
}
