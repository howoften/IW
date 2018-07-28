//  Created by iWw on 2018/2/26.
//  Copyright © 2018年 iWe. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit


public extension UILabel {
    
    public convenience init(text: String?) {
        self.init()
        self.text = text
    }
    
    /// (配置).
    public func config(_ configurationHandler: (_ sender: UILabel) -> Void) -> Void {
        configurationHandler(self)
    }
    
    /// (将目标UILabel的样式属性设置到当前UILabel上).
    /// (将会复制的样式属性包括：font、textColor、backgroundColor、lineBreakMode、textAlignment).
    ///
    /// - Parameter as: 要从哪个目标UILabel上复制样式
    public func same(as label: UILabel) -> Void {
        self.font = label.font
        self.textColor = label.textColor
        self.lineBreakMode = label.lineBreakMode
        self.textAlignment = label.textAlignment
        self.backgroundColor = label.backgroundColor
    }
    
}
#endif
