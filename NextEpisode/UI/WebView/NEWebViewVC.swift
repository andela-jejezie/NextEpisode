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
    var displayTitle:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        title = displayTitle
        self.webView.delegate = self
        let url:NSURL = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        webView.loadRequest(request)
        SwiftSpinner.show("Loading...")
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return allowLoading
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        allowLoading = false
        SwiftSpinner.hide()
    }

}
