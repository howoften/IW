//  Created by iWe on 2017/7/3.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

class IWLoginNavController: IWNavController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navBackgroundColor = .white
        self.isHiddenShadowImage = true
        
        self.viewControllers = [IWLoginVC()]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
