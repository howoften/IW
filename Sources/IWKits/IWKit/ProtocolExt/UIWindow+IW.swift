//  Created by iWe on 2017/9/28.
//  Copyright © 2017年 iWe. All rights reserved.
//

#if os(iOS)
import UIKit

public extension UIWindow {
    
    public func show() -> Void {
        self.isHidden = false
        
        if #available(iOS 11, *) {
            for wd in UIApplication.shared.windows {
                if wd.isKind(of: NSClassFromString("_UIInteractiveHighlightEffectWindow")!) {
                    wd.isHidden = true
                }
            }
        }
    }
}
#endif
