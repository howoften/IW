//
//  UpdateListCell.swift
//  IWExtensionDemo
//
//  Created by iWw on 22/01/2018.
//  Copyright © 2018 iWe. All rights reserved.
//

import UIKit

class UpdateListCell: UITableViewCell {
    
    @IBOutlet weak var titLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        subLabel.numberOfLines = 0
    }
    
    func setupInfo(with model: SubItemModel) -> Void {
        titLabel.text = model.tit
        subLabel.text = model.sub
        if model.acid.isSome {
            self.accessoryType = .disclosureIndicator
        } else {
            self.accessoryType = .none
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
