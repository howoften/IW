//  Created by iWw on 23/01/2018.
//  Copyright © 2018 iWe. All rights reserved.
//

import UIKit

public extension UIPageControl {
    
    /// (最小高度).
    public var minimumHeight: CGFloat {
        return size(forNumberOfPages: numberOfPages).height - 24
    }
    
    /// (最小宽度).
    public var minimumWidth: CGFloat {
        return size(forNumberOfPages: numberOfPages).width
    }
    
}
