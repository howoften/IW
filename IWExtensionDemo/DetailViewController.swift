//
//  DetailViewController.swift
//  IWExtensionDemo
//
//  Created by iWw on 01/02/2018.
//  Copyright © 2018 iWe. All rights reserved.
//

import UIKit

class DetailViewController: IWSubVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupUserInterface() {
        setupPlainListView(to: self.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
