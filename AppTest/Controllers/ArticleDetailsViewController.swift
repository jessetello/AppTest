//
//  ArticleDetailsViewController.swift
//  AppTest
//
//  Created by Jesse Tello on 9/28/17.
//  Copyright © 2017 Jesse. All rights reserved.
//

import UIKit
import WebKit

class ArticleDetailsViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet var activity: UIActivityIndicatorView!
    
    var article: Article?
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        if let urlString = article?.articleUrl {
            if let urlRequest = URL(string: urlString) {
                let request = URLRequest(url: urlRequest)
                activity.startAnimating()
                webView.load(request)
            }
        }
    }
}

extension ArticleDetailsViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activity.stopAnimating()
    }
}
