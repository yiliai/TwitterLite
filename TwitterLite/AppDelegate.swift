//
//  AppDelegate.swift
//  TwitterLite
//
//  Created by Yili Aiwazian on 9/23/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDidSignout", name: userDidSignoutNotification, object: nil)
        
        if User.currentUser != nil {
            // Go to the home timeline screen
            println("current user detected: \(User.currentUser?.name)")
            let homeViewController = HomeTimelineViewController(nibName: "HomeTimelineViewController", bundle: nil)
            let navController = UINavigationController(rootViewController: homeViewController)
            self.window!.rootViewController = navController
        }
        else {
            let loginViewController = LogInViewController(nibName: "LogInViewController", bundle: nil)
            self.window!.rootViewController = loginViewController
        }
        self.window!.makeKeyAndVisible()

        return true
    }
    
    func userDidSignout() {
        let loginViewController = LogInViewController(nibName: "LogInViewController", bundle: nil)
        self.window!.rootViewController = loginViewController
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
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String, annotation: AnyObject?) -> Bool {
        NSLog("callback url:\(url)")
        if (url.scheme? == "twitterlite") {
            if (url.host? == "oauth") {
                TwitterLiteClient.sharedInstance.openURL(url)
            }
            return true
        }
        return false
    }

}