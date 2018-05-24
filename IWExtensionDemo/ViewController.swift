//
//  ViewController.swift
//  IWExtensionDemo
//
//  Created by iWe on 2017/12/31.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

class ViewController: IWRootVC {
    
    @IBOutlet weak var tbView: UITableView!
    
    var viewModel = ViewControllerViewModel.init()
    lazy var ds = {
        ViewControllerDataSource.init(self.viewModel)
    }()
    lazy var dg = {
        ViewControllerDelegate.init(self.viewModel)
    }()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
        
        initUserInterface()
	}
    
    override func initUserInterface() {
        // 大标题
        if #available(iOS 11, *) { self.isEnableLargeTitlesStyle = true; self.largeTitleDisplayMode = .automatic }
        
        // 隐藏 navigation bar 下划线
        (self.navigationController as? IWNavController)?.isHiddenShadowImage = true
        
        setupPlainListView(to: self.view)
        listView.registReusable(UpdateListCell.self)
        
        listView.configrationProtocols(delegate: nil, dataSource: ds, rcells: [UpdateListCell.self], rviews: nil)
        
        listView.delegate = dg
        listView.dataSource = ds
        
        // iOS 11 已无需设置
        if iw.system.version.toDouble < 11.0 {
            listView.estimatedRowHeight = 68
            listView.rowHeight = UITableViewAutomaticDimension
        }
        
        iwe.addRightNavBtn("Log", target: self, action: #selector(showDebugLog))
    }
    
    @objc func showDebugLog() -> Void {
        iw.naver.url("./IWDebugLogVC")
    }

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
