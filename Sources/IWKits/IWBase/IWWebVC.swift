//  Created by iWe on 2017/9/20.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore

fileprivate let kEstimatedProgress = "estimatedProgress"

open class IWWebVC: IWSubVC {
    
    public var web: IWWebView!
    public var progressView: UIProgressView!
    
    public enum Style {
        case `default`
        case mini
    }
    
    /// WebView 显示的样式
    public var style: Style = .default
    
    public var requestURLString: String?
    
    /// 当前是否显示了工具栏
    private var isShowActionTools: Bool = false
    /// 工具栏
    private lazy var actionToolsView: UIView = { [unowned self] in
        let v = UIView()
        v.backgroundColor = UIColor.white
        return v
    }()
    
    lazy var statusBackgroundView: UIView = self.initStatusBackgroundView()
    lazy var statusBackItem: IWStatusBackItem = { [unowned self] in
        let bi = IWStatusBackItem(tips: "返回", tapHandler: { [weak self] in
            self?.hide()
        })
        return bi
    }()
    private var hostInfoLabel: UILabel = UILabel()
    
    public typealias NavigationHandler = ((_ webView: IWWebView, _ navigation: WKNavigation?) -> Void)
    
    private var didStartHandler: NavigationHandler?
    private var loadFinishedHandler: NavigationHandler?
    
    /// (开始加载回调).
    public func setDidStart(_ handler: NavigationHandler?) -> Void {
        self.didStartHandler = handler
    }
    /// (加载完毕回调).
    public func setLoadFinished(_ handler: NavigationHandler?) -> Void {
        self.loadFinishedHandler = handler
    }
    
    /// (推荐初始化方式).
    convenience init(url: String, style: Style = .default) {
        self.init()
        self.requestURLString = url
        self.style = style
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        initUserInterface()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        web.stopLoading()
    }
    
    deinit {
        web.removeObserver(self, forKeyPath: kEstimatedProgress)
    }
    
    open override func initUserInterface() {
        
        navTitle = "正在加载..."
        
        setupWebView()
        setupProgressView()
        
        if style == .default {
            showDefaultStyle()
        } else if style == .mini {
            showMiniStyle()
        }
        
        requestURLString?.toURLRequest.unwrapped({ web.load($0) })
    }
    
    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension IWWebVC {
    
    fileprivate func setupWebView() -> Void {
        web = IWWebView()
        web.navigationDelegate = self
        web.uiDelegate = self
        showBackgroundColor()
        view.addSubview(web)
        
        web.translatesAutoresizingMaskIntoConstraints = false
        // Add layout
        let topConstraint = NSLayoutConstraint.init(item: web, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0)
        let leftConstraint = NSLayoutConstraint.init(item: web, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0)
        let rightConstraint = NSLayoutConstraint.init(item: self.view, attribute: .trailing, relatedBy: .equal, toItem: web, attribute: .trailing, multiplier: 1.0, constant: 0)
        let bottomConstraint = NSLayoutConstraint.init(item: self.view, attribute: .bottom, relatedBy: .equal, toItem: web, attribute: .bottom, multiplier: 1.0, constant: 0)
        NSLayoutConstraint.activate([topConstraint, leftConstraint, rightConstraint, bottomConstraint])
        
        // Add observer
        web.addObserver(self, forKeyPath: kEstimatedProgress, options: .new, context: nil)
        
        if iw.system.version.toDouble < 11.0 {
            web.scrollView.iwe.bothInsets = MakeEdge(.navBarHeight, 0, 0, 0)
        }
        
        // Add show action gesture
//        let screenEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(showActionTools(_:)))
//        screenEdgeGesture.edges = .right
//        web.addGestureRecognizer(screenEdgeGesture)
    }
    
    // MARK:- 显示工具栏
    /// 显示工具栏
    @objc private func showActionTools(_ gesture: UIScreenEdgePanGestureRecognizer) -> Void {
        
    }
    
    fileprivate func setupProgressView() -> Void {
        progressView = UIProgressView()
        progressView.trackTintColor = view.backgroundColor
        progressView.progressTintColor = .black
        progressView.progress = 0
        view.addSubview(progressView)
        
        self.progressView.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = NSLayoutConstraint.init(item: progressView, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 0)
        let leftConstraint = NSLayoutConstraint.init(item: progressView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0)
        let rightConstraint = NSLayoutConstraint.init(item: self.view, attribute: .trailing, relatedBy: .equal, toItem: progressView, attribute: .trailing, multiplier: 1.0, constant: 0)
        let heightConstraint = NSLayoutConstraint.init(item: progressView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 2)
        NSLayoutConstraint.activate([topConstraint, leftConstraint, rightConstraint, heightConstraint])
    }
    
    fileprivate func setupHostInfoLabel() -> Void {
        hostInfoLabel.numberOfLines = 1
        hostInfoLabel.font = UIFont.init(name: "Menlo-Regular", size: 12)
        hostInfoLabel.textColor = "#a9a9a9".toColor
        hostInfoLabel.textAlignment = .center
        hostInfoLabel.isHidden = true
        view.insertSubview(hostInfoLabel, at: 0)
        
        hostInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = NSLayoutConstraint.init(item: hostInfoLabel, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 20)
        let leftConstraint = NSLayoutConstraint.init(item: hostInfoLabel, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0)
        let rightConstraint = NSLayoutConstraint.init(item: self.view, attribute: .trailing, relatedBy: .equal, toItem: hostInfoLabel, attribute: .trailing, multiplier: 1.0, constant: 0)
        let heightConstraint = NSLayoutConstraint.init(item: hostInfoLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 18)
        NSLayoutConstraint.activate([topConstraint, leftConstraint, rightConstraint, heightConstraint])
    }
    
    fileprivate func initStatusBackgroundView() -> UIView {
        return IWStatus.bgView()
    }
    
    fileprivate func showDefaultStyle() -> Void {
        //progressView.top = iwe.navigationBarHeight
        // add host info label
        setupHostInfoLabel()
    }
    
    fileprivate func showMiniStyle() -> Void {
        // add back item to status
        statusBackItem.show()
        
        // reset host info label's frame
        hostInfoLabel.y = .navBarHeight
        
        // hide navigation bar
        iwe.hideNavigationBar()
        
        // add status background view
        statusBackgroundView.backgroundColor = view.backgroundColor
        view.addSubview(statusBackgroundView)
        
        // reset progress view
        progressView.top = statusBackgroundView.bottom
        
        // reset edge insets
        if iw.system.version.toDouble < 11.0 {
            web.scrollView.iwe.autoSetEdge(view)
        }
        
        // add host info label
        setupHostInfoLabel()
    }
    
    fileprivate func hide() -> Void {
        iwe.showNavigationBar()
        iwe.pop()
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            self.statusBackItem.alpha = 0
        }) { (finished) in
            self.statusBackItem.tapHandler = nil
            self.statusBackItem.removeFromSuperview()
        }
    }
    
    // (处理进度条事件).
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == kEstimatedProgress {
            // Progress
            let newProgress = Float(web.estimatedProgress)
            if newProgress >= 1.0 {
                progressView.setProgress(1.0, animated: true)
                
                iw.delay.execution(delay: 1.0, toRun: {
                    self.progressView.isHidden = true
                    self.progressView.setProgress(0, animated: false)
                })
                return
            }
            
            progressView.isHidden = false
            progressView.setProgress(newProgress, animated: true)
        }
    }
}

extension IWWebVC: WKNavigationDelegate, WKUIDelegate {
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        iPrint("网页 (\(webView.url!.absoluteString)) 开始加载.")
        
        if webView.url!.absoluteString == "about:blank" {
            return
        }
        
        // add background color, until did finish clear
        showBackgroundColor()
        
        if let host = webView.url?.host {
            hostInfoLabel.text = "该网页由 \(host) 提供"
        } else {
            hostInfoLabel.text = "未能识别此域名"
        }
        // start handler
        didStartHandler?(web, navigation)
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        iPrint("网页 (\(webView.url!.absoluteString)) 加载完成.")
        
        // set navigation bar title
        navTitle = webView.title
        
        // Handler background color
        hideBackgroundColor()
        
        // load finished
        loadFinishedHandler?(web, navigation)
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // 处理新建标签页
        navigationAction.targetFrame.on(none: { webView.load(navigationAction.request) })
        decisionHandler(.allow)
    }
}

extension IWWebVC {
    
    fileprivate func hideBackgroundColor() -> Void {
        web.backgroundColor = .clear
        web.iwe.wkContentView?.backgroundColor = .clear
        iw.delay.execution(delay: 0.5) {
            self.hostInfoLabel.isHidden = false
        }
    }
    
    fileprivate func showBackgroundColor() -> Void {
        hostInfoLabel.isHidden = true
        web.backgroundColor = .white
        web.iwe.wkContentView?.backgroundColor = .white
    }
}

// MARK:- Alert
extension IWWebVC {
    
    //Alert弹框
    open func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "好的", style: .cancel) { (_) in
            completionHandler()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //confirm弹框
    open func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .default) { (_) in
            completionHandler(true)
        }
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (_) in
            completionHandler(false)
        }
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    //TextInput弹框
    open func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        alert.addTextField { (_) in}
        let action = UIAlertAction(title: "确定", style: .default) { (_) in
            completionHandler(alert.textFields?.last?.text)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

