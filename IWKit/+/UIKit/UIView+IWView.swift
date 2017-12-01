//
//  IWButton.swift
//  haoduobaduo
//
//  Created by iWe on 2017/8/15.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit

extension IWView where View: UIView {
    
    /// Set round to view.
    final func round() -> Void {
        round(self.view.width / 2)
    }
    
    /// Set corner radius to view.
    final func round(_ corner: CGFloat) -> Void {
        view.layer.cornerRadius = corner
        view.clipsToBounds = true
    }
    
    /// Set corner with RectCorner.
    final func round(_ size: CGSize, corners: UIRectCorner, radii: CGSize) -> Void {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let maskPath = UIBezierPath.init(roundedRect: rect, byRoundingCorners: corners, cornerRadii: radii)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = rect
        maskLayer.path = maskPath.cgPath
        view.layer.mask = maskLayer
    }
    
    /// Set border to view.
    final func border(width: CGFloat, color: UIColor = .white) -> Void {
        view.layer.borderWidth = width
        view.layer.borderColor = color.cgColor
    }
    
    final func shadow(_ opacity: Float = 0.2) -> Void {
        shadow(opacity, radius: 5.0)
    }
    
    /// Set shadow to view.
    /// -opacity: Alpha
    /// -radius: Radius
    final func shadow(_ opacity: Float = 0.2, radius: CGFloat = 5.0) -> Void {
        shadow(color: .iwe_tinyBlack, opacity: opacity, radius: radius, size: MakeSize(0, 2))
    }
    
    final func shadow(color: UIColor, opacity: Float, radius: CGFloat, size: CGSize) -> Void {
        view.layer.shadowColor = color.cgColor
        view.layer.shadowOpacity = opacity
        view.layer.shadowOffset = size
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        
        view.layer.cornerRadius = radius
        view.clipsToBounds = false
    }
    
    /*
    static var xib: UIView {
        let path = xibPath()
        if path != nil {
            let className = String(describing: self)
            let nib = UINib(nibName: className, bundle: nil).instantiate(withOwner: 0, options: nil).last
            if let nibFile = nib {
                return nibFile as! UIView
            }
        }
        return UIView()
    }
    */
    
    final var viewController: UIViewController? {
        return UIViewController.IWE.current()
    }
	
	final func addTo(view: UIView?) {
		view?.addSubview(self.view)
	}
    
    final func addTapGesture(_ count: Int = 1, target: Any?, action: Selector?) -> Void {
        if view.isUserInteractionEnabled == false { view.isUserInteractionEnabled = true }
        let tap = UITapGestureRecognizer.init(target: target, action: action)
        tap.numberOfTapsRequired = count
        view.addGestureRecognizer(tap)
    }
    
    final func removeAllSubviews() {
        for sView in view.subviews { sView.removeFromSuperview() }
    }
    
    final func removeAllSubviews(with viewType: AnyClass) {
        for sView in view.subviews { if sView.isKind(of: viewType) { sView.removeFromSuperview() } }
    }
	
	final class func animation(_ time: TimeInterval, _ animate: @escaping () -> Void, _ finished: ((Bool) -> Void)?)  -> Void {
		UIView.animate(withDuration: time, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.8, options: [.curveEaseOut, .allowUserInteraction], animations: animate, completion: finished)
	}
	
	final func bgColor(_ color: UIColor) {
		view.backgroundColor = color
	}
    
    final func whenTouches(numberOfTouches touches: Int, numberOfTapped taps: Int, handler: (() -> Void)?) -> Void {
        guard let hd = handler else { return }
        let gesture = UITapGestureRecognizer.recognizer(withHandler: { (sender, view, state, location) in
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
    
    final func whenTapped(_ handler: @escaping () -> Void) -> Void {
        whenTouches(numberOfTouches: 1, numberOfTapped: 1, handler: handler)
    }
    
    final func whenDoubleTapped(_ handler: @escaping () -> Void) -> Void {
        whenTouches(numberOfTouches: 1, numberOfTapped: 2, handler: handler)
    }
    
    final func eachSubview(_ handler: ((_ subview: UIView) -> Void)?) -> Void {
        guard let hd = handler else { return }
        for i in self.view.subviews { hd(i) }
    }
    
}


