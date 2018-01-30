//  Created by iWw on 26/01/2018.
//  Copyright © 2018 iWe. All rights reserved.
//

import UIKit

open class IWTabBarController: UITabBarController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

public extension IWTabBarController {
    
    public func hideLine() -> Void {
        
        // 隐藏线
        self.tabBar.shadowImage = UIImage()
        // 隐藏背景, 若不隐藏背景则无法隐藏线
        self.tabBar.backgroundImage = UIImage()
        
        // 还原背景
        likeOrignalVisualEffectView.unwrapped ({ (ev) in
            self.tabBar.subviews[safe: 0]?.addSubview(ev)
        })
    }
    
}

