//  Created by iWw on 2017/12/2.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

public final class IWColor<Color> {
    /// (自身).
    public let color: Color
    public init(_ color: Color) {
        self.color =  color
    }
}

public protocol IWColorCompatible {
    associatedtype IWE
    var iwe: IWE { get }
}

public extension IWColorCompatible {
    public var iwe: IWColor<Self> {
        get { return IWColor(self) }
    }
}

extension UIColor: IWColorCompatible { }

public extension IWColor where Color: UIColor {
    
    /// (返回一个随机颜色).
    static var randomColor: UIColor {
        let red = CGFloat(arc4random() % 255) / 255.0
        let gre = CGFloat(arc4random() % 255) / 255.0
        let blu = CGFloat(arc4random() % 255) / 255.0
        return UIColor(red: red, green: gre, blue: blu, alpha: 1.0)
    }
    
    /// (返回当前颜色的反色).
    final var inverseColor: UIColor? {
        guard let componentColors = self.color.cgColor.components else { return nil }
        let newColor = UIColor.init(red: 1.0 - componentColors[0], green: 1.0 - componentColors[1], blue: 1.0 - componentColors[3], alpha: componentColors[3])
        return newColor
    }
    
    /// (是否为暗色).
    final var isDark: Bool {
        var red: CGFloat = 0.0, gre: CGFloat = 0.0, blu: CGFloat = 0.0, alpha: CGFloat = 0.0
        self.color.getRed(&red, green: &gre, blue: &blu, alpha: &alpha)
        let referenceValue: CGFloat = 0.411
        let colorDelta = (red * 0.299) + (gre * 0.587) + (blu * 0.114)
        return (1.0 - colorDelta) > referenceValue
    }
    
    /// (返回当前颜色16进制代码, 通道排序为 RGBA).
    final var hex: String {
        let a = self.alpha, r = self.red, g = self.green, b = self.blue
        let hexA = self.alignColor(hexString: String.hexString(withInteger: NSInteger(a)))
        let hexR = self.alignColor(hexString: String.hexString(withInteger: NSInteger(r)))
        let hexG = self.alignColor(hexString: String.hexString(withInteger: NSInteger(g)))
        let hexB = self.alignColor(hexString: String.hexString(withInteger: NSInteger(b)))
        return "#\(hexR)\(hexG)\(hexB)\(hexA)"
    }
    /// (补齐单色值, 例如 "F" 会补齐为 "0F").
    private func alignColor(hexString: String) -> String {
        return hexString.count < 2 ? "0\(hexString)" : hexString
    }
    
    /// (返回去除 透明 通道后的颜色).
    final var colorWithoutAlpha: UIColor? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        if self.color.getRed(&r, green: &g, blue: &b, alpha: nil) {
            return UIColor.init(red: r, green: g, blue: b, alpha: 1.0)
        }
        return nil
    }
    
    /// (返回当前颜色 红色 通道的值).
    final var red: CGFloat {
        var r: CGFloat = 0
        if self.color.getRed(&r, green: nil, blue: nil, alpha: nil) {
            return r
        }
        return 0
    }
    
    /// (返回当前颜色 绿色 通道的值).
    final var green: CGFloat {
        var g: CGFloat = 0
        if self.color.getRed(nil, green: &g, blue: nil, alpha: nil) {
            return g
        }
        return 0
    }
    
    /// (返回当前颜色 蓝色 通道的值).
    final var blue: CGFloat {
        var b: CGFloat = 0
        if self.color.getRed(nil, green: nil, blue: &b, alpha: nil) {
            return b
        }
        return 0
    }
    
    /// (返回当前颜色 透明 通道的值).
    final var alpha: CGFloat {
        var a: CGFloat = 0
        if self.color.getRed(nil, green: nil, blue: nil, alpha: &a) {
            return a
        }
        return 0
    }
    
    /// (返回当前颜色 hue 通道的值).
    final var hue: CGFloat {
        var h: CGFloat = 0
        if self.color.getHue(&h, saturation: nil, brightness: nil, alpha: nil) {
            return h
        }
        return 0
    }
    /// (返回当前颜色 saturation 通道的值).
    final var saturation: CGFloat {
        var s: CGFloat = 0
        if self.color.getHue(nil, saturation: &s, brightness: nil, alpha: nil) {
            return s
        }
        return 0
    }
    
    /// (返回当前颜色 brightness 通道的值).
    final var brightness: CGFloat {
        var b: CGFloat = 0
        if self.color.getHue(nil, saturation: nil, brightness: &b, alpha: nil) {
            return b
        }
        return 0
    }
    
    /// (返回一张 4x4 的纯色图片).
    final var image: UIImage? {
        return self.image(withColor: self.color, cornerRadius: 0)
    }
    
    /// (返回一张自定义的纯色图片).
    ///
    /// - Parameters:
    ///   - color: 图片颜色
    ///   - size: 图片大小, 默认为 4x4
    ///   - cornerRadius: 图片圆角
    /// - Returns: 图片, 可能为nil
    final func image(withColor color: UIColor?, size: CGSize = MakeSize(4, 4), cornerRadius: CGFloat) -> UIImage? {
        func removeFloatMin(_ floatValue: CGFloat) -> CGFloat {
            return floatValue == CGFloat.min ? 0 : floatValue
        }
        func flatSpecificScale(_ floatValue: CGFloat, _ scale: CGFloat) -> CGFloat {
            let fv = removeFloatMin(floatValue)
            let sc = (scale == 0 ? UIScreen.main.scale : scale)
            let flattedValue = ceil(fv * sc) / sc
            return flattedValue
        }
        func flat(_ floatValue: CGFloat) -> CGFloat {
            return flatSpecificScale(floatValue, 0)
        }
        let sz = MakeSize(flat(size.width), flat(size.height))
        if sz.width < 0 || sz.height < 0 { assertionFailure("CGPostError, 非法的 size") }
        
        var resultImage: UIImage? = nil
        let co = (color != nil ? color! : UIColor.clear)
        
        let opaque = (cornerRadius == 0.0 && co.iwe.alpha == 1.0)
        UIGraphicsBeginImageContextWithOptions(sz, opaque, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            assertionFailure("非法 context.")
            return nil
        }
        context.setFillColor(co.cgColor)
        
        if cornerRadius > 0 {
            let path = UIBezierPath.init(roundedRect: sz.iwe.rect, cornerRadius: cornerRadius)
            path.addClip()
            path.fill()
        } else {
            context.fill(sz.iwe.rect)
        }
        
        resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage
    }
}

