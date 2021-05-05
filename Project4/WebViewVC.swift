//
//  ViewController.swift
//  Project4
//
//  Created by Özgün Yildiz on 05.05.21.
//

import UIKit
import WebKit

class WebViewVC: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    // we are creating a class scope variable for progressView because we use it in the 'observe Value' function.
    var progressView: UIProgressView!
    var passedSite: String!
    var websites = [String]()
    
    // This method loads or creates a view and assigns it to the view property. Since we are overreding the view of our viewController with the webView, we have to user loadView
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        // make it the view of our viewController
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        websites += ["hackingwithswift.com", "apple.com"]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        // the spacer inserts space between the refresh button and the progressview
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let forward = UIBarButtonItem(title: "Forward", style: .plain, target: webView, action: #selector(webView.goForward))
        let backward = UIBarButtonItem(title: "Backward", style: .plain, target: webView, action: #selector(webView.goBack))
        // creating progress view
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        // since we want the progressView to be below (as a BARbuttonitem)
        let progressButton = UIBarButtonItem(customView: progressView)
        // if we didn't have this, none of the UIBarButtonItems we created would be displayed
        // the ordering plays a role: in this case, progressButton will be shown first, then follows the spacer and then the refresh button
        toolbarItems = [progressButton, spacer, refresh, backward, forward]
        // even if we have created the toolbarItems, we have to unhide the toolBar manually, because the default behavior defines it to be hidden
        navigationController?.isToolbarHidden = false
        // we created a variable called 'websites' above, which contains the websites that we offer our users to visit
        // here, we are taking the first element in the array and put the url into a constant
        let url = URL(string: "https://" + passedSite)!
        // we load the webView with the url we just created
        webView.load(URLRequest(url: url))
        // allows swiping gestures with the webView
        webView.allowsBackForwardNavigationGestures = true
        
        // tells the viewController how much of the web page has loaded
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    // barButtonItem on the top right tapped
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        // important for iPad
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        // grab the title of the actionButton fed into the function
        guard let actionTitle = action.title else { return }
        // create URL based on that
        guard let url = URL(string: "https://" + actionTitle) else { return }
        // load the url into the webView
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // we only want to see whether the keyPath fed into the function is "estimatedProgress"
        // "estimatedProgress" is the value being observed
        if keyPath == "estimatedProgress" {
            // if so, then we set the webView's.estimatedProgress to the progressView.progress
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    // we only allow the user to browse the websites which are in our websites array
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // we set the constant 'url' to the url of the navigation
        let url = navigationAction.request.url
        // if there is a host in this url, then pull it out
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    // allow loading
                    decisionHandler(.allow)
                    return
                }
            }
        }
        
        guard let urlString = url?.absoluteString else { return }
        
        if urlString != "about:blank" {
            let ac = UIAlertController(title: "Access Denied", message: "The website \(urlString) is not accessible through this app", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .cancel))
            present(ac, animated: true)
           
        }
        
        // deny loading
        decisionHandler(.cancel)
        
    }
    
}

