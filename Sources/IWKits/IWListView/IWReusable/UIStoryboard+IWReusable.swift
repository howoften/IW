//  Created by iWe on 2017/9/6.
//  Copyright © 2017年 iWe. All rights reserved.
//

#if os(iOS)
import UIKit

public protocol IWStoryboardSceneBased: class {
    /// The UIStoryboard to use when we want to instantiate this ViewController.
    static var sceneStoryboard: UIStoryboard { get }
    /// The scene identifier to use when we want to instantiate this ViewController from its associated Storyboard.
    static var sceneIdentifier: String { get }
}

public extension IWStoryboardSceneBased {
    static var sceneIdentifier: String {
        return String(describing: self)
    }
    static var sceneStoryboard: UIStoryboard {
        return UIStoryboard(name: String(describing: self), bundle: Bundle(for: self))
    }
}

extension UIViewController: IWStoryboardSceneBased { }

public extension IWStoryboardSceneBased where Self: UIViewController {
    /// Use sceneIdentifier initial ViewController.
    /// (使用 sceneIdentifier 初始化控制器).
    static func instantiateWithIdentifier() -> Self {
        let storyboard = Self.sceneStoryboard
        guard let vc = storyboard.instantiateViewController(withIdentifier: self.sceneIdentifier) as? Self else {
            fatalError("The viewController '\(self.sceneIdentifier)' of '\(storyboard)' is not of class '\(self)'")
        }
        return vc
    }
    /// Initial ViewController
    /// (通过 故事版 初始化控制器).
    static func instantiate() -> Self {
        guard let vc = sceneStoryboard.instantiateInitialViewController() as? Self else {
            fatalError("The initialViewController of '\(sceneStoryboard)' is not of class '\(self)'")
        }
        return vc
    }
}

#endif
