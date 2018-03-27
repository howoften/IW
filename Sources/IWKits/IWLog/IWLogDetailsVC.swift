//  Created by iWw on 2018/3/18.
//  Copyright © 2018年 iWe. All rights reserved.
//

import UIKit

public class IWLogDetailsVC: IWSubVC {

    var txtView: UITextView = UITextView()
    
    var filePath: String?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        initUserInterface()
    }
    
    override public func initUserInterface() {
        title = "Output Details"
        
        txtView.isEditable = false
        
        txtView.iwe.addTo(view: self.view, setToViewBounds: true)
        
        txtView.text = filePath?.iwe.loadFileContents ?? "无数据"
        txtView.font = UIFont.systemFont(ofSize: 10)
        txtView.alwaysBounceVertical.enable()
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
