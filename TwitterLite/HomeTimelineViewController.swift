//
//  HomeTimelineViewController.swift
//  TwitterLite
//
//  Created by Yili Aiwazian on 9/27/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import UIKit
let TWITTER_BLUE = UIColor(red: 0.345, green: 0.6823, blue: 0.937, alpha: 1.0)

class HomeTimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var homeNavigationBar: UINavigationBar!
    @IBOutlet weak var homeTimelineTable: UITableView!
    
    var homeStatuses: [Status]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Skin the navigation bar
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.barTintColor = TWITTER_BLUE
        navigationBar?.tintColor = UIColor.whiteColor()
        navigationBar?.topItem?.title = "Home"
        let titleSytle: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationBar?.titleTextAttributes = titleSytle
        
        // Add the signout button
        let signoutButton = UIBarButtonItem(title: "Sign Out", style: .Plain, target: self, action: "signout")
        self.navigationItem.setLeftBarButtonItem(signoutButton, animated: true)
        
        // Setting up the table view and table cells
        let statusCellNib = UINib(nibName: "TweetTableViewCell", bundle: nil);
        homeTimelineTable.registerNib(statusCellNib, forCellReuseIdentifier: "statusCell")
        homeTimelineTable.rowHeight = UITableViewAutomaticDimension
        homeTimelineTable.estimatedRowHeight = 90
        homeTimelineTable.dataSource = self
        homeTimelineTable.delegate = self
        
        // Do any additional setup after loading the view.
        TwitterLiteClient.sharedInstance.getHomeTimelineWithParams(nil, completion: { (statuses, error) -> () in
            println("Get home timeline")
            self.homeStatuses = statuses
            self.homeTimelineTable.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapSignout(sender: AnyObject) {
        User.currentUser?.signout()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println(homeStatuses?.count)
        return (homeStatuses != nil) ? homeStatuses!.count : 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (homeStatuses == nil || homeStatuses?.count == 0) {
            return UITableViewCell(style: .Default, reuseIdentifier: nil)
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("statusCell", forIndexPath: indexPath) as TweetTableViewCell
        let status = homeStatuses![indexPath.row] as Status
        
        // First check to see if this is a retweet
        if status.retweetedStatus != nil {
            cell.setRetweetReason(status.author!.name)
            let retweet = status.retweetedStatus! as Status
            cell.setStatus(retweet)
        }
        else {
            cell.setRetweetReason(nil)
            cell.setStatus(status)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        println("tapped on item: \(indexPath.row)")
        
        let itemViewController = TweetItemViewController(nibName: "TweetItemViewController", bundle: nil)
        let status = homeStatuses![indexPath.row] as Status
        if (status.retweetedStatus != nil) {
            itemViewController.status = status.retweetedStatus!
        }
        else {
            itemViewController.status = status
        }
        
        self.navigationController?.pushViewController(itemViewController, animated: true)
        
        /*tableView.cellForRowAtIndexPath(indexPath)?.highlighted = false
        tableView.beginUpdates()
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        tableView.endUpdates()*/
    }
    
    func signout() {
        User.currentUser?.signout()
    }
}
