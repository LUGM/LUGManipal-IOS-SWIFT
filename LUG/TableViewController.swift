//
//  TableViewController.swift
//  LUG
//
//  Created by Avikant Saini on 10/14/15.
//  Copyright © 2015 LUG Manipal. All rights reserved.
//

import UIKit
import MessageUI

class TableViewController: UITableViewController, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

		let backButton = UIBarButtonItem.init(title: "", style: .Plain, target: nil, action: nil)
		self.navigationItem.backBarButtonItem = backButton
		
    }

    // MARK: - Table view data source
	
	// MARK: - Table view delegate
	
	override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		if (indexPath.section == 0) {
			return false
		}
		return true
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if (indexPath.section == 3) {
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
				case 3:
					url = NSString(string: "https://github.com/LUGM")
					title = NSString(string: "Official LUGM Github")
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
		else if (indexPath.section == 4) {
			if (indexPath.row == 0) {
				// Mailing list
				if (MFMailComposeViewController.canSendMail()) {
					let mailVC : MFMailComposeViewController = MFMailComposeViewController()
					mailVC.mailComposeDelegate = self
					mailVC.setSubject("To LUG Manipal")
					mailVC.setToRecipients(["discussion@lists.lugmanipal.org"])
					mailVC.setMessageBody("\n\nLinux is Love, Linux is Life. (Throw that Windows out of the window.)\n\n", isHTML: false)
					mailVC.modalPresentationStyle = .PageSheet
					self.presentViewController(mailVC, animated: true, completion: { () -> Void in
						
					});
				}
			}
			else if (indexPath.row == 1) {
				// About
			}
		}
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}

	func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
		self.dismissViewControllerAnimated(true) { () -> Void in
		}
	}
	
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if (segue.identifier!.isEqual("visitWebsiteSeue")) {
			
		}
		if (segue.identifier!.isEqual("notificationsSegue")) {
			
		}
    }

}
