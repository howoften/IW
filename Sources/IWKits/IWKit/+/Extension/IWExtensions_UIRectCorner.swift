//  Created by iWw on 2018/2/6.
//  Copyright © 2018年 iWe. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit

public extension UIRectCorner {
    
    /// (topLeft, topRight).
    public static var top: UIRectCorner {
        return [UIRectCorner.topLeft, UIRectCorner.topRight]
    }
    /// (topLeft, bottomLeft).
    public static var left: UIRectCorner {
        return [UIRectCorner.topLeft, UIRectCorner.bottomLeft]
    }
    /// (topRight, bottomRight).
    public static var right: UIRectCorner {
        return [UIRectCorner.topRight, UIRectCorner.bottomRight]
    }
    /// (bottomLeft, bottomRight).
    public static var bottom: UIRectCorner {
        return [UIRectCorner.bottomLeft, UIRectCorner.bottomRight]
    }
    
}

#endif
