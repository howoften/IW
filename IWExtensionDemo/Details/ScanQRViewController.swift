//
//  ScanQRViewController.swift
//  IWExtensionDemo
//
//  Created by iWw on 2018/4/3.
//  Copyright © 2018年 iWe. All rights reserved.
//

import UIKit
import AVFoundation

class ScanQRViewController: IWSubVC {
    
    @IBOutlet weak var containerView: UIView!
    
    var scanQR: IWScanQR!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUserInterface()
    }
    
    override func initUserInterface() {
        self.useLayoutGuide = true
        self.navTitle = "扫描二维码"
        
        let sta = IWPermissionManager<IWPCamera>.init().authorizationStatus
        if sta != .none && sta != .denied && sta != .restricted {
            let start = UIBarButtonItem.init(title: "开始扫描", style: .plain, target: self, action: #selector(restartScanning))
            let album = UIBarButtonItem.init(title: "相册", style: .plain, target: self, action: #selector(openAlbum))
            self.navigationItem.rightBarButtonItems = [album, start]
            self.initScan()
            scanQR.startScanning()
        }
    }
    
    func initScan() -> Void {
        scanQR = IWScanQR.init(videoFrame: self.containerView.bounds)
        containerView.layer.addSublayer(scanQR.videoPreviewLayer)
        scanQR.scaned { (opObjs) in
            if let objs = opObjs {
                var outp = ""
                for (idx, value) in objs.enumerated() {
                    outp += "结果\(idx): " + value.stringValue.or("") + ";\n"
                }
                UIAlert.show(message: outp, config: { (alert) in
                    alert.addCancel(title: "好的", handler: nil)
                    alert.addConfirm(title: "继续扫描", style: .default, handler: { (act) in
                        self.scanQR.startScanning()
                    })
                })
            }
        }
    }
    
    @objc func openAlbum() -> Void {
        
    }
    
    @objc func restartScanning() -> Void {
        scanQR.startScanning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
