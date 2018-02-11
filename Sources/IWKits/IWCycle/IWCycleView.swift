//  Created by iWe on 2017/7/7.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

/// (轮播图类).
public class IWCycleView: UIView {
    
    public enum IWCycleViewPageControlStyle {
        case middle
        case left
        case right
    }
    
    fileprivate var scrollView: UIScrollView = UIScrollView()
    
    public final var page: UIPageControl {
        get { return pageControl }
    }
    
    // 图片数组(url 或者 本地图片名称, 规则: 若未检测到包含 http https ftp 则判定为本地图片名称)
    fileprivate var images: [Any] = [Any]()
    
    // 图片总数量, 交给imagesSetter进行设置
    fileprivate var imagesCount: Int = 0
    
    fileprivate var pageControl: UIPageControl = UIPageControl()
    public var pageControlStyle: IWCycleViewPageControlStyle = .middle
    
    // Image view
    fileprivate var leftIMGV: UIImageView = UIImageView()
    fileprivate var rightIMGV: UIImageView = UIImageView()
    fileprivate var middleIMGV: UIImageView = UIImageView()
    
    /// 当前index
    fileprivate var currentIndex: Int = 1
    
    public typealias IWCycleViewClickHandler = (_: Int, _: String) -> Void
    public var clickAction: IWCycleViewClickHandler?
    
    /// Page control height误差, 用于修正page control 的位置
    let pageControlCriticalHeight: Int = 24
    /// scrollView 滚动误差
    let scrollViewCirticalValue: CGFloat = 0.5
    /// 自动滚动延时
    public var displayTime: Float = 3.0
    /// page control 距离底部的距离
    public var distanceOfPageControlBottom: CGFloat = 0 {
        didSet { iw.main.execution { self.refreshDistanceOfPageControlBottom() } }
    }
    
    /// (image view 显示模式, 默认为 .redraw).
    public var imagesContentMode: UIViewContentMode = .redraw {
        didSet {
            leftIMGV.contentMode = imagesContentMode
            rightIMGV.contentMode = imagesContentMode
            middleIMGV.contentMode = imagesContentMode
        }
    }
    
    /// 定时器, 自动滚动
    fileprivate var timer: Timer?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public init(_ frame: CGRect, images: [Any], pageControlStyle: IWCycleViewPageControlStyle, clickHandler: IWCycleViewClickHandler?) {
        super.init(frame: frame)
        self.config(images, clickHandler: clickHandler)
    }
    
    public func config(_ images: [Any], clickHandler: IWCycleViewClickHandler?) -> Void {
        self.layoutIfNeeded()
        setUpViews()
        imagesSetter(images)
        clickAction = clickHandler
        currentIndexSetter(0)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK:- Handler
extension IWCycleView {
    
    // 图片点击事件
    @objc func clickImage(_ tap: UITapGestureRecognizer) -> Void {
        let imageName = (images[currentIndex] as! NSString).lastPathComponent
        clickAction?(currentIndex, imageName)
    }
    
    // 刷新显示的图片
    func refreshDisplayImage() -> Void {
        scrollView.contentOffset = CGPoint(x: scrollView.width, y: 0)
    }
    
    // 计算当前index. scrollViewDidScroll 调用
    func calculateCurrentIndex() -> Void {
        if imagesCount > 0 {
            let pointX = scrollView.contentOffset.x
            if pointX > 2 * scrollView.width - scrollViewCirticalValue {
                // 右划
                currentIndexSetter((currentIndex + 1) % imagesCount)
            } else if pointX < scrollViewCirticalValue {
                // 左划
                currentIndexSetter((currentIndex + imagesCount - 1) % imagesCount)
            }
        }
    }
    
    // 定时器调用
    @objc func timerDidFired(_ t: Timer) -> Void {
        if scrollView.contentOffset.x < scrollView.width - scrollViewCirticalValue || scrollView.contentOffset.x > scrollView.width + scrollViewCirticalValue {
            refreshDisplayImage()
        }
        let newOffset = CGPoint(x: scrollView.contentOffset.x + scrollView.width, y: scrollView.contentOffset.y)
        self.scrollView.setContentOffset(newOffset, animated: true)
    }
    
}

extension IWCycleView: UIScrollViewDelegate {
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer?.fireDate = .distantFuture
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if imagesCount > 1 && displayTime > 0.0 {
            timer?.fireDate = .init(timeIntervalSinceNow: TimeInterval(displayTime))
        } else {
            timer?.fireDate = .distantFuture
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        calculateCurrentIndex()
    }
    
}

// MARK:- Property init and assignment
extension IWCycleView {
    
    func setUpViews() -> Void {
        setUpScrollView()
        setUpImageViews()
        setUpPageControl()
        refreshScrollView()
        setUpTimer()
    }
    
    func refreshScrollView() -> Void {
        
        let imgvWidth = width
        let imgvHeight = height
        
        leftIMGV.frame = CGRect(x: imgvWidth * 0, y: 0, width: imgvWidth, height: imgvHeight)
        rightIMGV.frame = CGRect(x: imgvWidth * 2, y: 0, width: imgvWidth, height: imgvHeight)
        middleIMGV.frame = CGRect(x: imgvWidth * 1, y: 0, width: imgvWidth, height: imgvHeight)
        scrollView.contentSize = CGSize(width: imgvWidth * 3, height: imgvHeight)
    }
    
    private func setUpScrollView() -> Void {
        scrollView.frame = bounds
        
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .white
        scrollView.delegate = self
        
        addSubview(scrollView)
    }
    
    private func setUpImageViews() -> Void {
        leftIMGV.contentMode = imagesContentMode
        rightIMGV.contentMode = leftIMGV.contentMode
        middleIMGV.contentMode = leftIMGV.contentMode
        
        middleIMGV.iwe.addTapGesture(target: self, action: #selector(clickImage(_:)))
        
        scrollView.addSubview(leftIMGV)
        scrollView.addSubview(rightIMGV)
        scrollView.addSubview(middleIMGV)
    }
    
    private func setUpPageControl() -> Void {
        pageControl.y = height - pageControl.minimumHeight
        pageControl.hidesForSinglePage = true
        addSubview(pageControl)
    }
    
    private func setUpTimer() -> Void {
        
        let _ = iw.delay.execution(delay: TimeInterval(displayTime <= 0 ? 3.0 : displayTime)) {
            if self.timer == nil {
                self.timer = IWTimer.timer(TimeInterval(self.displayTime <= 0 ? 3.0 : self.displayTime), target: self, action: #selector(self.timerDidFired(_:)), userInfo: nil, repeats: true)
            }
            self.timer!.fireDate = .distantPast
        }
    }
    
    func pageControlPagesSetter(_ newValue: Int) -> Void {
        
        pageControl.numberOfPages = newValue >= 0 ? newValue : 0
        pageControlStyleSetter(pageControlStyle)
    }
    
    func pageControlStyleSetter(_ newValue: IWCycleViewPageControlStyle) -> Void {
        switch newValue {
        case .middle:
            pageControl.x = (width - pageControl.width) / 2
        case .left:
            pageControl.x = 0
        case .right:
            pageControl.x = width - pageControl.width
        }
        pageControl.y = height - pageControl.minimumHeight
        pageControlStyle = newValue
    }
    
    func imagesSetter(_ newValue: [Any]) -> Void {
        if newValue.count > 0 {
            let tmp = NSMutableArray()
            for obj in newValue {
                if obj is String {
                    tmp.add(obj)
                }
            }
            images = tmp.copy() as! [Any]
            imagesCount = tmp.count
            pageControlPagesSetter(imagesCount)
        }
    }
    
    func currentIndexSetter(_ newValue: Int) -> Void {
        
        let prefixs = ["http:", "https:", "ftp:"]
        if newValue >= 0, imagesCount > 0 {
            currentIndex = newValue
            
            let leftIndex = (newValue + imagesCount - 1) % imagesCount
            let rightIndex = (newValue + 1) % imagesCount
            
            let leftValue = images[leftIndex] as! String
            let rightValue = images[rightIndex] as! String
            let middleValue = images[newValue] as! String
            
            if leftValue.hasPrefixEx(prefixs) {
                leftIMGV.iwe.image(source: leftValue)
            } else {
                leftIMGV.image = UIImage(named: leftValue)
            }
            
            if rightValue.hasPrefixEx(prefixs) {
                rightIMGV.iwe.image(source: rightValue)
            } else {
                rightIMGV.image = UIImage(named: rightValue)
            }
            
            if middleValue.hasPrefixEx(prefixs) {
                middleIMGV.iwe.image(source: middleValue)
            } else {
                middleIMGV.image = UIImage(named: middleValue)
            }
            
            refreshDisplayImage()
            pageControl.currentPage = newValue
        }
        
    }
    
    fileprivate func refreshDistanceOfPageControlBottom() {
        pageControl.y = height - pageControl.minimumHeight - distanceOfPageControlBottom
    }
    
}

