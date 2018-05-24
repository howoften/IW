//  Created by iWw on 23/01/2018.
//  Copyright © 2018 iWe. All rights reserved.
//

import UIKit

public extension CGRect {
    
    /// (屏幕大小, scrren bounds).
    public static let screenBounds: CGRect = { return iw.screen.bounds }()
    
    /// (.origin.x).
    public var x: CGFloat {
        get { return self.origin.x }
        set { self.origin.x = newValue }
    }
    /// (.origin.y).
    public var y: CGFloat {
        get { return self.origin.y }
        set { self.origin.y = newValue }
    }
    /// (.size.width).
    public var width: CGFloat {
        get { return self.size.width }
        set { self.size.width = newValue }
    }
    /// (size.height).
    public var height: CGFloat {
        get { return self.size.height }
        set { self.size.height = newValue }
    }
}
