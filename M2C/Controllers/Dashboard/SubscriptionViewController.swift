//
//  SubscriptionViewController.swift
//  M2C
//
//  Created by Fenris GMBH on 14/02/2023.
//

import UIKit
import WebKit

class SubscriptionViewController: UIViewController, WKNavigationDelegate {
    
    var subscription: Subscription?
    
    @IBOutlet weak var webView: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        webView.frame = view.bounds
        webView.navigationDelegate = self
        
        // Setting up the URL
        if let subscription = subscription{
            if let url = URL(string: subscription.url){
                let urlRequest = URLRequest(url: url)
                
                // Loading URL in WebView
                webView.load(urlRequest)
                webView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
            }
            
        }
        
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated  {
            if let url = navigationAction.request.url,
               let host = url.host, !host.hasPrefix("www.google.com"),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                print(url)
                print("Redirected to browser. No need to open it locally")
                decisionHandler(.cancel)
                return
            } else {
                print("Open it locally")
                decisionHandler(.allow)
                return
            }
        } else {
            print("not a user click")
            decisionHandler(.allow)
            return
        }
    }
    
}
