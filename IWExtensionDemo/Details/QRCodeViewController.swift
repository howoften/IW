//
//  QRCodeViewController.swift
//  IWExtensionDemo
//
//  Created by iWw on 2018/3/27.
//  Copyright © 2018年 iWe. All rights reserved.
//

import UIKit

class QRCodeViewController: IWSubVC {

    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var qrContent: UITextField!
    @IBOutlet weak var qrLogoTypeControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.useLayoutGuide.enable()
        self.navigationItemTitle = "生成二维码"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func generateQRCodeAction(_ sender: Any) {
        guard let content = qrContent.text else {
            iPrint("二维码内容不能为空")
            return }
        
        var logoSizeType: UIImage.QRCodeLogoImageSizeType = .none
        if qrLogoTypeControl.selectedSegmentIndex == 1 {
            logoSizeType = .small
        } else if qrLogoTypeControl.selectedSegmentIndex == 2 {
            logoSizeType = .big
        }
        qrImageView.image = UIImage.generateQRCode(withContent: content, withSize: qrImageView.width, logoImage: UIImage.init(named: "logo"), logoSizeType: logoSizeType)
    }
    
    @IBAction func saveQRCodeAction(_ sender: Any) {
        qrImageView.saveToAlbum(withSize: nil) { (_, success, _) in
            if success {
                UIAlert.show(message: "保存成功", config: nil)
            } else {
                UIAlert.show(message: "保存失败", config: nil)
            }
        }
    }
    
    @IBAction func saveViewAction(_ sender: Any) {
        self.view.saveToAlbum(withSize: nil) { (_, success, _) in
            if success {
                UIAlert.show(message: "保存成功", config: nil)
            } else {
                UIAlert.show(message: "保存失败", config: nil)
            }
        }
    }
    
}
