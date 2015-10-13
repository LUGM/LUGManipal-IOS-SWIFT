//
//  ViewController.swift
//  LUG
//
//  Created by Avikant Saini on 10/13/15.
//  Copyright © 2015 LUG Manipal. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
//-------------------------------------------------------------------------------------------------------------------------------
//	Table view data source
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 4
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (section + 1)
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("defaultCell", forIndexPath: indexPath)
		cell.textLabel?.text = "Row \(indexPath.row + 1)"
		cell.detailTextLabel?.text = "Section \(indexPath.section + 1)"
		return cell
	}
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Section \(section + 1)"
	}
	
//-------------------------------------------------------------------------------------------------------------------------------
//	Table view delegate
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
	
}

