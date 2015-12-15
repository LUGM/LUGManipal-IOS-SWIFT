//
//  AppDelegate.swift
//  LUG
//
//  Created by Avikant Saini on 10/13/15.
//  Copyright © 2015 LUG Manipal. All rights reserved.
//

import UIKit
import CoreData
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		// Override point for customization after application launch.
		
//		Parse.enableLocalDatastore()
		
        //To get client key and secret message us at https://www.facebook.com/LUGManipal/
		Parse.setApplicationId("", clientKey: "")
        
		// Register for Push Notitications
		if application.applicationState != UIApplicationState.Background {
			// Track an app open here if we launch with a push, unless
			// "content_available" was used to trigger a background push (introduced in iOS 7).
			// In that case, we skip tracking here to avoid double counting the app-open.
			
			let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
			let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
			var pushPayload = false
			if let options = launchOptions {
				pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil
			}
			if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
				PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
			}
		}
		
		if application.respondsToSelector("registerUserNotificationSettings:") {
			let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
			application.registerUserNotificationSettings(settings)
			application.registerForRemoteNotifications()
		}
		else {
			application.registerForRemoteNotifications()
		}
		
		// Set appearance properties
		
		UINavigationBar.appearance().backgroundColor = AppDelegate.globalBackColor();
		UINavigationBar.appearance().barTintColor = AppDelegate.globalBackColor();
		UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: AppDelegate.globalTintColor()];
		
		// Install initial versions of our two dynamic shortcuts.
		if #available(iOS 9.0, *) {
		    if let shortcutItems = application.shortcutItems where shortcutItems.isEmpty {
    			// Construct the items.
    			let shortcut1 = UIMutableApplicationShortcutItem(type: "com.lugmanipal.LUG.Notifications", localizedTitle: "Notifications", localizedSubtitle: nil, icon: UIApplicationShortcutIcon.init(templateImageName: "notifications"), userInfo: nil
    			)
    			
    			let shortcut2 = UIMutableApplicationShortcutItem(type: "com.lugmanipal.LUG.Website", localizedTitle: "Website", localizedSubtitle: nil, icon: UIApplicationShortcutIcon.init(templateImageName: "website"), userInfo: nil
    			)
    			
    			// Update the application providing the initial 'dynamic' shortcut items.
    			application.shortcutItems = [shortcut1, shortcut2]
    		}
		} else {
		    // Fallback on earlier versions
		}

		
		return true
	}
	
	@available(iOS 9.0, *)
	func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
		let rootNavigationViewController = window!.rootViewController as? UINavigationController
		let rootViewController = rootNavigationViewController?.viewControllers.first as! TableViewController?
		rootNavigationViewController?.popToRootViewControllerAnimated(false)
		if (shortcutItem.type.containsString("Notifications")) {
			rootViewController?.performSegueWithIdentifier("notificationsSegue", sender: nil)
		}
		if (shortcutItem.type.containsString("Website")) {
			rootViewController?.performSegueWithIdentifier("visitWebsiteSeue", sender: nil)
		}
	}
	
	func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
		let installation = PFInstallation.currentInstallation()
		installation.setDeviceTokenFromData(deviceToken)
		installation.saveInBackground()
	}
 
	func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
		if (error.code == 3010) {
			print("Push notifications are not supported in the iOS Simulator.")
		}
		else {
			print("application:didFailToRegisterForRemoteNotificationsWithError: \(error)")
		}
	}
 
	func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
		PFPush.handlePush(userInfo)
		if application.applicationState == UIApplicationState.Inactive {
			PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
		}
	}

	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
		// Saves changes in the application's managed object context before the application terminates.
		self.saveContext()
	}
	
	// MARK: - Class functions
	
	internal static func colorFromRGBA(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
		return UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: alpha);
	}
	
	internal static func globalTintColor() -> UIColor {
		return AppDelegate.colorFromRGBA(58, green: 80, blue: 105, alpha: 1);
	}
	
	internal static func globalBackColor() -> UIColor {
		return AppDelegate.colorFromRGBA(252, green: 249, blue: 238, alpha: 1);
	}

	// MARK: - Core Data stack

	lazy var applicationDocumentsDirectory: NSURL = {
	    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.lugmanipal.LUG" in the application's documents Application Support directory.
	    let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
	    return urls[urls.count-1]
	}()

	lazy var managedObjectModel: NSManagedObjectModel = {
	    // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
	    let modelURL = NSBundle.mainBundle().URLForResource("LUG", withExtension: "momd")!
	    return NSManagedObjectModel(contentsOfURL: modelURL)!
	}()

	lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
	    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
	    // Create the coordinator and store
	    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
	    let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
	    var failureReason = "There was an error creating or loading the application's saved data."
	    do {
	        try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
	    } catch {
	        // Report any error we got.
	        var dict = [String: AnyObject]()
	        dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
	        dict[NSLocalizedFailureReasonErrorKey] = failureReason

	        dict[NSUnderlyingErrorKey] = error as NSError
	        let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
	        // Replace this with code to handle the error appropriately.
	        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	        NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
	        abort()
	    }
	    
	    return coordinator
	}()

	lazy var managedObjectContext: NSManagedObjectContext = {
	    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
	    let coordinator = self.persistentStoreCoordinator
	    var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
	    managedObjectContext.persistentStoreCoordinator = coordinator
	    return managedObjectContext
	}()

	// MARK: - Core Data Saving support

	func saveContext () {
	    if managedObjectContext.hasChanges {
	        do {
	            try managedObjectContext.save()
	        } catch {
	            // Replace this implementation with code to handle the error appropriately.
	            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	            let nserror = error as NSError
	            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
	            abort()
	        }
	    }
	}

}

