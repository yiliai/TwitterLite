//
//  HomeTimelineViewController.swift
//  TwitterLite
//
//  Created by Yili Aiwazian on 9/27/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import UIKit

class HomeTimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var homeNavigationBar: UINavigationBar!
    @IBOutlet weak var homeTimelineTable: UITableView!
    
    var homeStatuses: [Status]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setting up the table view and table cells
        let statusCellNib = UINib(nibName: "TweetTableViewCell", bundle: nil);
        homeTimelineTable.registerNib(statusCellNib, forCellReuseIdentifier: "statusCell")
        homeTimelineTable.rowHeight = UITableViewAutomaticDimension
        homeTimelineTable.estimatedRowHeight = 90
        homeTimelineTable.dataSource = self
        homeTimelineTable.delegate = self
        
        // Do any additional setup after loading the view.
        TwitterLiteClient.sharedInstance.getHomeTimelineWithParams(nil, completion: { (statuses, error) -> () in
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
            cell.setRetweetReason("\(status.author!.name!) retweeted")
            
            let retweet = status.retweetedStatus! as Status
            cell.setAuthorName(retweet.author!.name!)
            cell.setScreenName("@\(retweet.author!.screenName!)")
            cell.setStatusText(retweet.text!)
            cell.setAuthorImage(retweet.author!.profileImageUrl!)
        }
        else {
            cell.setRetweetReason(nil)
            cell.setAuthorName(status.author!.name!)
            cell.setScreenName("@\(status.author!.screenName!)")
            cell.setStatusText(status.text!)
            cell.setAuthorImage(status.author!.profileImageUrl!)
        }
        return cell
    }
}
