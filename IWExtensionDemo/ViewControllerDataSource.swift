//
//  ViewControllerDataSource.swift
//  IWExtensionDemo
//
//  Created by iWw on 2018/5/24.
//  Copyright © 2018 iWe. All rights reserved.
//

import UIKit

class ViewControllerDataSource: NSObject {
    
    var viewModel: ViewControllerViewModel!
    
    init(_ vm: ViewControllerViewModel) {
        self.viewModel = vm
    }

}


extension ViewControllerDataSource: UITableViewDataSource  {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.reuseCell() as UpdateListCell
        
        let subItemModel = viewModel.subItemModel(with: indexPath)
        cell.setupInfo(with: subItemModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForHeader(in: section)
    }
    
}
