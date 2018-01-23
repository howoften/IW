//  Created by iWw on 23/01/2018.
//  Copyright © 2018 iWe. All rights reserved.
//

import UIKit

public extension CGSize {
    
    /// (是否为空, width<=0 or height<=0 则为空).
    static func isEmpty(_ size: CGSize) -> Bool {
        return size.width <= 0 || size.height <= 0
    }
    
}
