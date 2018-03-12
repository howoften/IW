//  Created by iWw on 26/01/2018.
//  Copyright © 2018 iWe. All rights reserved.
//

import UIKit

open class IWTabBarController: UITabBarController {
    
    /// (与原始背景相似的 effect view).
    private lazy var likeOrignalVisualEffectView: UIVisualEffectView? = {
        let effectView = UIVisualEffectView(effect: UIBlurEffect.init(style: .light))
        effectView.frame = MakeRect(0, 0, .screenWidth, .tabbarHeight)
        return effectView
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        _init()
    }
    
    private func _init() {
        // 不透明 tabBar
        self.tabBar.isTranslucent = false
    }
    
    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

public extension IWTabBarController {
    
    /// (隐藏 tabbar 上划线).
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

