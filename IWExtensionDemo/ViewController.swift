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
    
    var updateLists: [[String: Any]]! = []

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
        
        self.configure()
        
        // 添加 plain 风格的 tableview
        addPlainListView()
        
        // iOS 11 已无需设置
        if iw.system.version.toDouble < 11.0 {
            listView.estimatedRowHeight = 68
            listView.rowHeight = UITableViewAutomaticDimension
        }
        
        self.iwe.addRightNavBtn("Debug Log", target: self, action: #selector(showDebugLog))
        
        listView.registReusable(UpdateListCell.self)
    }
    
    @objc func showDebugLog() -> Void {
        let vc = IWDebugLogVC()
        iwe.push(to: vc)
    }
    
    override func configure() -> Void {
        Bundle.main.path(forResource: "UpdateLists", ofType: "plist").unwrapped({ NSArray.init(contentsOfFile: $0).unwrapped({ updateLists = $0 as! [[String : Any]] }) })
    }

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    
    
    /// 应用详情
    func showStoreProduct() -> Void {
        // Surge3 1329879957, Web Developer Tool
        iw.appstore.show(with: "1329879957")
    }
    func showWaveLoading() -> Void {
        iw.loading.showWaveLoading()
        iw.delay.execution(delay: 3) {
            iw.loading.stopWaveLoading()
        }
    }
    func showWave(with maskType: IWWaveLoadingView.MaskViewType) {
        iw.loading.showWaveLoading(withMaskType: maskType)
        iw.delay.execution(delay: 3) {
            iw.loading.stopWaveLoading()
        }
    }
    
    func showLoginVC() -> Void {
        let vc = IWLoginNavController()
        self.iwe.modal(vc)
    }
    
    func showKeychainUsed() {
        let vc = KeyChainViewController.initFromXib()
        self.iwe.push(to: vc)
    }
    func showFlowLayout() {
        let vc = CollectionViewLayoutViewController.initFromXib()
        self.iwe.push(to: vc)
    }
    func showQRCode() {
        let vc = QRCodeViewController.initFromXib()
        self.iwe.push(to: vc)
    }
    
    override func configureDidSelect(_ tableView: UITableView, indexPath: IndexPath) {
        (tableView.cellForRow(at: indexPath) as? UpdateListCell).and(then: { $0.actionID }).unwrapped ({ (actionID) in
            switch actionID {
            case "generateQRCode":       self.showQRCode()
            case "keychain":             self.showKeychainUsed()
            case "flowlayout":           self.showFlowLayout()
            case "storeProduct":         self.showStoreProduct()
            case "showWave":             self.showWaveLoading()
            case "stopWave":             iw.loading.stopWaveLoading()
            case "showWaveDark":         self.showWave(with: .dark)
            case "showWaveLight":        self.showWave(with: .light)
            case "showWaveTransparent":  self.showWave(with: .transparent)
            case "login":                self.showLoginVC()
            default: break
            }
        })
    }
    
}

extension ViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return updateLists.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (updateLists[safe: section]?[safe: "list"] as? [[String: String]]).unwrapCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.reuseCell() as UpdateListCell
        
        updateLists[safe: indexPath.section].and(then: { $0[safe: "list"] as? [[String: String]] }).and(then: { $0[safe: indexPath.row] }).unwrapped({
            cell.config($0)
            if $0.keys.contains("acid") {
                cell.accessoryType = .disclosureIndicator
            } else {
                cell.accessoryType = .none
            }
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return updateLists[safe: section].and(then: { $0["tit"] }) as? String
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if iw.system.version.toDouble < 9.0 {
            // 8.0 版本自动计算高度会出现偏差
            return calcHeightForRowWithiOS8(indexPath)
        }
        return .estimated
    }
    
    private func calcHeightForRowWithiOS8(_ indexPath: IndexPath) -> CGFloat {
        if let updateDesc = updateLists[safe: indexPath.section].and(then: { $0["list"] as? [[String: String]] }).and(then: { $0[indexPath.row] }).and(then: { $0["sub"] }) as NSString? {
            let height = updateDesc.boundingRect(with: MakeSize(.screenWidth - 20 - 36, .greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont.init(name: "Menlo-Regular", size: 12)!], context: nil).size.height
            // 29 为sub的 y, 4为偏移量, 10为距离底部的距离
            return height + 29 + 4 + 10
        }
        return 29 + 4 + 10
    }
}

