//
//  IWWaveLoadingView.swift
//  IWExtensionDemo
//
//  Created by iWw on 24/01/2018.
//  Copyright © 2018 iWe. All rights reserved.
//
#if os(iOS)
import UIKit

public class IWWaveLoadingView: UIView {
    
    public enum MaskViewType {
        case light       // 亮色
        case dark        // 暗色
        case transparent // 透明
        case none        // 不使用遮照
    }
    
    static let shared: IWWaveLoadingView = {
        return IWWaveLoadingView(frame: MakeRect(0, .screenHeight - .tabbarHeight, .screenWidth, 24))
    }()
    
    /// 振幅
    private var amplitude: CGFloat = 0
    /// 周期
    private var cycle: CGFloat = 0
    /// 速度
    private var speed: CGFloat = 0
    private var speed2: CGFloat = 0
    
    private var pointY: CGFloat = 0
    /// 波浪x位移
    private var offsetX: CGFloat = 0
    
    /// 波形宽度
    private var waveWidth: CGFloat = 0
    /// 波形高度
    private var waveHeight: CGFloat = 0
    
    private lazy var otherMaskView: UIView = {
        return UIView()
    }()
    
    private lazy var firstWaveLayer: CAShapeLayer = {
        let layer = CAShapeLayer.init()
        layer.fillColor = UIColor.hex("#0096B3").alpha(0.4).cgColor
        return layer
    }()
    private var secondWaveLayer: CAShapeLayer = {
        let layer = CAShapeLayer.init()
        layer.fillColor = UIColor.hex("#8FEDFF").alpha(0.6).cgColor
        return layer
    }()
    private var thirdWaveLayer: CAShapeLayer = {
        let layer = CAShapeLayer.init()
        layer.fillColor = UIColor.hex("#35DEFF").alpha(0.2).cgColor
        return layer
    }()
    
    /// 定时器
    private lazy var displayLink: CADisplayLink = { [unowned self] in
        return CADisplayLink.init(target: self, selector: #selector(refreshWave))
    }()
    
    /// 帧刷新事件
    @objc func refreshWave() -> Void {
        offsetX -= speed
        
        self.setFirstWaveLayerPath()
        self.setSecondWaveLayerPath()
        self.setThirdWaveLayerPath()
    }
    
    /// 设置第一个layer动画
    private func setFirstWaveLayerPath() -> Void {
        let path = CGMutablePath()
        var py = pointY
        path.move(to: MakePoint(0, py))
        for i in 0 ... Int(waveWidth) {
            py = amplitude * sin(cycle * CGFloat(i) + offsetX - 10) + pointY + 3
            path.addLine(to: MakePoint(CGFloat(i), py))
        }
        path.addLine(to: MakePoint(waveWidth, self.height))
        path.addLine(to: MakePoint(0, self.height))
        path.closeSubpath()
        
        firstWaveLayer.path = path
    }
    /// 设置第二个layer动画
    private func setSecondWaveLayerPath() -> Void {
        let path = CGMutablePath()
        var py = pointY
        path.move(to: MakePoint(0, py))
        for i in 0 ... Int(waveWidth) {
            py = amplitude * sin(cycle * CGFloat(i) + offsetX) + pointY
            path.addLine(to: MakePoint(CGFloat(i), py))
        }
        path.addLine(to: MakePoint(waveWidth, self.height))
        path.addLine(to: MakePoint(0, self.height))
        path.closeSubpath()
        
        secondWaveLayer.path = path
    }
    /// 设置第三个layer动画
    private func setThirdWaveLayerPath() -> Void {
        let path = CGMutablePath()
        var py = pointY
        path.move(to: MakePoint(0, py))
        for i in 0 ... Int(waveWidth) {
            py = amplitude * sin(cycle * CGFloat(i) + offsetX + 20) + pointY - 8
            path.addLine(to: MakePoint(CGFloat(i), py))
        }
        path.addLine(to: MakePoint(waveWidth, self.height))
        path.addLine(to: MakePoint(0, self.height))
        path.closeSubpath()
        
        thirdWaveLayer.path = path
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //self.backgroundColor = UIColor.init(red: 251/255, green: 91/255, blue: 91/255, alpha: 1)
        self.layer.masksToBounds = true
        
        self.configParams()
        
        displayLink.add(to: .main, forMode: .commonModes)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 配置参数
    private func configParams() -> Void {
        waveWidth = self.width
        waveHeight = self.height
        
        speed = CGFloat(0.10 / Double.pi)
        
        offsetX = 0
        pointY = max((waveHeight / 2) - (waveHeight / 3), waveHeight / 2, waveHeight / 3)
        amplitude = self.height / 10 + 2
        cycle = CGFloat(1.42 * Double.pi) / waveWidth
    }
    /// 开始动画
    public func startWave(_ addTo: UIViewController? = nil, useMask: Bool = false, maskType: MaskViewType = .dark) -> Void {
        addTo.unwrapped ({ (vc) in
            self.alpha = 0
            self.y = .screenHeight - .tabbarHeight
            IWDevice.isiPhoneX.and({ !iw.isTabbarExists }).founded({
                self.height = 24 + .bottomSpacing
            })
            
            vc.view.addSubview(self)
            
            if useMask {
                otherMaskView.frame = vc.view.bounds
                switch maskType {
                case .light:
                    otherMaskView.backgroundColor = UIColor.white.alpha(0.4)
                case .dark:
                    otherMaskView.backgroundColor = UIColor.iwe_tinyBlack.alpha(0.05)
                case .transparent:
                    otherMaskView.backgroundColor = .clear
                default: break
                }
                vc.view.addSubview(otherMaskView)
            }
        })
        
        self.layer.addSublayer(firstWaveLayer)
        self.layer.addSublayer(secondWaveLayer)
        self.layer.addSublayer(thirdWaveLayer)
        
        UIView.IWE.animation(0.5, {
            self.alpha = 1
            self.y = .screenHeight - .tabbarHeight - self.height
        }, nil)
        
        self.displayLink.isPaused = false
    }
    
    /// 结束动画
    public func stopWave() -> Void {
        UIView.IWE.animation(0.3, {
            self.alpha = 0
            self.y = .screenHeight - .tabbarHeight
        }) { (finished) in
            self.firstWaveLayer.removeAllAnimations()
            self.secondWaveLayer.removeAllAnimations()
            self.thirdWaveLayer.removeAllAnimations()
            
            self.firstWaveLayer.removeFromSuperlayer()
            self.secondWaveLayer.removeFromSuperlayer()
            self.thirdWaveLayer.removeFromSuperlayer()
            
            self.otherMaskView.removeFromSuperview()
            self.layer.removeAllAnimations()
            
            self.displayLink.isPaused = true
            
            self.removeFromSuperview()
        }
    }
}
#endif
