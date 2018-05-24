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
        self.initUserInterface()
    }
    
    override func initUserInterface() {
        addPlainListView()
        //listView.registReusable(IWTableViewCell.self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


//extension DetailViewController {
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        let cell = tableView.reuseCell() as IWTableViewCell
////        cell.textLabel?.text = "\(indexPath.row)"
////        return cell
//        return UITableViewCell()
//    }
//
//}
