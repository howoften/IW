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
    lazy var ds = { ViewControllerDataSource.init(self.viewModel) }()
    lazy var dg = { ViewControllerDelegate.init(self.viewModel) }()

	override func viewDidLoad() {
		super.viewDidLoad()
	}
    
    override func preconfiguration() {
        // 大标题
        if #available(iOS 11, *) { self.isEnableLargeTitlesStyle = true; self.largeTitleDisplayMode = .automatic }
    }
    
    override func setupUserInterface() {
        setupPlainListView(to: self.view)
    }
    
    override func configureUserInterface() {
        
        // 隐藏 navigation bar 下划线
        (self.navigationController as? IWNavController)?.isHiddenShadowImage = true
        
        // iOS 11 已无需设置
        if iw.system.version.toDouble < 11.0 {
            listView.estimatedRowHeight = 68
            listView.rowHeight = UITableViewAutomaticDimension
        }
        listView.configrationProtocols(delegate: dg, dataSource: ds, rcells: [UpdateListCell.self], rviews: nil)
        
        setupRightBarButtomItem("Log", target: self, action: #selector(showDebugLog))
    }
    
    @objc func showDebugLog() -> Void {
        iw.naver.url("./IWDebugLogVC")
    }

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
