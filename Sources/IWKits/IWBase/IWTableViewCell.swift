//
//  IWTableViewCell.swift
//  IWExtensionDemo
//
//  Created by iWw on 2018/2/1.
//  Copyright © 2018年 iWe. All rights reserved.
//

import UIKit

class IWTableViewCell: UITableViewCell {
    
    var didSelect: ((_ tableView: UITableView, _ indexPath: IndexPath) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
