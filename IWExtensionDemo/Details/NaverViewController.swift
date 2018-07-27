//
//  NaverViewController.swift
//  IWExtensionDemo
//
//  Created by iWw on 2018/4/28.
//  Copyright © 2018年 iWe. All rights reserved.
//

import UIKit

class NaverViewController: IWSubVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func configureUserInterface() {
        self.useLayoutGuide.enable()
        self.title = naverInfo?.title
    }
    
    @IBAction func back(_ sender: Any) {
        iw.naver.url("..")
    }
    
    @IBAction func toKeyChain(_ sender: Any) {
        iw.naver.url("./KeyChainViewController")
    }
    
    @IBAction func backToKeyChain(_ sender: Any) {
        iw.naver.url("../KeyChainViewController")
    }
    
    @IBAction func toWeb(_ sender: Any) {
        iw.naver.url("https://www.iwecon.cc")
    }
    
    @IBAction func backCompleted(_ sender: Any) {
        IWNaver.shared.naver("..") { (info) in
            UIAlert.show(message: "返回了", config: nil)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
