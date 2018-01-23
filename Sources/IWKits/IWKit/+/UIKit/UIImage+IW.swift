//  Created by iWw on 2017/12/3.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

public final class IWImage<Image> {
    /// (自身).
    public let img: Image
    public init(_ img: Image) {
        self.img =  img
    }
}

public protocol IWImageCompatible {
    associatedtype IWE
    var iwe: IWE { get }
}

public extension IWImageCompatible {
    public var iwe: IWImage<Self> {
        get { return IWImage(self) }
    }
}

extension UIImage: IWImageCompatible { }

public extension IWImage where Image: UIImage {
    
    /// (获取图片均色, 原理：将图片压缩至 1x1, 然后取色值, 如果获取的颜色比较淡, 可使用 iwe.colorWithoutAlpha 转换).
    final var averageColor: UIColor? {
        let data = UnsafeMutableRawPointer.allocate(bytes: 4, alignedTo: 1) // unsigned char = 4 bytes
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext.init(data: data, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue) else {
            assertionFailure("非法 context.")
            return nil
        }
        context.draw(self.img.cgImage!, in: MakeRect(0, 0, 1, 1))
        let rgba = Array(UnsafeBufferPointer(start: data.assumingMemoryBound(to: UInt8.self), count: 4))
        if rgba[3] > 0 {
            let r = CGFloat(rgba[0]) / CGFloat(rgba[3])
            let g = CGFloat(rgba[1]) / CGFloat(rgba[3])
            let b = CGFloat(rgba[2]) / CGFloat(rgba[3])
            let a = CGFloat(rgba[3]) / 255
            return UIColor.init(red: r, green: g, blue: b, alpha: a)
        }
        let r = CGFloat(rgba[0]) / 255
        let g = CGFloat(rgba[1]) / 255
        let b = CGFloat(rgba[2]) / 255
        let a = CGFloat(rgba[3]) / 255
        return UIColor.init(red: r, green: g, blue: b, alpha: a)
    }
    
    /// (将图片置灰色).
    final var grayImage: UIImage? {
        let width = self.img.size.width * self.img.scale
        let height = self.img.size.height * self.img.scale
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let context = CGContext.init(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGBitmapInfo.init(rawValue: 0 << 12).rawValue)
        
        guard let ct = context else { return nil }
        let imageRect = CGRect(x: 0, y: 0, width: width, height: height)
        ct.draw(self.img.cgImage!, in: imageRect)
        
        var grayi: UIImage? = nil
        let imageRef: CGImage = UIImage.init(cgImage: ct.makeImage()!).cgImage!
        if self.opaque {
            grayi = UIImage.init(cgImage: imageRef, scale: self.img.scale, orientation: self.img.imageOrientation)
        } else {
            guard let alphaContext = CGContext.init(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.alphaOnly.rawValue) else {
                return nil
            }
            alphaContext.draw(self.img.cgImage!, in: imageRect)
            guard let mask = alphaContext.makeImage() else {
                return nil
            }
            guard let maskedGrayImageRef = imageRef.masking(mask) else {
                return nil
            }
            grayi = UIImage.init(cgImage: maskedGrayImageRef, scale: self.img.scale, orientation: self.img.imageOrientation)
            
            guard let gi = grayi else {
                return nil
            }
            UIGraphicsBeginImageContextWithOptions(gi.size, false, gi.scale)
            gi.draw(in: imageRect)
            grayi = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return grayi
        }
        return grayi
    }
    
    /// (是否包含透明通道).
    final var opaque: Bool {
        guard let alphaInfo = self.img.cgImage?.alphaInfo else { return false }
        let opq = (alphaInfo == CGImageAlphaInfo.noneSkipLast) || (alphaInfo == CGImageAlphaInfo.noneSkipFirst) || (alphaInfo == CGImageAlphaInfo.none)
        return opq
    }
    
    /// (设置图片的透明度).
    ///
    /// - Parameter alpha: 透明度
    /// - Returns: 返回一张设置了透明度的图片
    final func alpha(_ alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.img.size, false, self.img.scale)
        guard UIGraphicsGetCurrentContext() != nil else {
            assertionFailure("非法 context.")
            return nil
        }
        let drawingRect = MakeRect(0, 0, self.img.size.width, self.img.size.height)
        self.img.draw(in: drawingRect, blendMode: CGBlendMode.normal, alpha: alpha)
        let imgOut = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imgOut
    }
    
    /// (保持当前图片的形状不变, 使用指定的颜色去重新渲染它).
    ///
    /// - Parameter tintColor: 用于渲染的颜色
    /// - Returns: 与当前图片形状一致但颜色与参数 tintColor 相同的新图片
    final func tintColor(_ tintColor: UIColor) -> UIImage? {
        let imgIn = self.img
        let rect = MakeRect(0, 0, imgIn.size.width, imgIn.size.height)
        UIGraphicsBeginImageContextWithOptions(imgIn.size, self.opaque, imgIn.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            assertionFailure("非法 context.")
            return nil
        }
        context.translateBy(x: 0, y: imgIn.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(CGBlendMode.normal)
        context.clip(to: rect, mask: imgIn.cgImage!)
        context.setFillColor(tintColor.cgColor)
        context.fill(rect)
        let imgOut = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imgOut
    }
    
    /// (保持当前图片的形状和纹理不变, 使用指定的颜色去重新渲染它).
    ///
    /// - Parameter blendColor: 用于渲染的颜色
    /// - Returns: 返回一张与当前图片形状纹理一致的经过 blendColor 颜色渲染的图片
    final func blendColor(_ blendColor: UIColor) -> UIImage? {
        guard let coloredImage = self.img.iwe.tintColor(blendColor) else { return nil }
        guard let filter = CIFilter.init(name: "CIColorBlendMode") else { return nil }
        filter.setValue(CIImage.init(cgImage: self.img.cgImage!), forKey: kCIInputBackgroundImageKey)
        filter.setValue(CIImage.init(cgImage: coloredImage.cgImage!), forKey: kCIInputImageKey)
        guard let outputImage = filter.outputImage else { return nil }
        let context = CIContext.init(options: nil)
        guard let imageRef = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        let resultImage = UIImage.init(cgImage: imageRef, scale: self.img.scale, orientation: self.img.imageOrientation)
        return resultImage
    }
}

