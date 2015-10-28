//
//  NotificationsTableViewController.swift
//  LUG
//
//  Created by Avikant Saini on 10/17/15.
//  Copyright © 2015 LUG Manipal. All rights reserved.
//

import UIKit
import Parse

class NotificationsTableViewController: UITableViewController {
	
	var notifications: NSMutableArray = NSMutableArray();

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.pleaseWait()
		
		let notificationsQuery = PFQuery.init(className: "Notifications")
		notificationsQuery.orderByDescending("updatedAt")
		notificationsQuery.findObjectsInBackgroundWithBlock { (notifs, error) -> Void in
			if ((error) != nil) {
				NSLog("Error: ", (error?.localizedDescription)!)
				UIAlertView.init(title: "Error", message: "No data found on server. Try again later", delegate: nil, cancelButtonTitle: "Dismiss").show()
				self.performSelectorOnMainThread("dismiss", withObject: nil, waitUntilDone: false)
			}
			self.notifications = NSMutableArray(array: notifs!)
			self.tableView.reloadData()
			self.clearAllNotice()
		}
		
		self.refreshControl?.addTarget(self, action: "viewDidLoad", forControlEvents: .AllEvents)
		self.tableView.tableHeaderView = self.refreshControl;
		
    }
	
	func dismiss () {
		self.navigationController?.popViewControllerAnimated(true)
	}
	
	override func viewDidDisappear(animated: Bool) {
		self.clearAllNotice()
	}

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return notifications.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("notificationsCell", forIndexPath: indexPath)
		
		let notif = notifications[indexPath.section] as! PFObject
		cell.textLabel?.text = "\(indexPath.section + 1). " + ((notif.valueForKey("title") as? String)?.uppercaseString)!

        return cell
    }
	
	override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		let notif = notifications[section] as! PFObject
		return notif.valueForKey("detail") as? String
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 36
	}
	
	override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return false
	}
	
	// MARK: - Table view delegate
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
