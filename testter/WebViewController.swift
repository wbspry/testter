//
//  WebViewController.swift
//  testter
//
//  Created by Naoki Fujii on 9/3/15.
//  Copyright © 2015 yyyske3. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var backButtonItem: UIBarButtonItem!
    @IBOutlet weak var forwardButtonItem: UIBarButtonItem!
    @IBOutlet weak var stopButtonItem: UIBarButtonItem!
    @IBOutlet weak var refreshButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var webView: UIWebView! // iOS8から高機能なWKWebViewも使用可能
    
    deinit {
        webView.delegate = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateToolBar()
        webView.delegate = self
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.yahoo.co.jp")!))
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: false)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        webView.stopLoading()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func updateToolBar() {
        forwardButtonItem.enabled = webView.canGoForward
        backButtonItem.enabled = webView.canGoBack
        refreshButtonItem.enabled = true
        stopButtonItem.enabled = false
    }
    
    @IBAction func goBack(sender: AnyObject) {
        webView.goBack()
    }
    
    @IBAction func goForward(sender: AnyObject) {
        webView.goForward()
    }
    
    @IBAction func stop(sender: AnyObject) {
        webView.stopLoading()
    }
    @IBAction func refresh(sender: AnyObject) {
        webView.reload()
    }
    
}

extension WebViewController: UIWebViewDelegate {
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        stopButtonItem.enabled = true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        updateToolBar()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        updateToolBar()
    }
}