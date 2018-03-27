//  Created by iWe on 2017/6/16.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

open class IWSubVC: IWRootVC {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11, *), self.largeTitleDisplayMode == .automatic {
            self.largeTitleDisplayMode = .never
        }
        // Do any additional setup after loading the view.
    }
    
    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

