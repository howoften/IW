//  Created by iWw on 2018/3/18.
//  Copyright © 2018年 iWe. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit

public protocol _IWViewControllerExtension: class {
    static var className: String { get }
}

public extension _IWViewControllerExtension {
    static var className: String {
        return "\(self)"
    }
}

extension UIViewController: _IWViewControllerExtension { }

public extension _IWViewControllerExtension where Self: UIViewController {
    
    /// (从 xib 初始化 UIViewController).
    ///
    ///     xib 内容为 UIView;
    ///     File's Owner 为 UIViewController 的类, 然后将其 view 关联至 xib的view中即可
    public static func initFromXib(xibName: String? = nil) -> Self {
        let name = xibName ?? "\(self)"
        let ret = self.init(nibName: "\(name)", bundle: Bundle.main)
        return ret
    }
}

#endif
