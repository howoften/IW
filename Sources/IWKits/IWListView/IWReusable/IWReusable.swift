//  Created by iWe on 2017/7/24.
//  Copyright © 2017年 iWe. All rights reserved.
//

/*********************************************
 *
 * The inspiration for these codes is under the MIT License (MIT)
 *
 * Copyright (c) 2016 AliSoftware
 *
 * The homepage: https://github.com/AliSoftware/Reusable
 *
 *********************************************/

#if os(iOS)
import UIKit

public protocol IWReusable: class {
    static var identifier: String { get }
}

public extension IWReusable {
    static var identifier: String {
        return String(describing: self)
    }
}

public typealias IWNibReusable = IWReusable & IWNibLoadable
#endif
