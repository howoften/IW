//  Created by iWe on 2017/9/20.
//  Copyright © 2017年 iWe. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit


// MARK: 属性
public extension UIButton {
    
    /// Set fontSize with systemFont.
    /// (字体大小).
    public var fontSize: Float {
        get { return Float(titleLabel?.font.pointSize ?? 17.0)  }
        set { titleLabel?.font = .systemFont(ofSize: CGFloat(newValue)) }
    }
    
    /// Set title for normal.
    /// (normal状态下的标题).
    public var title: String? {
        get { return titleLabel?.text }
        set { setTitle(newValue, for: .normal) }
    }
    
    /// Set titleColor for normal.
    /// (normal状态下的字体颜色).
    public var titleColor: UIColor? {
        get { return currentTitleColor }
        set { setTitleColor(newValue, for: .normal) }
    }
    
    /// Set titleLabel alignment.
    /// (字体对齐方式).
    public var titleAlignment: NSTextAlignment {
        get { return titleLabel?.textAlignment ?? .left }
        set { titleLabel?.textAlignment = newValue }
    }
}

// MARK: 方法
public extension UIButton {
    
    /// (配置).
    public func config(_ configurationHandler: (_ sender: UIButton) -> Void) -> Void {
        configurationHandler(self)
    }
    
    /// (设置对应状态的字体颜色).
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - state: 状态
    public func titleColor(_ color: UIColor?, _ state: UIControlState = .normal) -> Void {
        setTitleColor(color, for: state)
    }
    
    /// (文本和图片居中显示).
    public func centerTextAndImage(spacing: CGFloat) -> Void {
        let insetAmount = spacing / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
    
}
#endif
