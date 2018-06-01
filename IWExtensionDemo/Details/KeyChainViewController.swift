//
//  KeyChainViewController.swift
//  IWExtensionDemo
//
//  Created by iWw on 2018/3/18.
//  Copyright © 2018年 iWe. All rights reserved.
//

import UIKit

class KeyChainViewController: IWSubVC {
    
    @IBOutlet weak var keyIndex: UITextField!
    @IBOutlet weak var value: UITextField!
    @IBOutlet weak var changeValue: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.useLayoutGuide = true
        self.navigationItemTitle = "钥匙串 Keychain"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func keyAction(_ sender: Any) {
        keyIndex.isEnabled = false
    }
    
    @IBAction func addAction(_ sender: Any) {
        IWKeyChainManager.save(service: keyIndex.text!, value: value.text!)
    }
    
    @IBAction func changeAction(_ sender: Any) {
        IWKeyChainManager.update(service: keyIndex.text!, value: changeValue.text!)
    }
    
    @IBAction func readAction(_ sender: Any) {
        let read = IWKeyChainManager.loadString(service: keyIndex.text!)
        UIAlert.show(message: "\(read ?? "没有")", config: nil)
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        IWKeyChainManager.delete(service: keyIndex.text!)
    }
}

