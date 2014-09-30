//
//  TweetTableViewCell.swift
//  TwitterLite
//
//  Created by Yili Aiwazian on 9/23/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import UIKit

let BLUE_GRAY = UIColor(red: 0.53333, green: 0.6, blue: 0.65, alpha: 1.0)
let LIGHT_GRAY = UIColor(red: 0.8, green: 0.8392, blue: 0.8666, alpha: 1.0)
let YELLOW_HIGHLIGHT = UIColor(red: 1.0, green: 0.6745, blue: 0.2, alpha: 1.0)
let GREEN_HIGHLIGHT = UIColor(red: 0.46667, green: 0.698, blue: 0.3333, alpha: 1.0)
let decimalFormatter = NSNumberFormatter()

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var reasonImage: UIImageView!
    @IBOutlet weak var reasonLabel: UILabel!
    
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorScreenNameLabel: UILabel!
    @IBOutlet weak var statusTextLabel: UILabel!
    @IBOutlet weak var timeSinceCreation: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!
    
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var reasonImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var reasonHeightConstraint: NSLayoutConstraint!

    var status: Status?
    var statusUpdateDelegate: StatusUpdateDelegate?
    var indexPath: NSIndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        decimalFormatter.numberStyle = .DecimalStyle
        retweetCount.textColor = BLUE_GRAY
        favoriteCount.textColor = BLUE_GRAY
        reasonLabel.textColor = BLUE_GRAY
        authorScreenNameLabel.textColor = BLUE_GRAY
        timeSinceCreation.textColor = BLUE_GRAY
        
        authorImage.layer.cornerRadius = 6.0
        authorImage.layer.masksToBounds = true

        // Set up images to allow tint color
        reasonImage.image = UIImage(named: "retweet").imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        reasonImage.tintColor = BLUE_GRAY
        favoriteButton.setImage(UIImage(named: "favorite").imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: .Normal)
        retweetButton.setImage(UIImage(named: "retweet").imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: .Normal)
        replyButton.setImage(UIImage(named: "reply").imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: .Normal)
        replyButton.tintColor = LIGHT_GRAY
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setStatus(status: Status) {
        self.status = status
        setAuthorName(status.author!.name)
        setScreenName(status.author!.screenName)
        setStatusText(status.text)
        setAuthorImage(status.author!.profileImageUrl)
        setRetweetCount(status.retweetCount)
        setFavoriteCount(status.favoriteCount)
        setRetweetButton(status.retweeted)
        setFavoriteButton(status.favorited)
        setTimeStamp(status.createdAt)
    }
    
    func setAuthorName(name: String?) {
        self.authorNameLabel.numberOfLines = 0
        self.authorNameLabel.text = name != nil ? name! : ""
        self.authorNameLabel.sizeToFit()
    }
    
    func setScreenName(screenName: String?) {
        self.authorScreenNameLabel.text = screenName != nil ? "@\(screenName!)" : ""
    }
    
    func setStatusText(text: String?) {
        self.statusTextLabel.numberOfLines = 0
        self.statusTextLabel.text = text ?? ""
        self.statusTextLabel.sizeToFit()
    }
    
    func setAuthorImage(url: NSURL?) {
        if url != nil {
            self.authorImage.fadeInImageFromURL(url!)
        }
    }
    
    func setRetweetReason(name: String?) {
        if (name != nil) {
            reasonLabel.text = "\(name!) retweeted"
            topMarginConstraint.constant = 12
            reasonImageHeightConstraint.constant = 15
            reasonHeightConstraint.constant = 15
        }
        else {
            topMarginConstraint.constant = 4
            reasonImageHeightConstraint.constant = 0
            reasonHeightConstraint.constant = 0
        }
    }
    
    func setRetweetCount(count: Int?) {
        
        if (count != nil && count! != 0) {
            self.retweetCount.text = decimalFormatter.stringFromNumber(count!)
        }
        else {
            self.retweetCount.text = ""
        }
    }
    
    func setFavoriteCount(count: Int?) {
        if (count != nil && count! != 0) {
            self.favoriteCount.text = decimalFormatter.stringFromNumber(count!)
        }
        else {
            self.favoriteCount.text = ""
        }
    }
    
    func setRetweetButton(retweeted: Bool?) {
        if (retweeted != nil && retweeted == true) {
            self.retweetButton.selected = true
            self.retweetButton.tintColor = GREEN_HIGHLIGHT
            self.retweetCount.textColor = GREEN_HIGHLIGHT
        }
        else {
            self.retweetButton.selected = false
            self.retweetButton.tintColor = LIGHT_GRAY
            self.retweetCount.textColor = BLUE_GRAY
        }
    }
    func setFavoriteButton(favorited: Bool?) {
        if (favorited != nil && favorited == true) {
            self.favoriteButton.selected = true
            self.favoriteButton.tintColor = YELLOW_HIGHLIGHT
            self.favoriteCount.textColor = YELLOW_HIGHLIGHT
        }
        else {
            self.favoriteButton.selected = false
            self.favoriteButton.tintColor = LIGHT_GRAY
            self.favoriteCount.textColor = BLUE_GRAY
        }
    }
    
    func setTimeStamp(createdAt: NSDate?) {
        if createdAt != nil {
            self.timeSinceCreation.text = createdAt!.prettyTimeElapsed()
        }
        else {
            self.timeSinceCreation.text = ""
        }
    }
    
    @IBAction func onTapReply(sender: AnyObject) {
        statusUpdateDelegate?.tapReply(indexPath!)
    }
    
    @IBAction func onTapRetweet(sender: AnyObject) {
        //statusUpdateDelegate?.retweetStatus(status!.retweetStatus(User.currentUser!))
        status!.toggleRetweet()
        setRetweetButton(status?.retweeted)
        setRetweetCount(status?.retweetCount)
    }
    
    @IBAction func onTapFavorite(sender: AnyObject) {
        status!.toggleFavorite()
        setFavoriteCount(status?.favoriteCount)
        setFavoriteButton(status?.favorited)
    }
}
