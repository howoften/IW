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
    
    func config(_ info: [String: String]) -> Void {
        titLabel.text = info["tit"]
        subLabel.text = info["sub"]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
