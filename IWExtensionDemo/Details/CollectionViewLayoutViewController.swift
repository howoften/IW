//
//  CollectionViewLayoutViewController.swift
//  IWExtensionDemo
//
//  Created by iWw on 2018/3/19.
//  Copyright © 2018年 iWe. All rights reserved.
//

import UIKit

class CollectionViewLayoutViewController: IWSubVC {

    var collectView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupUserInterface() {
    }
    
    override func configureUserInterface() {
        navigationItemTitle = "自动布局"
        configCollectionView()
    }
    
    func configCollectionView() -> Void {
        let layout = IWCollectionViewFlowLayout()
        layout.delegate = self
        layout.sectionSpacing = 0               // 两个section的间距
        layout.minimumLineSpacing = 0           // 上下 item 的间距
        layout.minimumInteritemSpacing = 0      // 每个 item 的间距
        
        collectView = UICollectionView(frame: .screenBounds, collectionViewLayout: layout)
        collectView.delegate = self
        collectView.dataSource = self
        collectView.backgroundColor = .white
        collectView.alwaysBounceVertical = true
        collectView.registReusable(UICollectionViewCell.self)
        collectView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        collectView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
        collectView.iwe.addTo(view: view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension CollectionViewLayoutViewController: UICollectionViewDelegate, UICollectionViewDataSource, IWCollectionViewFlowLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.reuseCell(for: indexPath)
        item.backgroundColor = UIColor.random
        
        // 用的addsubview, 所以从复用池取出需要先 remove
        item.contentView.removeAllSubviews()
        // 显示 indexPath.row
        let v = UILabel(frame: MakeRect(0, 0, .screenWidth / 5, 24))
        v.text = "\(indexPath.row)"
        v.textColor = .white
        v.font = UIFont.systemFont(ofSize: 14)
        v.textAlignment = .center
        item.contentView.addSubview(v)
        
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header", for: indexPath)
            v.backgroundColor = UIColor.gray
            v.alpha = 0.5
            return v
        } else {
            //  if kind = UICollectionElementKindSectionFooter
            let v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer", for: indexPath)
            v.backgroundColor = UIColor.lightGray
            v.alpha = 0.5
            return v
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return MakeSize(.screenWidth, 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return MakeSize(.screenWidth, 100)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 随机取高度
        return MakeSize(.screenWidth / 4, Int.random(from: 30, to: 60).toCGFloat)
    }
    
}
