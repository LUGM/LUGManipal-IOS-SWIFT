//
//  WebViewController.swift
//  LUG
//
//  Created by Avikant Saini on 10/15/15.
//  Copyright © 2015 LUG Manipal. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
	
	var webView: WKWebView
	var passedURL: NSString
	var passedTitle: NSString
	
	let DEFAULT_URL = "http://www.lugmanipal.org"
	let DEFAULT_TITLE = "LUG Manipal"
	
	@IBOutlet weak var progressView: UIProgressView!
	@IBOutlet weak var backButton: UIBarButtonItem!
	@IBOutlet weak var forwardButton: UIBarButtonItem!
	@IBOutlet weak var reloadButton: UIBarButtonItem!
	
	required init(coder aDecoder: NSCoder) {
		self.webView = WKWebView(frame: CGRectZero)
		self.passedURL = NSString(string: DEFAULT_URL)
		self.passedTitle = NSString(string: DEFAULT_TITLE)
		super.init(coder: aDecoder)!
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		view.insertSubview(webView, belowSubview: progressView)
		webView.translatesAutoresizingMaskIntoConstraints = false
		let height = NSLayoutConstraint(item: webView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: 0)
		let width = NSLayoutConstraint(item: webView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
		view.addConstraints([height, width])
		
		self.webView.navigationDelegate = self
		
		self.navigationItem.rightBarButtonItems = [self.reloadButton, self.forwardButton, self.backButton];
		
		var url = NSURL(string: DEFAULT_URL)
		var title = NSString(string: DEFAULT_TITLE)
		
		if (passedURL.length > 0) {
			url = NSURL(string: passedURL as String)
			title = passedTitle
		}
		
		let request = NSURLRequest(URL:url!)
		webView.loadRequest(request)
		self.navigationItem.title = title as String
		
		backButton.enabled = false
		forwardButton.enabled = false
		
		webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
		webView.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
	}
	
	override func viewDidDisappear(animated: Bool) {
		webView.removeObserver(self, forKeyPath: "loading", context: nil)
		webView.removeObserver(self, forKeyPath: "estimatedProgress", context: nil)
	}
	
	// MARK: - Actions
	
	@IBAction func backAction(sender: AnyObject) {
		webView.goBack();
	}
	
	@IBAction func forwardAction(sender: AnyObject) {
		webView.goForward();
	}
	
	@IBAction func reloadAction(sender: AnyObject) {
		var url = NSURL(string: DEFAULT_URL)
		var title = NSString(string: DEFAULT_TITLE)
		
		if (passedURL.length > 0) {
			url = NSURL(string: passedURL as String)
			title = passedTitle
		}
		
		let request = NSURLRequest(URL:url!)
		webView.loadRequest(request)
		self.navigationItem.title = title as String
	}
	
	// MARK: - KVO
	
	override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
		if (keyPath == "loading") {
			backButton.enabled = webView.canGoBack
			forwardButton.enabled = webView.canGoForward
		}
		if (keyPath == "estimatedProgress") {
			progressView.hidden = webView.estimatedProgress == 1
			progressView.setProgress(Float(webView.estimatedProgress), animated: true)
		}
	}
	
	// MARK: - WKNavigationDelegate
	
	func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
		progressView.setProgress(0.0, animated: false)
	}
	
	func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
		let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
		presentViewController(alert, animated: true, completion: nil)
	}

}
