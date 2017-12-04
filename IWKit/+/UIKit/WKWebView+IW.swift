//
//  IWWebView.swift
//  haoduobaduo
//
//  Created by iWe on 2017/8/21.
//  Copyright © 2017年 iWe. All rights reserved.
//

import UIKit
import WebKit

extension IWView where View: WKWebView {
    
    /// Load local HTMl file.
    ///
    /// - Parameters:
    ///   - fileName: HTML file name.
    ///   - type: default is html.
    final func load(local fileName: String, _ type: String = "html") -> Void {
        let path = Bundle.main.path(forResource: fileName, ofType: type)
        
        guard path != nil else {
            iPrint("没有找到\(fileName).\(type)")
            return
        }
        
        if #available(iOS 9.0, *) {
            let fileURL = path!.toFileURL
            view.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
        } else {
            // Fallback on earlier versions
            let fileURL = fileURLForBugglyWKWebView(URL.init(fileURLWithPath: path!))
            if let fileURLed = fileURL {
                let request = URLRequest.init(url: fileURLed)
                view.load(request)
            }
        }
    }
    
    /// Remove child with identity.
    ///
    /// - Parameters:
    ///   - identity: Label identifier
    final func removeChild(byIdentity: String, completionHandler: ((Any?, Error?) -> Void)? = nil) -> Void {
        let script = "var removeObj = document.getElementById('\(byIdentity)'); document.body.removeChild(removeObj);"
        view.evaluateJavaScript(script, completionHandler: completionHandler)
    }
    
    /// Remove child with className. index为-1则移除全部classname为byClass的内容
    ///
    /// - Parameters:
    ///   - byClass: class name
    ///   - index: Index
    final func removeChild(bySelector selectorName: String, index: Int = -1, completionHandler: ((Any?, Error?) -> Void)? = nil) -> Void {
        var script = ""
        if index == -1 {
            script = "var waitRemoveObjs = document.querySelectorAll('\(selectorName)'); for (i = waitRemoveObjs.length - 1; i >= 0; i --) { var waitRemoveObj = waitRemoveObjs[i]; waitRemoveObj.parentNode.removeChild(waitRemoveObj);}"
        } else {
            script = "var waitRemoveObj = document.querySelector('\(selectorName)'); waitRemoveObj.parentNode.removeChild(waitRemoveObj);"
        }
        view.evaluateJavaScript(script, completionHandler: completionHandler)
    }
    
    /// Auto scale page. Use in loaded.
    final func autoScale() {
        let script = "var viewPortTag=document.createElement('meta'); viewPortTag.id='viewport'; viewPortTag.name = 'viewport'; viewPortTag.content = 'width=100%; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;'; document.getElementsByTagName('head')[0].appendChild(viewPortTag);"
        view.evaluateJavaScript(script, completionHandler: nil)
    }
	
	final func innerHTMLContent(handler: ((_ HTMLContent: String) -> Void)?) -> Void {
		view.evaluateJavaScript("document.body.innerHTML") { (content, error) in
			if let ct = content {
				handler?(ct as! String)
			} else {
				iPrint(error: error)
			}
		}
	}
	
	final func outerHTMLContent(handler: ((_ HTMLContent: String) -> Void)? ) -> Void {
		view.evaluateJavaScript("document.body.outerHTML") { (content, error) in
			if let ct = content {
				handler?(ct as! String)
			} else {
				iPrint(error: error)
			}
		}
	}
	
	final func setAttrToLabel(byTagName tagName: String, attrName: String, attrValue: String) -> Void {
		view.evaluateJavaScript("var tags = document.getElementsByTagName('\(tagName)'); for (var i = 0; i < tags.length; i++) { tags[i].setAttribute('\(attrName)','\(attrValue)'); }") { (any, error) in
			iPrint(error: error)
		}
	}
	
	final var wkContentView: UIView? {
		for subView in view.subviews {
			subView.backgroundColor = .clear
			if subView.isKind(of: NSClassFromString("WKScrollView")!) {
				for ssubView in subView.subviews {
					if ssubView.isKind(of: NSClassFromString("WKContentView")!) {
						ssubView.backgroundColor = .clear
						return ssubView
					}
				}
			}
		}
		return nil
	}
	
	
	final var backgroundView: UIView? {
		if let contentView = wkContentView {
			for subv in contentView.subviews {
				return subv
			}
		}
		return nil
	}
	
	final func post(path: String, JSONParameters: String) {
		let postJavascript = "function iwe_post(path, parameters) { var method = \"POST\"; var form = document.createElement(\"form\"); form.setAttribute(\"method\", method); form.setAttribute(\"action\", path); for (var key in parameters) { var hiddenFild = document.createElement(\"input\"); hiddenFild.setAttribute(\"type\", \"hidden\"); hiddenFild.setAttribute(\"name\", key); hiddenFild.setAttribute(\"value\", parameters[key]); form.appendChild(hiddenFild); } document.body.appendChild(form); form.submit(); }; iwe_post('\(path)', '\(JSONParameters.remove(["\\", " "]))');"
		view.evaluateJavaScript(postJavascript) { (result, error) in
			iPrint(error: error)
		}
	}
	
	final func setStyle(byClassName className: String, index: Int = -1, value: String?) {
		var postJavascript = ""
		if index == -1 {
			postJavascript = "var waitChangingObjs = document.getElementsByClassName('\(className)'); for (var i = 0; i < waitChangingObjs.length; i++) { var waitChangingObj = waitChangingObjs[i]; waitChangingObj.setAttribute('style', '\(value ?? "");'); }"
		} else {
			postJavascript = "document.getElementsByClassName('\(className)')[\(index)].setAttribute('style', '\(value ?? "");');"
		}
		view.evaluateJavaScript(postJavascript) { (result, error) in
			iPrint(error: error)
		}
	}
	
	final func setStyle(byId id: String, value: String?) {
		let postJavascript = "var waitChangingObj = document.getElementById('\(id)'); waitChangingObj.setAttribute('style', '\(value ?? "")');"
		view.evaluateJavaScript(postJavascript) { (result, error) in
			print(result as Any)
			iPrint(error: error)
		}
	}
	
}


fileprivate extension IWView where View: WKWebView {
    
    func fileURLForBugglyWKWebView(_ fileURL: URL?) -> URL? {
        
        guard let _ = try? fileURL?.checkResourceIsReachable() else {
            return nil
        }
        
        let fileManager = FileManager.default
        let temDirURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("www")
        do {
            try? fileManager.createDirectory(at: temDirURL, withIntermediateDirectories: true, attributes: nil)
            let dstURL = temDirURL.appendingPathComponent((fileURL?.lastPathComponent)!)
            
            do {
                try fileManager.removeItem(at: dstURL)
            } catch {
                print(error.localizedDescription)
            }
            
            do {
                try fileManager.copyItem(at: fileURL!, to: dstURL)
            } catch {
                print(error.localizedDescription)
            }
            return dstURL
        }
    }
	
}
