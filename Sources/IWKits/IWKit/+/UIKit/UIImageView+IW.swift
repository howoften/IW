//
//  UIImageView+IWView.swift
//  haoduobaduo
//
//  Created by iWw on 2017/11/20.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

private var kImageNameKey: Void?
private let kImageCacheFolderPath = "IWImageCache"

public extension IWView where View: UIImageView {
    
    /// (设置图片 source为图片链接String或者图片URL).
    ///
    /// - Parameters:
    ///   - remoteSource: 图片链接String或者图片URL
    ///   - locationImageSource: 缺省图片(图片名称/图片路径).
    final func image<T>(source remoteSource: T?, placeholder locationImageSource: String? = nil) -> Void {
        let url = remoteSource
        if !(url.self is String) && !(url.self is URL) {
            iPrint("The 'url' parameter only support String or URL.")
            setLocationImageSource(locationImageSource)
            return
        }
        
        var urlString = ""
        if url.self is String { urlString = url as! String }
        if url.self is URL { urlString = (url as! URL).absoluteString }
        
        imageName = urlString.remove(["http:/", "https:/", "http://", "https://"]).replace("/", to: "_").replace("?", to: "_")
        
        extractImageData(with: imageName) { (isExists, data) in
            if !isExists {
                IWRequest.get(urlString, parameters: nil, desc: nil).result(success: { (imgData, _, result) in
                    if imgData != nil {
                        let img = UIImage(data: imgData!)
                        if img != nil {
                            iw.main.execution { self.view.image = img }
                            self.save(image: imgData!)
                        } else {
                            iw.main.execution { self.setLocationImageSource(locationImageSource) }
                        }
                    }
                }, failed: { (error) in
                    if error != nil { iPrint(error: error) }
                })
            }
        }
    }
}

private extension IWView where View: UIImageView {
    
    final var imageName: String? {
        get { return objc_getAssociatedObject(self, &kImageNameKey) as? String }
        set { objc_setAssociatedObject(self, &kImageNameKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }
    
    final func setLocationImageSource<iImageOrImageName>(_ locationImageSource: iImageOrImageName?) {
        if locationImageSource.self is UIImage {
            view.image = locationImageSource as? UIImage
        } else if locationImageSource.self is String {
            view.image = UIImage(named: locationImageSource as! String)
        } else {
            view.image = nil
        }
    }
    
    // 解析图片
    final func extractImageData(with name: String?, result: (_ isExists: Bool, _ data: Data?) -> Void) -> Void {
        let pathOption = imageLocalPath.splicing(name ?? "")
        if FileManager.default.fileExists(atPath: pathOption) {
            view.image = UIImage(contentsOfFile: pathOption)
            return
        }
        result(false, nil)
    }
    
    // 图片缓存路径
    final var imageLocalPath: String {
        let addPath = IWSandbox.caches.splicing(kImageCacheFolderPath)
        let bCreateDir = IWFileManage.create(kImageCacheFolderPath, in: IWSandbox.caches)
        if !bCreateDir {
            iPrint("The sandbox created birectory failed.")
        }
        return addPath
    }
    
    // 保存图片
    final func save(image data: Data) {
        let imageFilepath = self.imageLocalPath.splicing(self.imageName ?? "")
        do {
            let writePath = URL(fileURLWithPath: imageFilepath)
            try data.write(to: writePath, options: .atomicWrite)
        } catch {
            iPrint("The remote image cache failed.")
        }
    }
    
    /// 把 UIImageView 的宽高调整为能保持 image 宽高比例不变的同时又不超过给定的 `limitSize` 大小的最大frame, 建议在设置完 x/y 之后使用
    final func sizeToFitKeepingImageAdpectRatio(inSize limitSize: CGSize) -> Void {
        guard let img = self.view.image else {
            return
        }
        var currentSize = self.view.frame.size
        if currentSize.width <= 0 {
            currentSize.width = img.size.width
        }
        if currentSize.height <= 0 {
            currentSize.height = img.size.height
        }
        let horizontalRatio = limitSize.width / currentSize.width
        let verticalRatio = limitSize.height / currentSize.height
        let ratio = fmin(horizontalRatio, verticalRatio)
        var f = self.view.frame
        
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
        f.size.width = flat(currentSize.width * ratio)
        f.size.height = flat(currentSize.height * ratio)
        self.view.frame = f
    }
}

