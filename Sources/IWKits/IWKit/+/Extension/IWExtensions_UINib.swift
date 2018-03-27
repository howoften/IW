//  Created by iWw on 23/01/2018.
//  Copyright © 2018 iWe. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit

private var kUINib_nibNameKey: Void?
private var kUINib_nibBundleKey: Void?
public extension UINib {
    
    @IBInspectable public var nibName: String {
        get { return objc_getAssociatedObject(self, &kUINib_nibNameKey) as! String }
        set { objc_setAssociatedObject(self, &kUINib_nibNameKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }
    
    @IBInspectable public var bundle: Bundle? {
        get { return objc_getAssociatedObject(self, &kUINib_nibBundleKey) as? Bundle }
        set { objc_setAssociatedObject(self, &kUINib_nibBundleKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    /// Initializes a UINIB with a name and bundle.
    public convenience init(withName name: String, bundle: Bundle?) {
        let fixName = name.components(separatedBy: ".").last!
        self.init(nibName: fixName, bundle: bundle)
        self.nibName = fixName
        self.bundle = bundle
    }
    
    public func navigationShouldPopOnBackButton() -> Bool {
        return true
    }
}
#endif
