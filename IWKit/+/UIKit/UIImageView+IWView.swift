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

extension IWView where View: UIImageView {
    
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
                            main { self.view.image = img }
                            self.save(image: imgData!)
                        } else {
                            main { self.setLocationImageSource(locationImageSource) }
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
    
    var imageName: String? {
        get { return objc_getAssociatedObject(self, &kImageNameKey) as? String }
        set { objc_setAssociatedObject(self, &kImageNameKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }
    
    func setLocationImageSource<iImageOrImageName>(_ locationImageSource: iImageOrImageName?) {
        if locationImageSource.self is UIImage {
            view.image = locationImageSource as? UIImage
        } else if locationImageSource.self is String {
            view.image = UIImage(named: locationImageSource as! String)
        } else {
            view.image = nil
        }
    }
    
    // 解析图片
    func extractImageData(with name: String?, result: (_ isExists: Bool, _ data: Data?) -> Void) -> Void {
        let pathOption = imageLocalPath.splicing(name ?? "")
		if FileManager.default.fileExists(atPath: pathOption) {
			view.image = UIImage(contentsOfFile: pathOption)
			return
		}
        result(false, nil)
    }
    
    // 图片缓存路径
    var imageLocalPath: String {
		let addPath = IWSandbox.caches.splicing(kImageCacheFolderPath)
		let bCreateDir = IWFileManage.create(kImageCacheFolderPath, in: IWSandbox.caches)
		if !bCreateDir {
			iPrint("The sandbox created birectory failed.")
		}
		return addPath
    }
    
    // 保存图片
    func save(image data: Data) {
        let imageFilepath = self.imageLocalPath.splicing(self.imageName ?? "")
        do {
            let writePath = URL(fileURLWithPath: imageFilepath)
            try data.write(to: writePath, options: .atomicWrite)
        } catch {
            iPrint("The remote image cache failed.")
        }
    }
    
}
