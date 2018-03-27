//  Created by iWw on 23/01/2018.
//  Copyright © 2018 iWe. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit

private var kUIImageView_imageNameKey: Void?
private let kImageCacheFolderPath = "IWImageCache"
public extension UIImageView {
    
    @IBInspectable var imageName: String? {
        get { return objc_getAssociatedObject(self, &kUIImageView_imageNameKey) as? String }
        set { objc_setAssociatedObject(self, &kUIImageView_imageNameKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }
    
    /// Set image with URL
    ///
    /// - Parameters:
    ///   - url: URL or URLString
    ///   - placeholder: Location Image Name
    public func image<T>(withURL url: T?, placeholder: String = "") {
        
        if !(url.self is String) && !(url.self is URL) {
            if placeholder != "" { image = UIImage(named: placeholder) }
            return
        }
        
        var urlString = ""
        if url.self is String { urlString = (url as! String) }
        if url.self is URL { urlString = (url as! URL).absoluteString }
        
        //imageName = urlString.lastPathNotHasPathExtension
        // 以完整的地址命名, 更大程度的避免了重复文件名的几率, 但可能解析力(速度)比较弱 hhhh
        imageName = urlString.replace(":", to: "_").replace("/", to: "_").replace("?", to: "_")
        
        extractImageData(with: imageName) { (isExists, data) in
            if !isExists {
                IWRequest.get(urlString, parameters: nil, desc: nil).result(success: { (imgData, _, result) in
                    if imgData != nil {
                        let img = UIImage(data: imgData!)
                        if img != nil {
                            iw.queue.main { self.image = img }
                            self.save(image: imgData!)
                        } else {
                            if placeholder != "" {
                                iw.queue.main { self.image = UIImage(named: placeholder) }
                            }
                        }
                    }
                }, failed: { (error) in
                    if error != nil {
                        iPrint(error: error)
                    }
                })
            }
        }
        
    }
    
    /// 解析图片
    private func extractImageData(with name: String?, result: (_ isExists: Bool, _ data: Data?) -> Void) -> Void {
        let pathOption = imageLocalPath.splicing(name ?? "")
        if FileManager.default.fileExists(atPath: pathOption) {
            self.image = UIImage(contentsOfFile: pathOption)
            return
        }
        result(false, nil)
    }
    /// 图片缓存路径
    private var imageLocalPath: String {
        let addPath = IWSandbox.caches.splicing(kImageCacheFolderPath)
        let bCreateDir = IWFileManage.create(kImageCacheFolderPath, in: IWSandbox.caches)
        if !bCreateDir {
            iPrint("The sandbox created birectory failed.")
        }
        return addPath
    }
    /// 保存图片
    private func save(image data: Data) {
        let imageFilepath = self.imageLocalPath.splicing(self.imageName ?? "")
        do {
            let writePath = URL(fileURLWithPath: imageFilepath)
            try data.write(to: writePath, options: .atomicWrite)
        } catch {
            iPrint("The remote image cache failed.")
        }
    }
}
    
#endif
