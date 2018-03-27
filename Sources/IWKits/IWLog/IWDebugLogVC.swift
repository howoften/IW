//
//  IWDebugLogVC.swift
//  IWExtensionDemo
//
//  Created by iWw on 2018/3/18.
//  Copyright © 2018年 iWe. All rights reserved.
//

import UIKit

public class IWDebugLogVC: IWSubVC {
    
    var outputFiles: [String] {
        let document = IWLogConfiguration.shared.recordDocumentPath
        do {
            let contents = try FileManager.default.contentsOfDirectory(atPath: document)
            var c: [String] = []
            for content in contents {
                if content.hasSuffix(".log") {
                    c.append(document.splicing(content))
                }
            }
            c = c.sorted().reversed()
            return c
        } catch {
            UIAlert.show(message: "Load output files failed.", config: nil)
            return []
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initUserInterface()
    }
    
    override public func initUserInterface() {
        title = "Debug logs"
        
        addPlainListView()
        listView.registReusable(UITableViewCell.self)
        
        self.iwe.addRightNavBtn("编辑", target: self, action: #selector(showEditingStyle))
    }
    
    @objc func showEditingStyle() {
        listView.setEditing(!listView.isEditing, animated: true)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override public func configureReusableCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.reuseCell()
        cell.textLabel!.text = outputFiles[safe: indexPath.row]?.lastPathNotHasPathExtension
        return cell
    }
    
    override public func configureDidSelect(_ tableView: UITableView, indexPath: IndexPath) {
        let filePath = outputFiles[safe: indexPath.row]
        let detailsVC = IWLogDetailsVC()
        detailsVC.filePath = filePath
        iwe.push(to: detailsVC)
    }
    
}


extension IWDebugLogVC {
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return outputFiles.count
    }
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let path = outputFiles[safe: indexPath.row] {
                if FileManager.default.fileExists(atPath: path) {
                    do {
                        try FileManager.default.removeItem(atPath: path)
                        tableView.deleteRows(at: [indexPath], with: .left)
                    } catch {
                        iPrint("Remove logs \(path) failed.")
                    }
                }
            }
        }
    }
    
}
