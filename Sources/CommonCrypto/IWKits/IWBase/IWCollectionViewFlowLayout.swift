
//
//  IWCollectionViewFlowLayout.swift
//  haoduobaduo
//
//  Created by iWe on 2017/7/14.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit
import Foundation

protocol IWCollectionViewFlowLayoutDelegate: UICollectionViewDelegateFlowLayout {
    
}

class IWCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    var itemAttributes: NSMutableArray! = nil
    weak var delegate: IWCollectionViewFlowLayoutDelegate?
    
    var allAttributes = NSMutableDictionary()
    
    var lastedHeight: CGFloat = 0.0
    
    override func prepare() {
        super.prepare()
        
        allAttributes.removeAllObjects()
        
        var itemCount = 0
        for sec in 0 ..< collectionView!.numberOfSections {
            itemCount += collectionView!.numberOfItems(inSection: sec)
        }
        self.itemAttributes = NSMutableArray(capacity: itemCount)
        
        var xOffset = sectionInset.left
        var yOffset = sectionInset.top
        var xNextOffset = sectionInset.left
        
        var lastHeight: CGFloat = minimumLineSpacing
        
        for sec in 0 ..< collectionView!.numberOfSections {
            
            let indexPath = IndexPath(item: 0, section: sec)
            let layoutAttributesHeader = UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: indexPath)
            let headerSize = headerReferenceSize
            layoutAttributesHeader.frame = CGRect(x: 0, y: lastHeight, width: headerSize.width, height: headerSize.height)
            itemAttributes.add(layoutAttributesHeader)
            
            yOffset = (layoutAttributesHeader.frame.origin.y + headerSize.height + sectionInset.top)
            
            for idx in 0 ..< collectionView!.numberOfItems(inSection: sec) {
                let indexPath = IndexPath(item: idx, section: sec)
                let itemSize = delegate!.collectionView!(collectionView!, layout: self, sizeForItemAt: indexPath)
                
                xNextOffset += (minimumInteritemSpacing + itemSize.width)
                if xNextOffset > collectionView!.width - sectionInset.right {
                    xOffset = sectionInset.left
                    xNextOffset = sectionInset.left + minimumInteritemSpacing + itemSize.width
                    yOffset += itemSize.height + minimumLineSpacing
                } else {
                    xOffset = xNextOffset - (minimumInteritemSpacing + itemSize.width)
                }
                
                let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                layoutAttributes.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height)
                itemAttributes.add(layoutAttributes)
                
                lastHeight = yOffset + itemSize.height + minimumLineSpacing + sectionInset.bottom
            }
            
            xNextOffset = sectionInset.left
        }
        
        lastedHeight = lastHeight
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return (itemAttributes as NSArray).filtered(using: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            let attrs = evaluatedObject as! UICollectionViewLayoutAttributes
            return rect.intersects(attrs.frame)
        })) as? [UICollectionViewLayoutAttributes]
    }
    
    override var collectionViewContentSize: CGSize {
        var w: CGFloat = 0
        var h: CGFloat = 0
        if let collection = collectionView {
            w = collection.width
            h = lastedHeight + 20
        }
        return CGSize(width: w, height: h)
    }
}
