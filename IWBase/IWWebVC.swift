//
//  IWWebVC.swift
//  haoduobaduo
//
//  Created by iWe on 2017/9/20.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore

fileprivate let kEstimatedProgress = "estimatedProgress"

class IWWebVC: IWRootVC {
	
	var web: IWWebView!
	var progressView: UIProgressView!
	
	enum Style {
		case `default`
		case mini
	}
	var style: Style = .default
	
	var requestURLString: String! = "" {
		didSet {
			web.load(requestURLString.toURLRequest)
		}
	}
	
	lazy var statusBackgroundView: UIView = self.initStatusBackgroundView()
	lazy var statusBackItem: IWStatusBackItem = { [unowned self] in
		let bi = IWStatusBackItem(tips: "返回", tapHandler: { [weak self] in
			self?.hide()
		})
		return bi
	}()
	var hostInfoLabel: UILabel = UILabel()
	
	var loadFinishedHandler: ((_ webView: IWWebView) -> Void)?
	var didStartHandler: ((_ webView: IWWebView) -> Void)?
	
	convenience init(url: String, style: Style = .default) {
		self.init()
		self.requestURLString = url
		self.style = style
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		
        // Do any additional setup after loading the view.
		
		initUserInterface()
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		web.stopLoading()
	}
	
	deinit {
		web.removeObserver(self, forKeyPath: kEstimatedProgress)
	}
	
	override func initUserInterface() {
		
		navTitle = "正在加载..."
		
		setupWebView()
		setupProgressView()
		
		if style == .default {
			showDefaultStyle()
		} else if style == .mini {
			showMiniStyle()
		}
		
		if requestURLString != "" {
			web.load(requestURLString.toURLRequest)
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension IWWebVC {
	
	fileprivate func setupWebView() -> Void {
		web = IWWebView(frame: view.bounds)
		web.navigationDelegate = self
		web.uiDelegate = self
		showBackgroundColor()
		view.addSubview(web)
		// Add observer
		web.addObserver(self, forKeyPath: kEstimatedProgress, options: .new, context: nil)
	}
	
	fileprivate func setupProgressView() -> Void {
		progressView = UIProgressView(frame: MakeRect(0, .navBarHeight, view.width, 4))
		progressView.trackTintColor = view.backgroundColor
		progressView.progressTintColor = .black
		progressView.progress = 0
		view.addSubview(progressView)
	}
	
	fileprivate func setupHostInfoLabel() -> Void {
		hostInfoLabel.frame = MakeRect(0, .navBarHeight + 10, view.width, 18)
		hostInfoLabel.numberOfLines = 1
		hostInfoLabel.font = UIFont.IWE.fontFamily("Menlo")
		hostInfoLabel.textColor = "#a9a9a9".toColor
		hostInfoLabel.textAlignment = .center
		hostInfoLabel.isHidden = true
		view.insertSubview(hostInfoLabel, at: 0)
	}
	
	fileprivate func initStatusBackgroundView() -> UIView {
		return IWStatus.bgView()
	}
	
	fileprivate func showDefaultStyle() -> Void {
		progressView.top = iwe.navigationBarHeight
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
		web.scrollView.iwe.autoSetEdge(view)
		
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
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		
		if keyPath == kEstimatedProgress {
			// Progress
			let newProgress = Float(web.estimatedProgress)
			if newProgress >= 1.0 {
				progressView.setProgress(1.0, animated: true)
				let _ = delayExecution(1.0, task: { 
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
	
	func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
		
		print("WebView did start load: \(webView.url!.absoluteString)")
		
		if webView.url!.absoluteString == "about:blank" {
			return
		}
		
		// add background color, until did finish clear
		showBackgroundColor()
		
		if let host = webView.url?.host {
			hostInfoLabel.text = "此网页由 \(host) 提供"
		} else {
			hostInfoLabel.text = "未能识别此域名"
		}
		// start handler
		didStartHandler?(web)
	}
	
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		
		// set navigation bar title
		navTitle = webView.title
		
		// Handler background color
		hideBackgroundColor()
		
		// fix unexecute when target='_blank'
		webView.iwe.setAttrToLabel(byTagName: "a", attrName: "target", attrValue: "")
		
		// load finished
		loadFinishedHandler?(web)
	}
	
}

extension IWWebVC {
	
	fileprivate func hideBackgroundColor() -> Void {
		web.backgroundColor = .clear
		web.iwe.wkContentView?.backgroundColor = .clear
		
		let _ = delayExecution(0.5) {
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
	func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
		let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
		let action = UIAlertAction(title: "好的", style: .cancel) { (_) in
			completionHandler()
		}
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}
	
	//confirm弹框
	func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
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
	func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
		let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
		alert.addTextField { (_) in}
		let action = UIAlertAction(title: "确定", style: .default) { (_) in
			completionHandler(alert.textFields?.last?.text)
		}
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}
}
