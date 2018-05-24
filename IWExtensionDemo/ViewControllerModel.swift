//
//  ViewControllerModel.swift
//  IWExtensionDemo
//
//  Created by iWw on 2018/5/24.
//  Copyright © 2018 iWe. All rights reserved.
//

import UIKit

class ViewControllerModel: NSObject {
    
    var itemModel: [ItemModel]?
    
    init(_ plist: [[String: Any]]) {
        super.init()
        
        var im: [ItemModel] = []
        
        for i in plist {
            
            let _im = ItemModel()
            var sim: [SubItemModel] = []
            
            _im.tit = i["tit"] as? String
            for n in i["list"] as! [[String: String]] {
                let _sim = SubItemModel()
                _sim.tit = n["tit"]
                _sim.sub = n["sub"]
                _sim.acid = n[safe: "acid"]
                sim.append(_sim)
            }
            _im.list = sim
            im.append(_im)
        }
        itemModel = im
    }
}

class ItemModel: NSObject {
    var tit: String?
    var list: [SubItemModel]?
}


class SubItemModel: NSObject {
    var tit: String?
    var sub: String?
    var acid: String?
}
