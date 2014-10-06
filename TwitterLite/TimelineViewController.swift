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
    func openProfile(user: User)
}
class TimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ComposeDelegate, StatusUpdateDelegate, UIScrollViewDelegate {

    @IBOutlet weak var timelineTable: UITableView!
    @IBOutlet var timelineView: UIView!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    
    var tableHeaderView: ProfileHeaderView?
    var timelineType=TimelineType.Home
    var statusTimeline = StatusArray()
    var composeViewController: ComposeViewController?
    let refreshControl = UIRefreshControl()
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (self == self.navigationController?.viewControllers[0] as UIViewController) {
            // Add the menu button
            let menuButton = UIBarButtonItem(image: UIImage(named: "menu"), style: UIBarButtonItemStyle.Plain, target: self, action: "openCloseMenu")
            self.navigationItem.setLeftBarButtonItem(menuButton, animated: true)
        }
        else {
            let backButton = UIBarButtonItem(image: UIImage(named: "back"), style: UIBarButtonItemStyle.Plain, target: self, action: "back")
            var negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
            negativeSpacer.width = -4;
            self.navigationItem.setLeftBarButtonItems([negativeSpacer, backButton], animated: false)
        }
        
        if user == nil {
            user = User.currentUser!
        }
        
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
        
        // Set up the pull to refresh control
        refreshControl.addTarget(self, action:"refresh", forControlEvents: UIControlEvents.ValueChanged)
        timelineTable.addSubview(refreshControl)
        
    }

    override func viewWillAppear(animated: Bool) {
        // Skin the navigation bar
        let navigationBar = self.navigationController?.navigationBar

        // Setting the profile view header
        if (self.tableHeaderView != nil) {
            timelineTable.tableHeaderView = self.tableHeaderView

            navigationBar?.setBackgroundImage(UIImage(), forBarMetrics: .Default)
            navigationBar?.shadowImage = UIImage()
            navigationBar?.translucent = true
            println("HEADER HEIGHT:\(self.tableHeaderView!.frame)  \(self.tableHeaderView!.bounds)")

        }
        else {
            navigationBar?.setBackgroundImage(nil, forBarMetrics: .Default)
            navigationBar?.shadowImage = nil
            navigationBar?.barTintColor = TWITTER_BLUE
            navigationBar?.tintColor = UIColor.whiteColor()
            let titleSytle: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            navigationBar?.titleTextAttributes = titleSytle
            self.navigationItem.title = timelineType.getTitle()
            navigationBar?.barStyle = UIBarStyle.Black
        }
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
        return statusTimeline.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (indexPath.row == statusTimeline.count) {
            
            println("At the end of the list")
            let cell = tableView.dequeueReusableCellWithIdentifier("progressCell", forIndexPath: indexPath) as ProgressTableViewCell
            cell.progressIndicator.startAnimating()
            
            // load older here
            loadMore(cell, user: user)
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("statusCell", forIndexPath: indexPath) as TweetTableViewCell
        cell.statusUpdateDelegate = self
        cell.indexPath = indexPath
        
        let status = statusTimeline.getStatus(indexPath.row)
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
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let status = statusTimeline.getStatus(indexPath.row)
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

        let status = statusTimeline.getStatus(indexPath.row)

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
            statusTimeline.addToBeginning(newStatus!)
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
        let status = statusTimeline.getStatus(indexPath.row)
        composeViewController?.replyToScreenName = status?.author?.screenName!
        composeViewController?.replyToId = status?.statusId
        self.navigationController?.presentViewController(composeViewController!, animated: true, completion: { () -> Void in
            println("Launched the compose view")
        })
    }
    func refresh() {
        println(" ")
        println("Pulled down to refresh")

        statusTimeline.loadNewerWithCompletion(timelineType, { (success, error) -> () in
            if (success == true) {
                
                println("BACK to the timeline view controller with success")
                self.refreshControl.endRefreshing()
                self.timelineTable.reloadData()
            }
        })
    }
    func loadMore(cell: ProgressTableViewCell, user: User) {
        println(" ")
        println("loading more...\(user.userId!)")
        
        statusTimeline.loadOlderWithCompletion(timelineType, user: user, { (success, error) -> () in
            if (success == true) {
                self.timelineTable.reloadData()
                println("timeline view controller: load older success")
            }
            cell.progressIndicator.stopAnimating()
            cell.endOfList()
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
    
    func openProfile(user: User) {
        
        println("open profile from table view controller")
        let profileViewController = TimelineViewController(nibName: "TimelineViewController", bundle: nil)
        profileViewController.timelineType = .Profile
        let headerView = NSBundle.mainBundle().loadNibNamed("ProfileHeaderView", owner: self, options: nil).first as ProfileHeaderView
        headerView.layoutIfNeeded()
        headerView.setUserInfo(user)
        profileViewController.user = user
        profileViewController.setProfileHeaderView(headerView)
        self.navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    func openCloseMenu() {
        let parentVC = self.parentViewController?.parentViewController as ContainerViewController
        parentVC.openCloseMenu()
    }
    
    func setProfileHeaderView(profileHeader: ProfileHeaderView) {
        println("SET TABLE VIEW HEADER")
        self.tableHeaderView = profileHeader
    }
    

    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        if self.tableHeaderView != nil {
            if toInterfaceOrientation == UIInterfaceOrientation.Portrait {
                self.tableHeaderView!.topMarginConstraint.constant = -64
                self.tableHeaderView?.layoutIfNeeded()
            }
            else {
                self.tableHeaderView!.topMarginConstraint.constant = -32
                self.tableHeaderView?.layoutIfNeeded()
            }
        }
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if (timelineTable.tableHeaderView != nil) {
            
            let view = timelineTable.tableHeaderView! as ProfileHeaderView
            let frame = view.line.convertRect(CGRectZero, toView: self.view)
            println(frame)
            var offset: CGFloat
            if UIDevice.currentDevice().orientation == .Portrait {
                offset = CGFloat(64)
            }
            else {
                offset = CGFloat(32)
            }
            timelineTable.tableHeaderView!.frame = CGRectMake(0, 0, self.view.frame.width, frame.origin.y-offset)
        }
        return 0
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if (timelineType != .Profile) {
            return
        }
        if timelineTable.tableHeaderView != nil {
            var offset = scrollView.contentOffset.y
            //println(offset)
            if (offset == 0) {
                return
            }
            if UIDevice.currentDevice().orientation == .Portrait {
                offset += CGFloat(64)
            }
            else {
                offset += CGFloat(32)
            }
            offset = offset*(-1)
            let navigationBar = self.navigationController?.navigationBar

            if (offset >= 0) {
                self.tableHeaderView!.bannerImage.transform = CGAffineTransformMakeScale(1+offset/50, 1+offset/50)
                self.tableHeaderView!.gradientImage.transform =
                    CGAffineTransformMakeScale(1+offset/50, 1+offset/50)
            }
            else if (offset > -44) {
                self.tableHeaderView!.profileImage.transform = CGAffineTransformMakeScale(1+offset/88, 1+offset/88)
                navigationBar?.setBackgroundImage(UIImage(), forBarMetrics: .Default)
                navigationBar?.shadowImage = UIImage()
                navigationBar?.translucent = true
                navigationBar?.topItem!.title = timelineType.getTitle()
            }
            else if (offset > -108) {
                navigationBar?.setBackgroundImage(nil, forBarMetrics: .Default)
                navigationBar?.shadowImage = nil
                navigationBar?.barTintColor = TWITTER_BLUE
            }
            else {
                navigationBar?.tintColor = UIColor.whiteColor()
                let titleSytle: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
                navigationBar?.titleTextAttributes = titleSytle
                self.navigationItem.title = user.name
                navigationBar?.barStyle = UIBarStyle.Black
            }
        }
    }
    
    func back() {
        println("back")
        self.navigationController?.popViewControllerAnimated(true)
    }
}