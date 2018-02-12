//  Created by iWe on 2017/7/14.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit
import Foundation

/// (CollectionView 自动布局).
public protocol IWCollectionViewFlowLayoutDelegate: UICollectionViewDelegateFlowLayout { }

/// (CollectionView 瀑布流式自动布局).
public class IWCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    private var itemAttributes: NSMutableArray! = nil
    public weak var delegate: IWCollectionViewFlowLayoutDelegate?
    
    private var allAttributes = NSMutableDictionary()
    
    private var lastedHeight: CGFloat = 0.0
    
    public override func prepare() {
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
        
        var lineBottoms: [CGFloat] = []
        var previousLineBottoms: [CGFloat] = []
        var hasHeader: Bool = false
        
        var lastHeight: CGFloat = minimumLineSpacing
        
        for sec in 0 ..< collectionView!.numberOfSections {
            
            let indexPath = IndexPath(item: 0, section: sec)
            let layoutAttributesHeader = UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: indexPath)
            let headerSize = headerReferenceSize
            layoutAttributesHeader.frame = CGRect(x: 0, y: lastHeight, width: headerSize.width, height: headerSize.height)
            itemAttributes.add(layoutAttributesHeader)
            
            yOffset = (layoutAttributesHeader.frame.origin.y + headerSize.height + sectionInset.top)
            xNextOffset = headerSize.width
            hasHeader = (headerSize.width > 0 || headerSize.height > 0)
            
            var wrapCount = 0
            var changeIdx = 0
            for idx in 0 ..< collectionView!.numberOfItems(inSection: sec) {
                let indexPath = IndexPath(item: idx, section: sec)
                let itemSize = delegate!.collectionView!(collectionView!, layout: self, sizeForItemAt: indexPath)
                
                xNextOffset += (minimumInteritemSpacing + itemSize.width)
                if xNextOffset > collectionView!.width - sectionInset.right {
                    
                    xOffset = sectionInset.left
                    xNextOffset = sectionInset.left + minimumInteritemSpacing + itemSize.width
                    
                    if hasHeader {
                        // 有头部时
                        (idx == 0).true({ yOffset -= self.minimumLineSpacing }, else: { yOffset += self.minimumLineSpacing + itemSize.height })
                    } else {
                        if lineBottoms.count == 1 {
                            lineBottoms[safe: 0].unwrapped({ yOffset = $0 + minimumLineSpacing })
                        } else {
                            lineBottoms[safe: idx - changeIdx - wrapCount].unwrapped({ yOffset = $0 + minimumLineSpacing }, else: { yOffset += headerSize.height + self.minimumLineSpacing })
                        }
                    }
                    changeIdx = idx
                    
                    previousLineBottoms = lineBottoms
                    lineBottoms = []
                    wrapCount = 1
                } else {
                    xOffset = xNextOffset - (minimumInteritemSpacing + itemSize.width)
                    if !hasHeader {
                        if idx != 0 {
                            if previousLineBottoms.count == 1 {
                                yOffset = previousLineBottoms[0] + minimumLineSpacing
                            } else {
                                yOffset = previousLineBottoms[safe: idx - changeIdx].or(0.00) + minimumLineSpacing
                            }
                        }
                    }
                    wrapCount += 1
                }
                lineBottoms.append(yOffset + itemSize.height)
                
                let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                layoutAttributes.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height)
                itemAttributes.add(layoutAttributes)
                
                lastHeight =  lineBottoms.max().map({ $0 + sectionInset.bottom }, else: { yOffset + itemSize.height + self.minimumLineSpacing + sectionInset.bottom })
            }
            
            xNextOffset = sectionInset.left
        }
        
        lastedHeight = lastHeight
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return (itemAttributes as NSArray).filtered(using: NSPredicate.init(block: { (evaluatedObject, bindings) -> Bool in
            let attrs = evaluatedObject as! UICollectionViewLayoutAttributes
            return rect.intersects(attrs.frame)
        })) as? [UICollectionViewLayoutAttributes]
    }
    
    public override var collectionViewContentSize: CGSize {
        var w: CGFloat = 0
        var h: CGFloat = 0
        if let collection = collectionView {
            w = collection.width
            h = lastedHeight + 20
        }
        return CGSize(width: w, height: h)
    }
}


