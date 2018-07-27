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

private class CalcInfoModel: NSObject {
    /// x
    var itemX: CGFloat!
    /// y
    var itemY: CGFloat!
    
    var bottoms: [CGFloat] = []
    var previousBottoms: [CGFloat] = []
    
    var currentLineCount: Int = 0
    var limitWidth: CGFloat = 0
    var previousSetSize: CGSize = .zero
}

// (自动布局).
public class IWCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    /// (UICollectionViewFlowLayoutDelegate，如需动态高度，实现 sizeForItem).
    public weak var delegate: IWCollectionViewFlowLayoutDelegate?
    
    /// (两个 section 之间的距离, 垂直的时候 footer 与 header 的距离).
    public var sectionSpacing: CGFloat = 0.0
    
    /// (记录布局信息).
    private class SetAttributesInfo {
        public var indexPath: IndexPath?    // index
        public var hasHeader = false        // 有无 header
        public var hasFooter = false        // 有无 footer
        public var frame: CGRect?           // frame
        
        /// Init
        convenience init(indexPath: IndexPath?, header: Bool, footer: Bool, frame: CGRect?) {
            self.init()
            self.indexPath = indexPath
            self.hasHeader = header
            self.hasFooter = footer
            self.frame = frame
        }
    }
    /// (记录布局).
    private var itemAttributes: [[IndexPath: UICollectionViewLayoutAttributes]] = []
    /// (content height).
    private var maxContentHeight: CGFloat = 0.0
    /// (content width).
    private var maxContentWidth: CGFloat = 0.0
    
    
    public convenience init(delegate: IWCollectionViewFlowLayoutDelegate?, minLineSpacing: CGFloat = 0, minItemSpacing: CGFloat = 0, scrollDirection direction: UICollectionViewScrollDirection = .vertical) {
        self.init()
        self.delegate = delegate
        self.minimumLineSpacing = minLineSpacing
        self.minimumInteritemSpacing = minItemSpacing
        self.scrollDirection = direction
    }
    
    
    public override func prepare() {
        super.prepare()
        
        guard let collect = collectionView else { return }
        
        resetDatas()
        calcLayoutInfo(with: collect)
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

// MARK:- Private/Calculator
extension IWCollectionViewFlowLayout {
    
    /// (清空/重置初始值)
    private func resetDatas() -> Void {
        itemAttributes.removeAll()
    }
    
    /// (计算布局信息).
    private func calcLayoutInfo(with collect: UICollectionView) -> Void {
        
        let infoModel = CalcInfoModel()
        infoModel.itemX = sectionInset.left
        infoModel.itemY = sectionInset.top
        // collectionView 有效显示范围
        infoModel.limitWidth = collect.width - sectionInset.left - sectionInset.right
        
        for sec in 0 ..< collect.numberOfSections {
            // secs -> section
            
            // header
            var useHeader = calcHeaderInfo(with: sec, model: infoModel)
            
            // row/item
            for row in 0 ..< collect.numberOfItems(inSection: sec) {
                calcItemInfo(with: MakeIndex(row, sec), isUseSectionHeader: &useHeader, model: infoModel)
            }
            
            // footer
            calcFooterInfo(with: sec, model: infoModel)
        }
        
        maxContentHeight = infoModel.bottoms.max().or(infoModel.itemY - minimumLineSpacing) + sectionInset.bottom
        if scrollDirection == .horizontal {
            maxContentWidth += sectionInset.right
        } else {
            maxContentWidth = collect.width - sectionInset.right - sectionInset.left
        }
    }
    
    /// 计算头部布局信息
    private func calcHeaderInfo(with section: Int, model infoModel: CalcInfoModel) -> Bool {
        if section != 0 {
            infoModel.itemY = infoModel.itemY + sectionSpacing // 加上两个 section 之间的距离
        }
        let hAttriInfo = setHeaderAttributes(with: section, offsetY: infoModel.itemY)
        if hAttriInfo.hasHeader {
            infoModel.itemX = sectionInset.left + hAttriInfo.frame.or(.zero).width
            infoModel.itemY = infoModel.itemY + hAttriInfo.frame.or(.zero).height + minimumLineSpacing
            infoModel.bottoms.append(infoModel.itemY - minimumLineSpacing)
        }
        return hAttriInfo.hasHeader
    }
    /// 计算item布局信息
    private func calcItemInfo(with index: IndexPath, isUseSectionHeader: inout Bool, model infoModel: CalcInfoModel) -> Void {
        
        let setSize = getSizeForItem(with: index)
        
        if infoModel.itemX + setSize.width <= infoModel.limitWidth {
            calcSameLine(model: infoModel, setSize: setSize)
        } else {
            calcNewLine(model: infoModel, setSize: setSize, useSectionHeader: &isUseSectionHeader)
        }
        setItemAttributes(with: index, fixFrame: MakeRect(infoModel.itemX, infoModel.itemY, setSize.width, setSize.height))
        
        infoModel.itemX = infoModel.itemX + setSize.width
        maxContentHeight = infoModel.bottoms.max().or(infoModel.itemY)
    }
    /// 计算换行时的item 布局信息
    private func calcNewLine(model infoModel: CalcInfoModel, setSize: CGSize, useSectionHeader: inout Bool) -> Void {
        if useSectionHeader {
            useSectionHeader.toggle()
            
            infoModel.itemY = infoModel.bottoms.last.or(0) + minimumLineSpacing
            
            infoModel.bottoms.removeAll()
            infoModel.previousBottoms.removeAll()
            infoModel.bottoms.append(infoModel.itemY + setSize.height)
        } else {
            if infoModel.bottoms.count == 0 {
                infoModel.itemY = infoModel.itemY + infoModel.previousSetSize.height + minimumLineSpacing
                infoModel.bottoms.append(infoModel.itemX + infoModel.previousSetSize.height)
            } else {
                infoModel.previousBottoms = infoModel.bottoms
                infoModel.bottoms.removeAll()
                
                if infoModel.previousBottoms.count > 0 {
                    infoModel.itemY = infoModel.previousBottoms.first! + minimumLineSpacing
                } else {
                    infoModel.itemY = minimumLineSpacing
                }
                infoModel.bottoms.append(infoModel.itemY + setSize.height)
            }
        }
        infoModel.itemX = sectionInset.left
        infoModel.currentLineCount = 0
    }
    /// 计算相同行时的item 布局信息
    private func calcSameLine(model infoModel: CalcInfoModel, setSize: CGSize) -> Void {
        infoModel.currentLineCount += 1
        
        infoModel.itemX = infoModel.itemX + self.minimumInteritemSpacing
        // if hasSectionHeader { itemX += self.minimumInteritemSpacing }
        
        if infoModel.previousBottoms.count > 0 {
            if infoModel.previousBottoms.count == 1 {
                infoModel.itemY = infoModel.previousBottoms.first! + minimumLineSpacing
            } else {
                if infoModel.currentLineCount > infoModel.previousBottoms.count - 1 {
                    while infoModel.currentLineCount > infoModel.previousBottoms.count - 1 {
                        infoModel.currentLineCount -= 1
                    }
                    infoModel.itemY = infoModel.previousBottoms[infoModel.currentLineCount] + minimumLineSpacing
                } else {
                    infoModel.itemY = infoModel.previousBottoms[infoModel.currentLineCount] + minimumLineSpacing
                }
            }
        }
        
        maxContentWidth += setSize.width
        infoModel.bottoms.append(infoModel.itemY + setSize.height)
    }
    /// 计算footer布局信息
    private func calcFooterInfo(with section: Int, model infoModel: CalcInfoModel) -> Void {
        infoModel.itemY = infoModel.bottoms.max().or(infoModel.itemY) + minimumLineSpacing
        let fAttriInfo = setFooterAttributes(with: section, offsetY: infoModel.itemY)
        if fAttriInfo.hasFooter {
            infoModel.itemX = sectionInset.left + fAttriInfo.frame.or(.zero).width
            infoModel.itemY = infoModel.itemY + fAttriInfo.frame.or(.zero).height + minimumLineSpacing
            infoModel.bottoms.append(infoModel.itemY - minimumLineSpacing)
        }
    }

}

// MARK:- Private
extension IWCollectionViewFlowLayout {
    
    private func getSizeForItem(with indexPath: IndexPath) -> CGSize {
        guard let _dg = delegate else {
            guard itemSize.isEmpty else { return itemSize }
            fatalError("需要实现(IWCollectionViewFlowLayoutDelegate) 协议或者设置 itemSize.")
        }
        if _dg.responds(to: #selector(_dg.collectionView(_:layout:sizeForItemAt:))) {
            return _dg.collectionView!(collectionView!, layout: self, sizeForItemAt: indexPath)
        }
        return itemSize
    }
    
    private func getHeaderSize(with section: Int) -> CGSize {
        guard let _dg = delegate else {
            guard headerReferenceSize.isEmpty else { return headerReferenceSize }
            fatalError("需要实现(IWCollectionViewFlowLayoutDelegate) 协议或者设置 headerReferenceSize.")
        }
        if _dg.responds(to: #selector(_dg.collectionView(_:layout:referenceSizeForHeaderInSection:))) {
            return _dg.collectionView!(collectionView!, layout: self, referenceSizeForHeaderInSection: section)
        }
        return headerReferenceSize
    }
    
    private func getFooterSize(with section: Int) -> CGSize {
        guard let _dg = delegate else {
            guard footerReferenceSize.isEmpty else {
                return footerReferenceSize
            }
            fatalError("需要实现(IWCollectionViewFlowLayoutDelegate) 协议或者设置 footerReferenceSize.")
        }
        if _dg.responds(to: #selector(_dg.collectionView(_:layout:referenceSizeForFooterInSection:))) {
            return _dg.collectionView!(collectionView!, layout: self, referenceSizeForFooterInSection: section)
        }
        return footerReferenceSize
    }
    
    /// (返回是否含设置成功).
    private func setHeaderAttributes(with section: Int, offsetY: CGFloat) -> SetAttributesInfo {
        
        let index = MakeIndex(0, section)
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: index)
        
        let dgSize = getHeaderSize(with: section)
        
        if dgSize.height > 0 {
            
            var fixFrame = headerReferenceSize.toRect
            ifc(dgSize.height > 0, fixFrame = dgSize.toRect)
            fixFrame.origin.x = sectionInset.left
            fixFrame.origin.y = offsetY
            setAttributesFrame(with: attributes, fixFrame: fixFrame)
            
            let save = [index: attributes]
            itemAttributes.append(save)
            
            return SetAttributesInfo(indexPath: index, header: true, footer: false, frame: fixFrame)
        }
        return SetAttributesInfo(indexPath: nil, header: false, footer: false, frame: nil)
    }
    
    private func setItemAttributes(with index: IndexPath, fixFrame: CGRect) -> Void {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: index)
        setAttributesFrame(with: attributes, fixFrame: fixFrame)
        
        let save = [index: attributes]
        itemAttributes.append(save)
    }
    
    /// (返回是否含设置成功).
    private func setFooterAttributes(with section: Int, offsetY: CGFloat) -> SetAttributesInfo {
        let index = MakeIndex(0, section)
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, with: index)
        let dgSize = getFooterSize(with: section)
        
        if dgSize.height > 0 {
            
            var fixFrame = footerReferenceSize.toRect
            ifc(dgSize.height > 0, fixFrame = dgSize.toRect)
            fixFrame.origin.x = sectionInset.left
            fixFrame.origin.y = offsetY // + itemAttributes.last!.values.first!.frame.height
            setAttributesFrame(with: attributes, fixFrame: fixFrame)
            
            let save = [index: attributes]
            itemAttributes.append(save)
            
            return SetAttributesInfo(indexPath: index, header: false, footer: true, frame: fixFrame)
        }
        return SetAttributesInfo(indexPath: nil, header: false, footer: false, frame: nil)
    }
    
    private func setAttributesFrame(with attributes: UICollectionViewLayoutAttributes, fixFrame: CGRect) -> Void {
        attributes.frame = fixFrame
    }
    
}

#endif
