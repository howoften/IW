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
        
        listView.registReusable(UpdateListCell.self)
    }
    
    override func configure() -> Void {
        updateLists = [
            ["tit": "01月24日",
             "list": [
                ["tit": "IWWaveLoadingView.swift", "sub": "[新增] 等待视图(loading...)."],
                ["tit": "IWGlobal.swift", "sub": """
                    [新增] iw.loading.showWaveLoading() 显示等待视图, 无遮罩;
                    [新增] iw.loading.stopWaveLoading() 移除等待视图;
                    [新增] iw.loading.showWaveLoading(withMaskType:) 以遮照方式显示等待视图.
                    """],
                ["tit": "iw.loading.showWaveLoading()", "sub": "[功能演示] 默认等待视图.", "acid": "showWave"],
                ["tit": "iw.loading.stopWaveLoading()", "sub": "[功能演示] 移除遮照.", "acid": "stopWave"],
                ["tit": "iw.loading.stopWaveLoading(withMaskType: .dark)", "sub": "[功能演示] 暗色遮照 3秒后自动消失.", "acid": "showWaveDark"],
                ["tit": "iw.loading.stopWaveLoading(withMaskType: .light)", "sub": "[功能演示] 亮色遮照 3秒后自动消失.", "acid": "showWaveLight"],
                ["tit": "iw.loading.stopWaveLoading(withMaskType: .transparent)", "sub": "[功能演示] 透明遮照 3秒后自动消失.", "acid": "showWaveTransparent"],
                ["tit": "------------", "sub": "巧妙的分割线"],
                ["tit": "IWStoreProductVC.swift", "sub": "[新增] 用于在App内直接展示App Store应用的详情页(可以安装/打开).", "acid": "storeProduct"]
                ]
            ],
            ["tit": "01月23日",
             "list": [
                ["tit": "IWListView.swift", "sub": """
                    [移除](093行) cell下划线颜色: separatorColor = .groupTableViewBackground;
                    [移除](106行) 自动计算高度: willMove(toSuperview newSuperview: UIView?).
                    """]
                ]
            ],
            ["tit": "01月22日",
             "list": [
                ["tit": "extension Optional", "sub": "[新增] 可选值操作."],
                ["tit": "extension String", "sub": "[修改] toURL、toURLRequest 改为可选类型."]
                ]
            ],
            ["tit": "01月12日",
             "list": [
                ["tit": "IWListView.swift", "sub": "[新增] reloadVisiableRows(with:): 重新加载目前显示在视图上的 Cell."]
                ]
            ]
        ]
        
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
        let _ = iw.delay.execution(delay: 3) {
            iw.loading.stopWaveLoading()
        }
    }
    func showWave(with maskType: IWWaveLoadingView.MaskViewType) {
        iw.loading.showWaveLoading(withMaskType: maskType)
        let _ = iw.delay.execution(delay: 3) {
            iw.loading.stopWaveLoading()
        }
    }
    
    override func configureDidSelect(_ tableView: UITableView, indexPath: IndexPath) {
        (tableView.cellForRow(at: indexPath) as? UpdateListCell).and(then: { $0.actionID }).unwrapped ({ (actionID) in
            switch actionID {
            case "storeProduct": self.showStoreProduct()
            case "showWave": self.showWaveLoading()
            case "stopWave": iw.loading.stopWaveLoading()
            case "showWaveDark": self.showWave(with: .dark)
            case "showWaveLight": self.showWave(with: .light)
            case "showWaveTransparent": self.showWave(with: .transparent)
            default:
                break
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
        
        updateLists[safe: indexPath.section].and(then: { $0[safe: "list"] as? [[String: String]] }).and(then: { $0[safe: indexPath.row] }).unwrapped({ cell.config($0) })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return updateLists[safe: section].and(then: { $0["tit"] }) as? String
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if iw.system.version.toDouble < 9.0 {
            // 8.0 版本自动计算高度会出现偏差, 不知道为啥
            // 所以此处手动计算
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

