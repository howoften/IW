//  Created by iWw on 2018/3/18.
//  Copyright © 2018年 iWe. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit

extension UIViewController {
    
    /// (从 xib 初始化 UIViewController).
    ///
    ///     xib 内容为 UIView;
    ///     File's Owner 为 UIViewController 的类, 然后将其 view 关联至 xib的view中即可
    static func initFromXib<T: UIViewController>(xibName: String? = nil) -> T {
        let name = xibName ?? "\(self)"
        return self.init(nibName: "\(name)", bundle: Bundle.main) as! T
    }
    
}
#endif
