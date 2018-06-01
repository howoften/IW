//
//  ViewControllerDataSource.swift
//  IWExtensionDemo
//
//  Created by iWw on 2018/5/24.
//  Copyright © 2018 iWe. All rights reserved.
//

import UIKit

class ViewControllerDataSource: IWListViewMoreSectionDataSource {
    
    private var _viewModel: ViewControllerViewModel? {
        return _baseViewModel as? ViewControllerViewModel
    }
    
    override func _cell(forRowAt indexPath: IndexPath, with tableView: UITableView) -> UITableViewCell {
        let cell = tableView.reuseCell() as UpdateListCell
        
        if let cellModel = _baseViewModel.cellModel(with: indexPath) as? SubItemModel {
            cell.setupInfo(with: cellModel)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return _viewModel?.titleForHeader(in: section)
    }
}
