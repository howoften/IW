//
//  ViewControllerViewModel.swift
//  IWExtensionDemo
//
//  Created by iWw on 2018/5/24.
//  Copyright © 2018 iWe. All rights reserved.
//

import UIKit

class ViewControllerViewModel: IWViewModel {
    
    private var tableView: UITableView!
    
    var _model: ViewControllerModel!
    var plist: [[String: Any]]!
    override init() {
        super.init()
        
        guard let p = Bundle.main.path(forResource: "UpdateLists", ofType: "plist") else { fatalError("error") }
        if let pp = NSArray.init(contentsOfFile: p) {
            self.plist = pp as! [[String: Any]]
        }
        self._model = ViewControllerModel(self.plist)
    }
    
    
    override var numberOfSections: Int {
        return _model.itemModel.unwrapCount
    }
    
    override func numberOfRows(in section: Int) -> Int {
        return _model.itemModel![section].list.unwrapCount
    }
    override func cellModel<T>(with indexPath: IndexPath) -> T? where T : NSObject {
        return _model.itemModel![indexPath.section].list![indexPath.row] as? T
    }
    
    func titleForHeader(in section: Int) -> String? {
        return _model.itemModel![section].tit
    }
    
    func bind(_ tableView: UITableView, delegate: UITableViewDelegate?, dataSource: UITableViewDataSource?) -> Void {
        self.tableView = tableView
        tableView.delegate = delegate
        tableView.dataSource = dataSource
    }
}
