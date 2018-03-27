
//
//  IWCollectionViewFlowLayout.swift
//  haoduobaduo
//
//  Created by iWe on 2017/7/14.
//  Copyright © 2017年 iWe. All rights reserved.
//

#if os(iOS)
import UIKit

public protocol IWCollectionViewFlowLayoutDelegate: UICollectionViewDelegateFlowLayout { }

// (自动布局).
public class IWCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
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
    
    public weak var delegate: IWCollectionViewFlowLayoutDelegate?
    
    /// (记录布局).
    private var itemAttributes: [[IndexPath: UICollectionViewLayoutAttributes]] = []
    /// (content height).
    private var maxContentHeight: CGFloat = 0.0
    /// (content width).
    private var maxContentWidth: CGFloat = 0.0
    
    /// (两个 section 的距离).
    public var sectionSpacing: CGFloat = 0.0
    
    convenience init(delegate: IWCollectionViewFlowLayoutDelegate?, minLineSpacing: CGFloat = 0, minItemSpacing: CGFloat = 0, scrollDirection direction: UICollectionViewScrollDirection = .vertical) {
        self.init()
        self.delegate = delegate
        self.minimumLineSpacing = minLineSpacing
        self.minimumInteritemSpacing = minItemSpacing
        self.scrollDirection = direction
    }
    
    public override func prepare() {
        super.prepare()
        
        guard let collect = collectionView else { return }
        
        // config
        itemAttributes = []
        
        var itemX = sectionInset.left  // x
        var itemY = sectionInset.top   // y
        var maxWidth: CGFloat = 0.0 // collect.width - sectionInset.left - sectionInset.right
        let limitWidth = collect.width - sectionInset.left - sectionInset.right
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
                itemY += sectionSpacing //itemAttributes.last!.values.first!.frame.height + minimumLineSpacing
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
                
                if itemX + calcSize.width <= limitWidth || scrollDirection == .horizontal {
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
                    maxWidth += calcSize.width
                    
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
            itemY = bottoms.max().or(itemY) + minimumLineSpacing
            let footerAttriInfo = setFooterAttributes(with: section, offsetY: itemY)
            hasSectionFooter = footerAttriInfo.hasFooter
            hasSectionFooter.founded({
                itemX = sectionInset.left + footerAttriInfo.frame.or(.zero).width
                itemY += footerAttriInfo.frame.or(.zero).height + minimumLineSpacing
                bottoms.append(itemY - minimumLineSpacing)
            })
            maxHeight = bottoms.max().or(itemY - minimumLineSpacing) + sectionInset.bottom
        })
        
        // 整体高度/内容高度
        maxContentHeight = maxHeight
        
        if scrollDirection == .horizontal {
            maxContentWidth = maxWidth + sectionInset.right
        } else {
            maxContentWidth = collect.width - sectionInset.right - sectionInset.left
        }
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
        let dgSize = delegate.expect("需要实现该协议(IWCollectionViewFlowLayoutDelegate)!").collectionView?(collectionView.expect("collection view is nil."), layout: self, referenceSizeForFooterInSection: section)
        if (footerReferenceSize.height > 0).or(dgSize.or(.zero).height > 0) {
            
            var fixFrame = footerReferenceSize.toRect
            (dgSize.or(.zero).height > 0).founded({ fixFrame = dgSize!.toRect })
            fixFrame.origin.x = sectionInset.left
            fixFrame.origin.y = offsetY // + itemAttributes.last!.values.first!.frame.height
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
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let ia = itemAttributes.filter { (attributes) -> Bool in
            return rect.intersects(attributes.values.first!.frame)
        }
        return ia.map({ $0.values.first! })
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let containerAttributes = itemAttributes.filter({ $0.keys.first! == indexPath })
        let attbs = containerAttributes.first!.values.first!
        return attbs
    }
    
    /// (顶部/尾部视图，类似于 tableView 的 HeaderFooterView).
    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let containerAttributes = itemAttributes.filter({ $0.keys.first! == indexPath && $0.values.first!.representedElementCategory == .supplementaryView && $0.values.first!.representedElementKind == elementKind })
        let attbs = containerAttributes.first!.values.first!
        return attbs
    }
    
    public override var collectionViewContentSize: CGSize {
        return CGSize(width: maxContentWidth, height: maxContentHeight)
    }
    
}

#endif
