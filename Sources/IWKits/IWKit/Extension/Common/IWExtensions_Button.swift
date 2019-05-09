//  Created by iWw on 2018/7/28.
//  Copyright © 2018 iWe. All rights reserved.
//

#if os(macOS)
    import Cocoa
    public typealias IWButton = NSButton
#else
    import UIKit
    public typealias IWButton = UIButton
#endif


public extension IWButton {
    
    /// (配置).
    func config(_ configurationHandler: (_ sender: IWButton) -> Void) -> Void {
        configurationHandler(self)
    }
    
}


#if os(macOS)

// MARK:- macOS Function
public extension IWButton {
    
    /// (设置标题颜色).
    func setTitleColor(_ color: NSColor) -> Void {
        let attrTitle = NSMutableAttributedString.init(attributedString: self.attributedTitle)
        let len = attrTitle.length
        let range = NSMakeRange(0, len)
        attrTitle.addAttributes([NSAttributedStringKey.foregroundColor : color], range: range)
        attrTitle.fixAttributes(in: range)
        self.attributedTitle = attrTitle
        // self.setNeedsDisplay()
    }
    
}
#else

// MARK:- unmacOS Variable
public extension IWButton {
    
    /// Set fontSize with systemFont.
    /// (字体大小).
    var fontSize: Float {
        get { return Float(titleLabel?.font.pointSize ?? 17.0)  }
        set { titleLabel?.font = .systemFont(ofSize: CGFloat(newValue)) }
    }
    
    /// Set title for normal.
    /// (normal状态下的标题).
    var title: String? {
        get { return titleLabel?.text }
        set { setTitle(newValue, for: .normal) }
    }
    
    /// Set titleColor for normal.
    /// (normal状态下的字体颜色).
    var titleColor: UIColor? {
        get { return currentTitleColor }
        set { setTitleColor(newValue, for: .normal) }
    }
    
    /// Set titleLabel alignment.
    /// (字体对齐方式).
    var titleAlignment: NSTextAlignment {
        get { return titleLabel?.textAlignment ?? .left }
        set { titleLabel?.textAlignment = newValue }
    }
}

// MARK:- unmacOS Function
public extension IWButton {
    
    /// (设置对应状态的字体颜色).
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - state: 状态
    func titleColor(_ color: IWColor?, _ state: UIControlState = .normal) -> Void {
        setTitleColor(color, for: state)
    }
    
    /// (文本和图片居中显示).
    func centerTextAndImage(spacing: CGFloat) -> Void {
        let insetAmount = spacing / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
    
}

#endif
