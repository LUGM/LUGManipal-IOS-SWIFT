//
//  AboutTableViewController.swift
//  LUG
//
//  Created by Avikant Saini on 12/14/15.
//  Copyright © 2015 LUG Manipal. All rights reserved.
//

import UIKit

class AboutTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.tableView.rowHeight = UITableViewAutomaticDimension;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view delegate

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if (indexPath.section == 1) {
			if (indexPath.row == 0) {
				// Change this to new location
				let url = NSString(string: "https://github.com/shubhsin/LUGManipal-IOS-SWIFT")
				let title = NSString(string: "Source Code")
				let wvc = self.storyboard?.instantiateViewControllerWithIdentifier("WebVC") as! WebViewController
				wvc.passedTitle = title
				wvc.passedURL = url
				self.navigationController?.pushViewController(wvc, animated: true)
			}
		}
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
