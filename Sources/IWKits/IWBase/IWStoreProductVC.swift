//
//  IWStoreProductVC.swift
//  IWExtensionDemo
//
//  Created by iWw on 24/01/2018.
//  Copyright © 2018 iWe. All rights reserved.
//

import UIKit
import StoreKit

/// (App Store 应用详情页).
public class IWStoreProductVC: SKStoreProductViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
    }
    
    /// (显示详情页, 填入对应的 AppID ).
    public func show(with appID: String?) {
        iw.loading.showWaveLoading()
        appID.unwrapped ({ (str) in
            let dic = [SKStoreProductParameterITunesItemIdentifier: str]
            self.loadProduct(withParameters: dic, completionBlock: { (ok, error) in
                iw.loading.stopWaveLoading()
                ok.founded({
                    UIViewController.IWE.current()?.present(self, animated: true, completion: nil)
                })
            })
        })
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension IWStoreProductVC: SKStoreProductViewControllerDelegate {
    
    public func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
