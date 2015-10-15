//
//  TableViewController.swift
//  LUG
//
//  Created by Avikant Saini on 10/14/15.
//  Copyright © 2015 LUG Manipal. All rights reserved.
//

import UIKit
import MessageUI

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

		let backButton = UIBarButtonItem.init(title: "", style: .Plain, target: nil, action: nil)
		self.navigationItem.backBarButtonItem = backButton
		
    }

    // MARK: - Table view data source
	
	// MARK: - Table view delegate
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if (indexPath.section == 2) {
			var url: NSString;
			var title: NSString;
			switch (indexPath.row) {
				case 0:
					url = NSString(string: "https://www.facebook.com/LUGManipal")
					title = NSString(string: "Facebook Page")
				break
				case 1:
					url = NSString(string: "https://www.facebook.com/groups/lug2016/")
					title = NSString(string: "Facebook Group")
				break
				case 2:
					url = NSString(string: "http://twitter.com/LUGManipal")
					title = NSString(string: "Twitter Page")
				break
				default:
					url = NSString(string: "http://www.lugmanipal.org")
					title = NSString(string: "Website")
				break
				
			}
			let wvc = self.storyboard?.instantiateViewControllerWithIdentifier("WebVC") as! WebViewController
			wvc.passedTitle = title
			wvc.passedURL = url
			self.navigationController?.pushViewController(wvc, animated: true)
		}
		if (indexPath.section == 3) {
			if (indexPath.row == 1) {
				
			}
		}
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if (segue.identifier!.isEqual("visitWebsiteSeue")) {
			
		}
    }

}
