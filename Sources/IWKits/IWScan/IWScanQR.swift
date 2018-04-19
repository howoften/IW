//
//  IWScanQR.swift
//  IWExtensionDemo
//
//  Created by iWw on 2018/4/3.
//  Copyright © 2018年 iWe. All rights reserved.
//

import UIKit
import AVFoundation

/// (后置镜头扫描二维码类).
public class IWScanQR: IWScan {
    
    public typealias ScanedQR = (_ : [AVMetadataMachineReadableCodeObject]?) -> Void
    private var scanedBlock: ScanedQR?
    
    /// (Camera 显示图层).
    public var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    public var isReturnAll = false
    
    /// (QR 扫描初始化).
    ///
    /// - Parameters:
    ///   - videoFrame: Camera 图层大小
    ///   - interest: 扫描位置
    ///   - videoGravity: Camera 填充方式
    ///   - returnAll: 是否返回扫描到的所有结果, false只返回第一个结果, true返回所有结果
    convenience init(videoFrame: CGRect, interest: CGRect = CGRect(x: 0.2, y: 0.2, width: 0.8, height: 0.8), videoGravity: AVLayerVideoGravity = .resizeAspectFill, returnAll: Bool = false) {
        self.init(mediaType: .video, metadataObjectTypes: [AVMetadataObject.ObjectType.qr])
        
        // 初始化 Camera layer
        videoPreviewLayer = AVCaptureVideoPreviewLayer.init(session: captureSession)
        videoPreviewLayer.videoGravity = videoGravity
        videoPreviewLayer.frame = videoFrame
        
        self.isReturnAll = returnAll
        
        // 扫描范围
        deviceOutput.rectOfInterest = interest
        // 输出代理
        deviceOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.init(label: "cc.iwecon.scanqr"))
    }
    
    
    /// (扫描完成/扫描到结果).
    ///
    /// - Parameter block: 返回结果/结果处理
    public func scaned(_ block: ScanedQR?) {
        self.scanedBlock = block
    }
    
    /// (开始扫描).
    public func startScanning() -> Void {
        self.captureSession.startRunning()
    }
    /// (停止扫描).
    public func stopScanning() -> Void {
        self.captureSession.stopRunning()
    }
    
    /// (处理结果).
    private func handlerResult(_ objs: [AVMetadataObject]) -> Void {
        
        guard let qrObjs = objs as? [AVMetadataMachineReadableCodeObject] else {
            fatalError("`AVMetadataObject` to `AVMetadataMachineReadableCodeObject` failed.")
        }
        
        if isReturnAll {
            self.scanedBlock?(qrObjs)
        } else {
            self.scanedBlock?([qrObjs.first!])
        }
    }
    
}

extension IWScanQR: AVCaptureMetadataOutputObjectsDelegate {
    
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        // 此处表示扫描到二维码
        if metadataObjects.count > 0 {
            
            // 停止扫描
            stopScanning()
            
            // 处理返回的数据
            handlerResult(metadataObjects)
        }
    }
    
}
