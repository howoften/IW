//  Created by iWw on 2018/8/3.
//  Copyright © 2018 iWe. All rights reserved.
//

#if os(iOS)
import UIKit
public typealias IWView = UIView

public extension IWView {
    
    enum InsertType {
        /// (在 ... 上面).
        case above
        /// (在 ... 下面).
        case below
    }
    
}

private struct IWViewKey {
    static var showDebugColorKey: Void?
}

// MARK:- General Variable
public extension IWView {
    
    var x: CGFloat {
        get { return self.frame.origin.x }
        set { self.frame.origin.x = newValue }
    }
    var y: CGFloat {
        get { return self.frame.origin.y }
        set { self.frame.origin.y = newValue }
    }
    
    var width: CGFloat {
        get { return self.frame.width }
        set { self.frame.size.width = newValue }
    }
    var height: CGFloat {
        get { return self.frame.height }
        set { self.frame.size.height = newValue }
    }
    
    var size: CGSize {
        get { return self.frame.size }
        set { self.frame.size = newValue }
    }
    
    var origin: CGPoint {
        get { return self.frame.origin }
        set { self.frame.origin = newValue }
    }
    
    var left: CGFloat {
        get { return self.frame.origin.x }
        set { self.frame.origin.x = newValue }
    }
    var right: CGFloat {
        get { return self.frame.origin.x + self.frame.size.width }
        set { self.frame.origin.x = newValue - self.frame.size.width }
    }
    
    /// (视图右边距离 superView 右边的距离).
    var absRight: CGFloat {
        get {
            guard let sv = self.superview else { return self.right }
            return sv.width - self.right
        }
        set {
            guard let sv = self.superview else { self.right = 0; return }
            self.right = sv.width - newValue }
    }
    
    var top: CGFloat {
        get { return self.frame.origin.y }
        set { self.frame.origin.y = newValue }
    }
    var bottom: CGFloat {
        get { return self.frame.origin.y + self.frame.size.height }
        set { self.frame.origin.y = newValue - self.frame.size.height }
    }
}

// MARK:- General Function
public extension IWView {
    
    /// Set round to view.
    /// (以宽度的一半为圆角值设置圆角).
    func round() -> Void {
        round(self.width / 2)
    }
    
    /// Set corner radius to view.
    /// (以 corner 为圆角值设置圆角).
    func round(_ corner: CGFloat) -> Void {
        layer.cornerRadius = corner
        #if os(macOS)
            layer.masksToBounds = true
        #else
            clipsToBounds = true
        #endif
    }
    
    /// Set border to view.
    /// (设置边框).
    func border(width: CGFloat, color: IWColor = .white) -> Void {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
    /// Add shadow, opacity default is 0.2.
    /// (设置阴影, 透明度默认为 0.2).
    func shadow(_ opacity: Float = 0.2) -> Void {
        shadow(opacity, radius: 5.0)
    }
    
    /// Set shadow to view.
    /// (设置阴影, 默认为黑色阴影, 透明度默认为0.2, 圆角为5).
    ///
    /// - Parameters:
    ///   - opacity: 透明度
    ///   - radius: 圆角
    func shadow(_ opacity: Float = 0.2, radius: CGFloat = 5.0) -> Void {
        shadow(color: .iwe_tinyBlack, opacity: opacity, radius: radius, size: MakeSize(0, 2))
    }
    
    /// Set shadow to view.
    /// (设置阴影).
    ///
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - opacity: 透明度
    ///   - radius: 圆角度
    ///   - size: 偏移位置
    func shadow(color: IWColor, opacity: Float, radius: CGFloat, size: CGSize) -> Void {
        #if os(macOS)
        guard let layer = layer else {
            _Warning("The view's layer is nil. Use `initliazeLayer()` to fix this warning.")
            return
        }
        #endif
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = size
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    
        layer.cornerRadius = radius
        #if os(macOS)
            layer.masksToBounds = true
        #else
            clipsToBounds = false
        #endif
    }
    
    /// iOS: (约束&填充到 superview, iOS6 及以后支持，iOS 9及以后使用 fillToSuperview).
    /// macOS: (填充约束至父视图).
    func fillConstraints() -> Void {
        guard let spv = superview else {
            return
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        let topC = NSLayoutConstraint.init(item: self, attribute: .top, relatedBy: .equal, toItem: spv, attribute: .top, multiplier: 1.0, constant: 0)
        let leftC = NSLayoutConstraint.init(item: self, attribute: .leading, relatedBy: .equal, toItem: spv, attribute: .leading, multiplier: 1.0, constant: 0)
        
        let rightC = NSLayoutConstraint.init(item: spv, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0)
        let bottomC = NSLayoutConstraint.init(item: spv, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        NSLayoutConstraint.activate([topC, leftC, rightC, bottomC])
    }
    
    /// (渐变色).
    func gradient(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) -> Void {
        #if os(macOS)
        guard let layer = layer else {
            _Warning("The view's layer is nil, Use `initializeLayer` fix this warning.")
            return
        }
        #endif
        let gradientLayers = layer.sublayers?.map({ (ly) -> CAGradientLayer? in
            if ly is CAGradientLayer {
                return ly as? CAGradientLayer
            }
            return nil
        })
        gradientLayers.unwrapped ({ (oldLayer) in
            oldLayer.forEach({ $0?.removeFromSuperlayer() })
        })
        
        let gradientColors = colors.map({ $0.cgColor })
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = self.bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    /// Add to view.
    /// (添加到某个视图, setToViewBounds 设置为父视图的bounds).
    func addTo(view: IWView?, setToViewBounds: Bool = false) -> Void {
        view?.addSubview(self)
        if setToViewBounds, let vb = view?.bounds {
            self.frame = vb
        }
    }
    
    /// Each subview in subviews.
    /// (遍历子视图).
    func eachSubview(_ handler: ((_ subview: IWView) -> Void)?) -> Void {
        guard let hd = handler else { return }
        subviews.forEach({ hd($0) })
    }
    
    
    /// Set random color.
    /// (是否显示 Debug 模式下的颜色).
    var showDebugColor: Bool {
        get { return (objc_getAssociatedObject(self, &IWViewKey.showDebugColorKey) as? Bool) ?? false }
        set {
            objc_setAssociatedObject(self, &IWViewKey.showDebugColorKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if newValue {
                subviews.forEach { (v) in
                    iw.queue.main { v.backgroundColor = self.debugColor }
                }
            }
        }
    }
    /// (随机设置一个颜色, 透明度为0.8).
    var debugColor: IWColor {
        return IWColor.random.alpha(0.8)
    }
    
    
    /// (移除所有子视图).
    func removeAllSubviews() {
        subviews.forEach({ $0.removeFromSuperview() })
        //for i in subviews { i.removeFromSuperview() }
    }
    /// (移除所有符合类型的子视图).
    func removeAllSubviews(with viewType: AnyClass) {
        subviews.forEach({ if $0.isKind(of: viewType) { $0.removeFromSuperview() } })
        //for sView in subviews { if sView.isKind(of: viewType) { sView.removeFromSuperview() } }
    }
}

#endif

#if os(macOS)
// MARK-: macOS IWView Variable
import Cocoa
public typealias IWView = NSView

// MARK-: macOS IWView Function
public extension IWView {
    
    /// (wantsLayer = true).
//    static func initliazeLayer() -> Void {
//        wantsLayer = true
//    }
    
    /// (从 xib 初始化视图).
    class func fromNib<T: IWView>() -> T? {
        var viewArray: NSArray? = NSArray()
        let nibName = String(describing: self)
        guard Bundle.main.loadNibNamed(NSNib.Name(rawValue: nibName), owner: nil, topLevelObjects: &viewArray) else { return nil }
        return viewArray!.first(where: { $0 is T }) as? T
    }
    
    /// (设置背景颜色).
    var bgColor: CGColor? {
        get { return self.layer?.backgroundColor }
        set { if (!self.wantsLayer) { self.wantsLayer = true }; self.layer?.backgroundColor = newValue }
    }
    
    
    
}

#else
// MARK-: unmacOS IWView Varliable

// MARK-: unmacOS IWView Function
public extension IWView {
    
    static var xib: UIView? {
        let path = _xibPath()
        if path != nil {
            let className = String(describing: self)
            let nib = UINib(nibName: className, bundle: nil).instantiate(withOwner: 0, options: nil).last
            if let nibFile = nib { return nibFile as? UIView }
        }
        return nil
    }
    private class func _xibPath() -> String? {
        let className = String(describing: self)
        let path = Bundle.main.path(forResource: className, ofType: ".nib")
        guard let filePath = path else { return nil }
        if FileManager.default.fileExists(atPath: filePath) { return filePath }
        
        return nil
    }
    
    /// (将 View 转换为 UIImage).
    var screenshot: IWImage? {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    /// (将 View 转换为 UIImage).
    var toUIImage: IWImage? {
        return screenshot
    }
    
    /// Set corner with RectCorner.
    /// (以宽度的一半为圆角值设置圆角).
    func round(_ size: CGSize, corners: UIRectCorner, radii: CGSize) -> Void {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let maskPath = UIBezierPath.init(roundedRect: rect, byRoundingCorners: corners, cornerRadii: radii)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = rect
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
    
    
    // Start ----------
    private struct SaveToAlbumKey {
        static var SavedCallBackKey: Void?
    }
    typealias SavedCallBack = ((_ image: UIImage, _ success: Bool, _ error: Error?) -> Void)
    private var saveToAlbumSavedCallBack: SavedCallBack? {
        get { return objc_getAssociatedObject(self, &SaveToAlbumKey.SavedCallBackKey) as? SavedCallBack }
        set { objc_setAssociatedObject(self, &SaveToAlbumKey.SavedCallBackKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    // (保存视图到相册, size 为 nil 时则为 view 的大小, 需要设置 Private - ).
    func saveToAlbum(withSize size: CGSize?, saved: SavedCallBack?) -> Void {
        UIGraphicsBeginImageContextWithOptions(size.or(self.frame.size), false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        self.layer.render(in: context)
        guard let img = UIGraphicsGetImageFromCurrentImageContext() else { return }
        UIGraphicsEndImageContext()
        saveToAlbumSavedCallBack = saved
        UIImageWriteToSavedPhotosAlbum(img, self, #selector(image(image:didFinishSavingWithError:contextinfo:)), nil)
    }
    @objc private func image(image: UIImage, didFinishSavingWithError error: Error?, contextinfo: Any?) {
        if error != nil {
            // 失败
            saveToAlbumSavedCallBack?(image, false, error)
        } else {
            saveToAlbumSavedCallBack?(image, true, error)
        }
        // 清空, 避免循环引用
        saveToAlbumSavedCallBack = nil
    }
    // Ended ----------
    
    
    /// [#测试功能].
    func insert(to view: UIView, type: InsertType = .above, autoConfigEdge: Bool = false) {
        if type == .above {
            view.superview?.insertSubview(self, aboveSubview: view)
        } else {
            view.superview?.insertSubview(self, belowSubview: view)
            if autoConfigEdge {
                if self is UIScrollView {
                    let convertFrame = view.convert(view.bounds, to: view.superview!)
                    let scrView = self as! UIScrollView
                    if #available(iOS 11.0, *) {
                        if scrView.contentInsetAdjustmentBehavior == .never {
                            scrView.contentInset = MakeEdge(convertFrame.origin.y + convertFrame.size.height, 0, 0, 0)
                            scrView.scrollIndicatorInsets = scrView.contentInset
                            return
                        }
                        scrView.contentInset = MakeEdge(convertFrame.size.height, 0, 0, 0)
                        scrView.scrollIndicatorInsets = scrView.contentInset
                    } else {
                        if let vc = UIViewController.current as? IWRootVC, !vc.automaticallyAdjustsScrollViewInsets {
                            scrView.contentInset = MakeEdge(convertFrame.origin.y + convertFrame.size.height, 0, 0, 0)
                            scrView.scrollIndicatorInsets = scrView.contentInset
                            return
                        }
                        scrView.contentInset = MakeEdge(convertFrame.size.height, 0, 0, 0)
                        scrView.scrollIndicatorInsets = scrView.contentInset
                    }
                    
                }
            }
        }
    }
    
    /// (约束&填充到 superview, iOS9 及以后支持).
    @available(iOS 9.0, *) func fillToSuperview() -> Void {
        translatesAutoresizingMaskIntoConstraints = false
        superview.unwrapped ({ (spv) in
            leftAnchor.constraint(equalTo: spv.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: spv.rightAnchor).isActive = true
            topAnchor.constraint(equalTo: spv.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: spv.bottomAnchor).isActive = true
        })
    }
    
    // Start ----------
    /// Touch/Tap Action with Block.
    /// (Block 点击事件).
    func whenTouches(numberOfTouches touches: Int, numberOfTapped taps: Int, handler: (() -> Void)?) -> Void {
        guard let hd = handler else { return }
        let gesture = UITapGestureRecognizer.iwe_recognizer(withHandler: { (sender, view, state, location) in
            if state == .possible { hd() }
        })
        
        if let tapGesture = gesture as? UITapGestureRecognizer {
            tapGesture.numberOfTouchesRequired = touches
            tapGesture.numberOfTapsRequired = taps
            
            if let recognizers = self.gestureRecognizers {
                for i in recognizers {
                    if !(i is UITapGestureRecognizer) { return }
                    let tap = i as! UITapGestureRecognizer
                    let rightTouches = (tap.numberOfTouchesRequired == touches)
                    let rightTaps = (tap.numberOfTapsRequired < taps)
                    if rightTouches && rightTaps { tap.require(toFail: tapGesture) }
                }
            }
            self.addGestureRecognizer(tapGesture)
        }
    }
    /// One Tap.
    /// (单击事件).
    func whenTapped(_ handler: @escaping () -> Void) -> Void {
        whenTouches(numberOfTouches: 1, numberOfTapped: 1, handler: handler)
    }
    /// Double Tap.
    /// (双击事件).
    func whenDoubleTapped(_ handler: @escaping () -> Void) -> Void {
        whenTouches(numberOfTouches: 1, numberOfTapped: 2, handler: handler)
    }
    // Ended ----------
    
    /// in viewController / Top viewController?
    /// (当前显示的 viewController).
    var viewController: UIViewController? {
        return UIViewController.current
    }
    
    /// Set BackgorundColor.
    /// (设置背景颜色).
    func bgColor(_ color: UIColor) {
        backgroundColor = color
    }
    
    /// is Private view?
    /// (是否为私有 View).
    var isUIKitprivateView: Bool {
        if self is UIWindow {
            return true
        }
        var isPrivate = false
        let classString = String(describing: self)
        for value in ["LayoutContainer", "NavigationItemButton", "NavigationItemView", "SelectionGrabber", "InputViewContent"] {
            if classString.hasPrefix("UI") || classString.hasPrefix("_UI") && classString.contains(value) {
                isPrivate = true
                break
            }
        }
        return isPrivate
    }
    
    
    class func animation(_ time: TimeInterval, _ animate: @escaping () -> Void, _ finished: ((Bool) -> Void)?)  -> Void {
        UIView.animate(withDuration: time, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.8, options: [.curveEaseOut, .allowUserInteraction], animations: animate, completion: finished)
    }
    
    /// Add tap action.
    /// (添加点击事件).
    func addTapGesture(_ count: Int = 1, target: Any?, action: Selector?) -> Void {
        isUserInteractionEnabled.isFalse.founded({ isUserInteractionEnabled.toTrue() })
        let tap = UITapGestureRecognizer.init(target: target, action: action)
        tap.numberOfTapsRequired = count
        addGestureRecognizer(tap)
    }
    
}

#endif
