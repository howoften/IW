//
//  IWAuthorization.swift
//  haoduobaduo
//
//  Created by iWe on 2017/8/3.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit
import AssetsLibrary
import AddressBook
import Intents

class IWAuthorization: NSObject {
    
    typealias IWAuthorizationSelectedImageCallback = (_ imagePath: String?) -> Void
    
    private static let instance = IWAuthorization()
    static var shared: IWAuthorization {
        return IWAuthorization.instance
    }
    var selectedCallback: IWAuthorizationSelectedImageCallback?
    
    // MARK:- 请求访问相册
    class func requestAlbumPermissions(_ authResult: ((_ : Bool) -> Void)? = nil, selectedImage:((_ : String?) -> Void)? = nil) {
        let status = ALAssetsLibrary.authorizationStatus()
        if status == .restricted || status == .denied {
            // No permissions
            print("无权限")
            authResult?(false)
        } else {
            // Has permissions
            authResult?(true)
            shared.selectedCallback = selectedImage
            shared.openPhotoLibrary()
        }
    }
    // MARK:- 请求访问相机
    class func requestCameraPermissions(_ authResult: ((_ : Bool) -> Void)? = nil, selectedImage:((_ : String?) -> Void)? = nil) {
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Cameras are not available in the simulator, switch to iPhone.")
            authResult?(false)
            return
        }
        
        let status = ALAssetsLibrary.authorizationStatus()
        if status == .restricted || status == .denied {
            print("No permissions")
            authResult?(false)
        } else {
            authResult?(true)
            shared.selectedCallback = selectedImage
            shared.openCamera()
        }
    }
    
	
	/*
    /// 请求访问通讯录
    class func requestAddressBook(_ authResult: ((_ : Bool, _ : ABAddressBook?) -> Void)? = nil) {
        let addressBook = ABAddressBookCreateWithOptions(nil, nil)
        
        let semaphore = DispatchSemaphore.init(value: 0)
        var isAuth = false
        ABAddressBookRequestAccessWithCompletion(addressBook as ABAddressBook) { (granted, error) in
            isAuth = granted
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        if !isAuth {
            authResult?(false, nil)
            return
        }
        authResult?(true, addressBook as ABAddressBook)
    } */
    
    // MARK:- 系统服务
    /**
     需要在URL type中添加一个Prefs值
     参考：http://www.jianshu.com/p/5d82fb0c4051 */
    class func toSystemSettings(_ type: String) {
        var urlPath = ""
        if iw.system.version.toInt <= 7 || (iw.system.version.toInt >= 8 && iw.system.version.toInt < 10) {
            urlPath = "prefs:root=\(type)"
        } else {
            urlPath = type
        }
        
        if UIApplication.shared.canOpenURL(urlPath.toURL) {
            UIApplication.shared.openURL(urlPath.toURL)
        } else {
            UIAlert.show(message: "无法跳转, 请检查是否有误！", config: nil)
        }
    }
	
	// MARK:- 请求访问Siri
	@available(iOS 10.0, *)
	class func requestSiri() {
		INPreferences.requestSiriAuthorization { (status) in
			switch status {
			case .authorized:
				iPrint("已授权Siri.")
			case .notDetermined:
				iPrint("未决定是否授权Siri.")
			case .restricted:
				iPrint("Siri权限受限制.")
			case .denied:
				iPrint("用户拒绝授权Siri.")
			}
		}
	}
}

fileprivate extension IWAuthorization {
    func openPhotoLibrary() {
        open(type: .photoLibrary)
    }
    func openCamera() {
        open(type: .camera)
    }
    func open(type: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = type
        picker.allowsEditing = true
        UIViewController.IWE.current()?.iwe.modal(picker)
    }
}


extension IWAuthorization: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let type = info[UIImagePickerControllerMediaType] as! String
        if type == "public.image" {
            // image
            let image = info["UIImagePickerControllerEditedImage"] as? UIImage
            var data: Data?
            
            if let img = image {
                if UIImagePNGRepresentation(img) == nil {
                    data = UIImageJPEGRepresentation(img, 0.5)
                } else {
                    data = UIImagePNGRepresentation(img)
                }
                
                // Save image to sandbox {
                let documentsPath = NSHomeDirectory().splicing("Documents")
                let manager = FileManager.default
                do {
                    try manager.createDirectory(atPath: documentsPath, withIntermediateDirectories: true, attributes: nil)
                    let createFile = manager.createFile(atPath: documentsPath.appending("/selectedImage.png"), contents: data, attributes: nil)
                    if createFile {
                        let filePath = documentsPath.splicing("/selectedImage.png")
                        iw.main.execution { self.selectedCallback?(filePath) }
                    } else {
                        iw.main.execution { self.selectedCallback?(nil) }
                    }
                    picker.dismiss(animated: true, completion: nil)
                } catch {
                    print(error)
                }
            }
        }
    }
}
