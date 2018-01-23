//  Created by iWe on 2017/8/15.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

public final class IWView<View> {
    public let view: View
    public init(_ view: View) {
        self.view =  view
    }
}

public protocol IWViewCompatible {
    associatedtype IWE
    var iwe: IWE { get }
}

public extension IWViewCompatible {
    public var iwe: IWView<Self> {
        get { return IWView(self) }
    }
}

extension UIView: IWViewCompatible { }
