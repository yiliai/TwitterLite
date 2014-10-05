//
//  TimelineViewController.swift
//  TwitterLite
//
//  Created by Yili Aiwazian on 9/27/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import UIKit
let TWITTER_BLUE = UIColor(red: 0.345, green: 0.6823, blue: 0.937, alpha: 1.0)

protocol ComposeDelegate {
    func dismissComposeView(newStatus: Status?)
}
protocol StatusUpdateDelegate {
    func toggleFavorite(indexPath: NSIndexPath)
    func toggleRetweet(indexPath: NSIndexPath)
    func tapReply(indexPath: NSIndexPath)
    func openImage(indexPath: NSIndexPath, url: NSURL, rect: CGRect)
}
class TimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ComposeDelegate, StatusUpdateDelegate {

    @IBOutlet weak var timelineTable: UITableView!
    @IBOutlet var timelineView: UIView!
    
    var timelineType: TimelineType?
    var statusTimeline: StatusArray?
    var composeViewController: ComposeViewController?
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Skin the navigation bar
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.barTintColor = TWITTER_BLUE
        navigationBar?.tintColor = UIColor.whiteColor()
        navigationBar?.topItem?.title = timelineType?.getTitle()
        
        let titleSytle: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationBar?.titleTextAttributes = titleSytle
        navigationBar?.barStyle = UIBarStyle.Black
        
        println("Skinning the nav bar controller")
        
        // Add the menu button
        let menuButton = UIBarButtonItem(image: UIImage(named: "menu"), style: UIBarButtonItemStyle.Plain, target: self, action: "openCloseMenu")
        self.navigationItem.setLeftBarButtonItem(menuButton, animated: true)

        // Add the compose button
        let composeButton = UIBarButtonItem(image: UIImage(named: "compose"), style: UIBarButtonItemStyle.Plain, target: self, action: "compose")
        self.navigationItem.setRightBarButtonItem(composeButton, animated: true)
        
        // Setting up the table view and table cells
        let statusCellNib = UINib(nibName: "TweetTableViewCell", bundle: nil);
        timelineTable.registerNib(statusCellNib, forCellReuseIdentifier: "statusCell")
        timelineTable.rowHeight = UITableViewAutomaticDimension
        timelineTable.dataSource = self
        timelineTable.delegate = self
        
        // This will remove extra separators from tableview
        timelineTable.tableFooterView = UIView(frame: CGRectZero)
            
        // Setting up the load more progress at the end of the table
        let progressCellNib = UINib(nibName: "ProgressTableViewCell", bundle: nil);
        timelineTable.registerNib(progressCellNib, forCellReuseIdentifier: "progressCell")
        
        // Do any additional setup after loading the view.
        TwitterLiteClient.sharedInstance.getTimelineWithParams(timelineType!, params: nil, completion: { (statuses, error) -> () in
            println("Get \(self.timelineType!.getTitle()) timeline")
            self.statusTimeline = statuses
            self.timelineTable.reloadData()
        })
        
        // Set up the pull to refresh control
        refreshControl.addTarget(self, action:"refresh", forControlEvents: UIControlEvents.ValueChanged)
        timelineTable.addSubview(refreshControl)
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
        return (statusTimeline != nil) ? statusTimeline!.count + 1 : 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (statusTimeline == nil || indexPath.row == statusTimeline!.count) {
            
            println("At the end of the list")
            let cell = tableView.dequeueReusableCellWithIdentifier("progressCell", forIndexPath: indexPath) as ProgressTableViewCell
            cell.progressIndicator.startAnimating()
            
            // load older here
            loadMore(cell)
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("statusCell", forIndexPath: indexPath) as TweetTableViewCell
        cell.statusUpdateDelegate = self
        cell.indexPath = indexPath
        
        let status = statusTimeline!.getStatus(indexPath.row)
        // First check to see if this is a retweet
        if status!.retweetedStatus != nil {
            cell.setRetweetReason(status!.author!.name)
            let retweet = status!.retweetedStatus! as Status
            cell.setStatus(retweet)
        }
        else {
            cell.setRetweetReason(nil)
            cell.setStatus(status!)
        }
        cell.containerView.setNeedsLayout()
        println("CELL height:\(cell.frame.height)")
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let status = statusTimeline?.getStatus(indexPath.row)
        if (status?.mediaUrls.count != 0) {
            return 260
        }
        else {
            return 120
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        println("tapped on item: \(indexPath.row)")
        
        let itemViewController = TweetItemViewController(nibName: "TweetItemViewController", bundle: nil)
        itemViewController.statusUpdateDelegate = self
        itemViewController.indexPath = indexPath

        let status = statusTimeline!.getStatus(indexPath.row)

        if (status!.retweetedStatus != nil) {
            itemViewController.status = status!.retweetedStatus!
            itemViewController.retweetReason = status!.author!.name
        }
        else {
            itemViewController.status = status!
        }
        self.navigationController?.pushViewController(itemViewController, animated: true)
        
        tableView.cellForRowAtIndexPath(indexPath)?.highlighted = false
        tableView.beginUpdates()
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        tableView.endUpdates()
    }
    
    /*func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }*/
    
    
    func signout() {
        User.currentUser?.signout()
    }
    
    func compose() {
        self.composeViewController = ComposeViewController(nibName: "ComposeViewController", bundle: nil)
        self.composeViewController!.composeDelegate = self
        self.navigationController?.presentViewController(composeViewController!, animated: true, completion: { () -> Void in
            println("Launched the compose view")
        })
    }
    
    func dismissComposeView(newStatus: Status?) {
        if (newStatus != nil) {
            // Insert the newly posted status in view
            statusTimeline?.addToBeginning(newStatus!)
            timelineTable.beginUpdates()
            timelineTable.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Bottom)
            timelineTable.endUpdates()
        }
        self.composeViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            println("Dismissed the compose view")
        })
    }
    func toggleFavorite(indexPath: NSIndexPath) {
        timelineTable.beginUpdates()
        timelineTable.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        timelineTable.endUpdates()
    }
    func toggleRetweet(indexPath: NSIndexPath) {
        timelineTable.beginUpdates()
        timelineTable.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        timelineTable.endUpdates()
    }
    func tapReply(indexPath: NSIndexPath) {
        self.composeViewController = ComposeViewController(nibName: "ComposeViewController", bundle: nil)
        self.composeViewController!.composeDelegate = self
        let status = statusTimeline?.getStatus(indexPath.row)
        composeViewController?.replyToScreenName = status?.author?.screenName!
        composeViewController?.replyToId = status?.statusId
        //self.composeViewController!.composeText.text = status!.author!.screenName
        self.navigationController?.presentViewController(composeViewController!, animated: true, completion: { () -> Void in
            println("Launched the compose view")
        })
    }
    func refresh() {
        println(" ")
        println("Pulled down to refresh")

        statusTimeline?.loadNewerWithCompletion(timelineType!, { (success, error) -> () in
            if (success == true) {
                
                println("BACK to the timeline view controller with success")
                self.refreshControl.endRefreshing()
                self.timelineTable.reloadData()
            }
        })
    }
    func loadMore(cell: ProgressTableViewCell) {
        println(" ")
        println("loading more...")
        
        statusTimeline?.loadOlderWithCompletion(timelineType!, { (success, error) -> () in
            if (success == true) {
                self.timelineTable.reloadData()
            }
            cell.progressIndicator.stopAnimating()
        })
    }
    
    func openImage(indexPath: NSIndexPath, url: NSURL, rect: CGRect) {
        let imageViewController = ImageViewController(nibName: "ImageViewController", bundle: nil)
        imageViewController.imageURL = url
        
        let cell = tableView(timelineTable, cellForRowAtIndexPath: indexPath)
        let cellRect = timelineTable.convertRect(timelineTable.rectForRowAtIndexPath(indexPath), toView: timelineTable.superview)
        let imageRect = CGRectMake(rect.origin.x+cellRect.origin.x, rect.origin.y+cellRect.origin.y, rect.width, rect.height)
        
        imageViewController.imageStartRect = imageRect
        imageViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        self.navigationController?.presentViewController(imageViewController, animated: true, completion: { () -> Void in
            println("Launched the image view")
        })
    }
    
    func openCloseMenu() {
        let parentVC = self.parentViewController?.parentViewController as ContainerViewController
        parentVC.openCloseMenu()
    }
    
}