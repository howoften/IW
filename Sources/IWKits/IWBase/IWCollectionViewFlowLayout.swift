
//
//  IWCollectionViewFlowLayout.swift
//  haoduobaduo
//
//  Created by iWe on 2017/7/14.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit
import Foundation

protocol IWCollectionViewFlowLayoutDelegate: UICollectionViewDelegateFlowLayout { }

class IWCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    class SetAttributesInfo {
        public var indexPath: IndexPath?
        public var hasHeader = false
        public var hasFooter = false
        public var frame: CGRect?
        
        convenience init(indexPath: IndexPath?, header: Bool, footer: Bool, frame: CGRect?) {
            self.init()
            self.indexPath = indexPath
            self.hasHeader = header
            self.hasFooter = footer
            self.frame = frame
        }
    }
    
    weak var delegate: IWCollectionViewFlowLayoutDelegate?
    
    /// (记录布局).
    var itemAttributes: [[IndexPath: UICollectionViewLayoutAttributes]] = []
    /// (content height).
    var maxContentHeight: CGFloat = 0.0
    
    override func prepare() {
        super.prepare()
        
        guard let collect = collectionView else { return }
        
        // config
        itemAttributes = []
        
        var itemX = sectionInset.left  // x
        var itemY = sectionInset.top   // y
        let maxWidth = collect.width - sectionInset.left - sectionInset.right
        var maxHeight = sectionInset.top + sectionInset.bottom
        
        var currentLine = 0
        var lineCount = 0
        //var pLineCount = 0
        var bottoms: [CGFloat] = []
        var pbottoms: [CGFloat] = []
        
        var pCalcSize: CGSize = .zero
        
        var hasSectionHeader = false     // 是否含有头部
        var hasSectionFooter = false     // 是否含有尾部
        
        // calc
        (0 ..< collect.numberOfSections).forEach ({ (section) in
            
            if itemAttributes.count != 0 {
                itemY += itemAttributes.last!.values.first!.frame.height + minimumLineSpacing
            }
            let headerAttriInfo = setHeaderAttributes(with: section, offsetY: itemY)
            hasSectionHeader = headerAttriInfo.hasHeader
            
            hasSectionHeader.founded({
                itemX = sectionInset.left + headerAttriInfo.frame.or(.zero).width
                itemY += headerAttriInfo.frame.or(.zero).height + minimumLineSpacing
                bottoms.append(itemY - minimumLineSpacing)
            })
            
            // section item
            (0 ..< collect.numberOfItems(inSection: section)).forEach({ (row) in
                
                let index = MakeIndex(row, section)
                let calcSize = delegate.expect("需要实现该协议(IWCollectionViewFlowLayoutDelegate)!").collectionView!(collect, layout: self, sizeForItemAt: index)
                
                if itemX + calcSize.width <= maxWidth {
                    // 同行
                    currentLine += 1
                    
                    itemX += self.minimumInteritemSpacing
                    hasSectionHeader.founded({
                        itemX += self.minimumInteritemSpacing
                    })
                    
                    if pbottoms.count > 0 {
                        if pbottoms.count == 1 {
                            itemY = pbottoms.first! + self.minimumLineSpacing
                        } else {
                            if currentLine > pbottoms.count - 1 {
                                while currentLine > pbottoms.count - 1 {
                                    currentLine -= 1
                                }
                                itemY = pbottoms[currentLine] + self.minimumLineSpacing
                            } else {
                                itemY = pbottoms[currentLine] + self.minimumLineSpacing
                            }
                            
                        }
                    }
                    
                    bottoms.append(itemY + calcSize.height)
                    
                    lineCount += 1
                } else {
                    // 换行
                    hasSectionHeader.founded({
                        hasSectionHeader.toggle()
                        
                        itemY = bottoms.last.or(0) + minimumLineSpacing
                        bottoms = []
                        pbottoms = []
                        bottoms.append(itemY + calcSize.height)
                        
                    }, else: {
                        
                        if bottoms.count == 0 {
                            itemY = itemY + pCalcSize.height + self.minimumLineSpacing
                            bottoms.append(itemY + pCalcSize.height)
                        } else {
                            pbottoms = bottoms
                            bottoms = []
                            
                            if pbottoms.count > 0 {
                                itemY = pbottoms.first! + self.minimumLineSpacing
                            } else {
                                itemY = bottoms.first! + self.minimumLineSpacing
                            }
                            bottoms.append(itemY + calcSize.height)
                        }
                        
                    })
                    
                    itemX = sectionInset.left
                    
                    //pLineCount = lineCount
                    lineCount = 1
                    currentLine = 0
                }
                
                // item
                setItemAttributes(with: index, fixFrame: MakeRect(itemX, itemY, calcSize.width, calcSize.height))
                
                // config
                itemX += calcSize.width
                pCalcSize = calcSize
                maxHeight = bottoms.max().or(itemY)
            })
            
            
            // section footer
            let footerAttriInfo = setFooterAttributes(with: section, offsetY: itemY)
            hasSectionFooter = footerAttriInfo.hasFooter
            hasSectionFooter.founded({
                itemX = sectionInset.left + footerAttriInfo.frame.or(.zero).width
                itemY += headerAttriInfo.frame.or(.zero).height + minimumLineSpacing
                bottoms.append(itemY - minimumLineSpacing)
            })
            maxHeight = bottoms.max().or(itemY - minimumLineSpacing) + minimumLineSpacing + sectionInset.bottom
        })
        
        // 整体高度/内容高度
        maxContentHeight = maxHeight
    }
    
    
    /// (返回是否含设置成功).
    func setHeaderAttributes(with section: Int, offsetY: CGFloat) -> SetAttributesInfo {
        
        let index = MakeIndex(0, section)
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: index)
        let dgSize = delegate.expect("需要实现该协议(IWCollectionViewFlowLayoutDelegate)!").collectionView?(collectionView.expect("collection view is nil."), layout: self, referenceSizeForHeaderInSection: section)
        
        if (headerReferenceSize.height > 0).or(dgSize.or(.zero).height > 0) {
            
            var fixFrame = headerReferenceSize.toRect
            (dgSize.or(.zero).height > 0).founded({
                fixFrame = dgSize!.toRect
            })
            fixFrame.origin.x = sectionInset.left
            fixFrame.origin.y = offsetY
            setAttributesFrame(with: attributes, fixFrame: fixFrame)
            
            let save = [index: attributes]
            itemAttributes.append(save)
            
            return SetAttributesInfo(indexPath: index, header: true, footer: false, frame: fixFrame)
        }
        return SetAttributesInfo(indexPath: nil, header: false, footer: false, frame: nil)
    }
    
    func setItemAttributes(with index: IndexPath, fixFrame: CGRect) -> Void {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: index)
        setAttributesFrame(with: attributes, fixFrame: fixFrame)
        
        let save = [index: attributes]
        itemAttributes.append(save)
    }
    
    /// (返回是否含设置成功).
    func setFooterAttributes(with section: Int, offsetY: CGFloat) -> SetAttributesInfo {
        let index = MakeIndex(0, section)
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, with: index)
        let dgSize = delegate.expect("需要实现该协议(IWCollectionViewFlowLayoutDelegate)!").collectionView?(collectionView.expect("collection view is nil."), layout: self, referenceSizeForHeaderInSection: section)
        if (footerReferenceSize.height > 0).or(dgSize.or(.zero).height > 0) {
            
            var fixFrame = footerReferenceSize.toRect
            (dgSize.or(.zero).height > 0).founded({ fixFrame = dgSize!.toRect })
            fixFrame.origin.x = sectionInset.left
            fixFrame.origin.y = offsetY + itemAttributes.last!.values.first!.frame.height
            setAttributesFrame(with: attributes, fixFrame: fixFrame)
            
            let save = [index: attributes]
            itemAttributes.append(save)
            
            return SetAttributesInfo(indexPath: index, header: false, footer: true, frame: fixFrame)
        }
        return SetAttributesInfo(indexPath: nil, header: false, footer: false, frame: nil)
    }
    
    func setAttributesFrame(with attributes: UICollectionViewLayoutAttributes, fixFrame: CGRect) -> Void {
        attributes.frame = fixFrame
    }
    
    /*
     override func prepare() {
     super.prepare()
     
     var itemCount = 0
     for sec in 0 ..< collectionView!.numberOfSections {
     itemCount += collectionView!.numberOfItems(inSection: sec)
     }
     self.itemAttributes = []
     
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
     let headerSize = self.headerReferenceSize
     layoutAttributesHeader.frame = CGRect(x: 0, y: lastHeight, width: headerSize.width, height: headerSize.height)
     //itemAttributes.add(layoutAttributesHeader)
     (headerSize.height > 0).true({
     let headerAttributes = [indexPath: layoutAttributesHeader]
     itemAttributes.append(headerAttributes)
     lastHeight += headerSize.height
     })
     
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
     
     print(lineBottoms)
     
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
     (previousLineBottoms.count > 0).true({ yOffset = previousLineBottoms[safe: idx - changeIdx].or(0.00) + minimumLineSpacing })
     }
     }
     }
     wrapCount += 1
     }
     lineBottoms.append(yOffset + itemSize.height)
     
     let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
     layoutAttributes.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height)
     let rowAttributes = [indexPath: layoutAttributes]
     itemAttributes.append(rowAttributes)
     
     lastHeight = lineBottoms.max().map({ $0 + sectionInset.bottom }, else: { yOffset + itemSize.height + self.minimumLineSpacing + sectionInset.bottom })
     }
     
     let footerLayoutAttributes = UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, with: indexPath)
     let footerSize = self.footerReferenceSize
     footerLayoutAttributes.frame = CGRect(x: 0, y: lastHeight, width: footerSize.width, height: footerSize.height)
     (footerSize.height > 0).true({
     let footerAttributes = [indexPath: footerLayoutAttributes]
     itemAttributes.append(footerAttributes)
     lastHeight += footerSize.height
     })
     
     xNextOffset = sectionInset.left
     }
     
     contentHeight = lastHeight
     }*/
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let ia = itemAttributes.filter { (attributes) -> Bool in
            return rect.intersects(attributes.values.first!.frame)
        }
        return ia.map({ $0.values.first! })
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let containerAttributes = itemAttributes.filter({ $0.keys.first! == indexPath })
        let attbs = containerAttributes.first!.values.first!
        return attbs
    }
    
    /// (顶部/尾部视图，类似于 tableView 的 HeaderFooterView).
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let containerAttributes = itemAttributes.filter({ $0.keys.first! == indexPath && $0.values.first!.representedElementCategory == .supplementaryView && $0.values.first!.representedElementKind == elementKind })
        let attbs = containerAttributes.first!.values.first!
        return attbs
    }
    
    override var collectionViewContentSize: CGSize {
        var w: CGFloat = 0
        var h: CGFloat = 0
        if let collection = collectionView {
            w = collection.width
            h = maxContentHeight // 最大高度
        }
        return CGSize(width: w, height: h)
    }
}

