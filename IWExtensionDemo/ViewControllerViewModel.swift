//
//  ViewControllerViewModel.swift
//  IWExtensionDemo
//
//  Created by iWw on 2018/5/24.
//  Copyright © 2018 iWe. All rights reserved.
//

import UIKit

class ViewControllerViewModel: NSObject {
    
    var _model: ViewControllerModel!
    var plist: [[String: Any]]!
    override init() {
        super.init()
        
        iw.queue.main {
            guard let p = Bundle.main.path(forResource: "UpdateLists", ofType: "plist") else { fatalError("error") }
            if let pp = NSArray.init(contentsOfFile: p) {
                self.plist = pp as! [[String: Any]]
            }
            self._model = ViewControllerModel(self.plist)
        }
    }
    
    var numberOfSections: Int {
        return _model.itemModel.unwrapCount
    }
    
    func numberOfRows(in section: Int) -> Int {
        return _model.itemModel![section].list.unwrapCount
    }
    
    func subItemModel(with indexPath: IndexPath) -> SubItemModel {
        return _model.itemModel![indexPath.section].list![indexPath.row]
    }
    
    func titleForHeader(in section: Int) -> String? {
        return _model.itemModel![section].tit
    }
}
