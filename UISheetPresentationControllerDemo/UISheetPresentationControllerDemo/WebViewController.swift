//
//  WebViewController.swift
//  WebViewController
//
//  Created by Molder on 2021/8/29.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    var webView : WKWebView?
    
    deinit {
        webView?.stopLoading()
        print("\(self) deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setWKwebView()
    }
    
    private func setWKwebView() {
        
        if webView == nil {
            webView = WKWebView(frame: self.view.frame)
            webView?.translatesAutoresizingMaskIntoConstraints = false
            webView?.backgroundColor = UIColor.white
            webView?.uiDelegate = self
            webView?.navigationDelegate = self
            self.view.addSubview(webView!)
            
            webView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            webView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            webView?.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
            webView?.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
            guard let url = URL(string: "https://www.youtube.com") else { return }
            var request = URLRequest(url: url)
            request.timeoutInterval = 10
            webView?.load(request)
        }

    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinish")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("didFail")
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        
        print(url.absoluteString)
        
        decisionHandler(.allow)
    }
}
