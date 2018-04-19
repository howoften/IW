//  Created by iWw on 2018/4/3.
//  Copyright © 2018年 iWe. All rights reserved.
//

import UIKit
import AVFoundation

/// (扫描类，需要 import AVFoundation, 需要在 info.plist 中添加 Camera Usage Description).
public class IWScan: NSObject {
    
    /// (会话体, 操作者).
    public let captureSession: AVCaptureSession = AVCaptureSession.init()
    
    /// (输入体).
    public var deviceInput: AVCaptureDeviceInput!
    /// (输出体).
    public var deviceOutput: AVCaptureMetadataOutput!
    
    /// (媒体类型).
    public var mediaType: AVMediaType!
    /// (识别数据类型).
    public var metadataObjectTypes: [AVMetadataObject.ObjectType]!
    
    convenience init(mediaType: AVMediaType, metadataObjectTypes: [AVMetadataObject.ObjectType]) {
        self.init()
        
        self.metadataObjectTypes = metadataObjectTypes
        self.mediaType = mediaType
        
        if let captureDevice = AVCaptureDevice.default(for: mediaType) {
            do {
                deviceInput = try AVCaptureDeviceInput.init(device: captureDevice)
                
                deviceOutput = AVCaptureMetadataOutput.init()
                captureSession.addInput(deviceInput)
                captureSession.addOutput(deviceOutput)
                
                deviceOutput.metadataObjectTypes = metadataObjectTypes
                
            } catch {
                
                if error.code == -11825 {
                    // 没有相机使用权限
                    iPrint("没有相机使用权限")
                    return
                }
                fatalError(error.localizedDescription)
            }
        }
        
    }
    
}
