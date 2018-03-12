//  Created by iWe on 2017/8/15.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

private struct IWViewKey {
    static var showDebugColorKey: Void?
}

public extension IWView where View: UIView {
    
    /// Set round to view.
    /// (以宽度/2为圆角值设置圆角).
    func round() -> Void {
        round(self.view.width / 2)
    }
    
    /// Set corner radius to view.
    /// (以corner为圆角值设置圆角).
    func round(_ corner: CGFloat) -> Void {
        view.layer.cornerRadius = corner
        view.clipsToBounds = true
    }
    
    /// Set corner with RectCorner.
    /// (以宽度/2为圆角值设置圆角).
    func round(_ size: CGSize, corners: UIRectCorner, radii: CGSize) -> Void {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let maskPath = UIBezierPath.init(roundedRect: rect, byRoundingCorners: corners, cornerRadii: radii)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = rect
        maskLayer.path = maskPath.cgPath
        view.layer.mask = maskLayer
    }
    
    /// Set border to view.
    /// (设置边框).
    func border(width: CGFloat, color: UIColor = .white) -> Void {
        view.layer.borderWidth = width
        view.layer.borderColor = color.cgColor
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
    func shadow(color: UIColor, opacity: Float, radius: CGFloat, size: CGSize) -> Void {
        view.layer.shadowColor = color.cgColor
        view.layer.shadowOpacity = opacity
        view.layer.shadowOffset = size
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        
        view.layer.cornerRadius = radius
        view.clipsToBounds = false
    }
    
    /// in viewController / Top viewController?
    /// (当前显示的 viewController).
    var viewController: UIViewController? {
        return UIViewController.IWE.current()
    }
    
    /// Add to view.
    /// (添加到某个视图, setToViewBounds 设置为父视图的bounds).
    func addTo(view: UIView?, setToViewBounds: Bool = false) -> Void {
        view?.addSubview(self.view)
        if setToViewBounds, let vb = view?.bounds {
            self.view.frame = vb
        }
    }
    
    /// Add tap action.
    /// (添加点击事件).
    func addTapGesture(_ count: Int = 1, target: Any?, action: Selector?) -> Void {
        if view.isUserInteractionEnabled == false { view.isUserInteractionEnabled = true }
        let tap = UITapGestureRecognizer.init(target: target, action: action)
        tap.numberOfTapsRequired = count
        view.addGestureRecognizer(tap)
    }
    
    func removeAllSubviews() {
        for sView in view.subviews { sView.removeFromSuperview() }
    }
    
    func removeAllSubviews(with viewType: AnyClass) {
        for sView in view.subviews { if sView.isKind(of: viewType) { sView.removeFromSuperview() } }
    }
    
    /// is Private view?
    /// (是否为私有 View).
    var isUIKitprivateView: Bool {
        if view is UIWindow {
            return true
        }
        var isPrivate = false
        let classString = String(describing: self.view)
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
    
    /// Set BackgorundColor.
    /// (设置背景颜色).
    func bgColor(_ color: UIColor) {
        view.backgroundColor = color
    }
    
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
            
            if let recognizers = self.view.gestureRecognizers {
                for i in recognizers {
                    if !(i is UITapGestureRecognizer) { return }
                    let tap = i as! UITapGestureRecognizer
                    let rightTouches = (tap.numberOfTouchesRequired == touches)
                    let rightTaps = (tap.numberOfTapsRequired < taps)
                    if rightTouches && rightTaps { tap.require(toFail: tapGesture) }
                }
            }
            self.view.addGestureRecognizer(tapGesture)
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
    
    /// Each subview in subviews.
    /// (遍历子视图).
    func eachSubview(_ handler: ((_ subview: UIView) -> Void)?) -> Void {
        guard let hd = handler else { return }
        for i in self.view.subviews { hd(i) }
    }
    
    /// Set random color.
    /// (是否显示 Debug 模式下的颜色).
    var showDebugColor: Bool {
        get { return (objc_getAssociatedObject(self, &IWViewKey.showDebugColorKey) as? Bool) ?? false }
        set {
            objc_setAssociatedObject(self, &IWViewKey.showDebugColorKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if newValue {
                self.view.subviews.forEach({ (v) in
                    iw.queue.main { v.backgroundColor = self.debugColor }
                })
            }
        }
    }
    /// (随机设置一个颜色, 透明度为0.8).
    private var debugColor: UIColor {
        return UIColor.IWE.randomColor.alpha(0.8)
    }
    
    func gradient(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) -> Void {
        let gradientLayers = self.view.layer.sublayers?.map({ (layer) -> CAGradientLayer? in
            if layer is CAGradientLayer {
                return layer as? CAGradientLayer
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
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}

