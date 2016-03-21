//
//  campaignWebViewController.swift
//  TeespringSeller
//
//  Created by Lee Edwards on 3/20/16.
//  Copyright © 2016 Lee Edwards. All rights reserved.
//

import UIKit

class CampaignWebViewController: UIViewController {
    @IBOutlet var webView: UIWebView!
    var url: NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = url {
            let request = NSURLRequest(URL: url)
            webView.loadRequest(request)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
