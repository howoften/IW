//  Created by iWw on 23/01/2018.
//  Copyright © 2018 iWe. All rights reserved.
//

import UIKit

public extension UIPageControl {
    
    var minimumHeight: CGFloat {
        return size(forNumberOfPages: numberOfPages).height - 24
    }
    
    var minimumWidth: CGFloat {
        return size(forNumberOfPages: numberOfPages).width
    }
    
}
