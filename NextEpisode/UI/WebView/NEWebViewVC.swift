//
//  NEWebViewVC.swift
//  NextEpisode
//
//  Created by Andela on 5/13/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import UIKit

class NEWebViewVC: NEGenericVC, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    var allowLoading = true
    var urlString:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.delegate = self
        let url:NSURL = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        webView.loadRequest(request)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return allowLoading
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        allowLoading = false
    }

}
