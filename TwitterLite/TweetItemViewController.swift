//
//  TweetItemViewController.swift
//  TwitterLite
//
//  Created by Yili Aiwazian on 9/25/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import UIKit

class TweetItemViewController: UIViewController {

    var status: Status?
    var statusUpdateDelegate: StatusUpdateDelegate?
    var indexPath: NSIndexPath?
    
    @IBOutlet weak var reasonImage: UIImageView!
    @IBOutlet weak var reasonLabel: UILabel!
    
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorScreenNameLabel: UILabel!
    @IBOutlet weak var statusTextLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!

    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!
    
    @IBOutlet weak var separator1: UIView!
    @IBOutlet weak var separator2: UIView!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("item view did load")
        
        if (status != nil) {
            setStatus(self.status!)
        }
        
        // Set up text label colors
        reasonLabel.textColor = BLUE_GRAY
        separator1.backgroundColor = LIGHT_GRAY
        separator2.backgroundColor = LIGHT_GRAY
        authorScreenNameLabel.textColor = BLUE_GRAY
        retweetsLabel.textColor = BLUE_GRAY
        favoritesLabel.textColor = BLUE_GRAY
        timeStampLabel.textColor = BLUE_GRAY
        
        // Set up images to allow tint color
        reasonImage.image = UIImage(named: "retweet").imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        reasonImage.tintColor = BLUE_GRAY
        favoriteButton.setImage(UIImage(named: "favorite").imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: .Normal)
        retweetButton.setImage(UIImage(named: "retweet").imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: .Normal)
        replyButton.setImage(UIImage(named: "reply").imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: .Normal)
        replyButton.tintColor = BLUE_GRAY
        moreButton.setImage(UIImage(named: "dots").imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: .Normal)
        moreButton.tintColor = BLUE_GRAY
        
        // Set up rounded corners on the profile image
        authorImage.layer.cornerRadius = 6.0
        authorImage.layer.masksToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setStatus(status: Status) {
        setAuthorName(status.author!.name)
        setScreenName(status.author!.screenName)
        setStatusText(status.text)
        setAuthorImage(status.author!.profileImageUrl)
        setRetweetCount(status.retweetCount)
        setFavoriteCount(status.favoriteCount)
        setRetweetButton(status.retweeted)
        setFavoriteButton(status.favorited)
    }
    
    func setAuthorName(name: String?) {
        self.authorNameLabel.numberOfLines = 0
        self.authorNameLabel.text = name != nil ? name! : ""
        self.authorNameLabel.sizeToFit()
    }
    
    func setScreenName(screenName: String?) {
        self.authorScreenNameLabel.numberOfLines = 0
        self.authorScreenNameLabel.text = screenName != nil ? "@\(screenName!)" : ""
        self.authorScreenNameLabel.sizeToFit()
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
            self.retweetButton.tintColor = HIGHLIGHT
            self.retweetCount.textColor = HIGHLIGHT
        }
        else {
            self.retweetButton.selected = false
            self.retweetButton.tintColor = BLUE_GRAY
            self.retweetCount.textColor = BLUE_GRAY
        }
    }
    func setFavoriteButton(favorited: Bool?) {
        if (favorited != nil && favorited == true) {
            self.favoriteButton.selected = true
            self.favoriteButton.tintColor = HIGHLIGHT
            self.favoriteCount.textColor = HIGHLIGHT
        }
        else {
            self.favoriteButton.selected = false
            self.favoriteButton.tintColor = BLUE_GRAY
            self.favoriteCount.textColor = BLUE_GRAY
        }
    }
    
    @IBAction func onTapFavorite(sender: AnyObject) {
        status!.toggleFavorite()
        setFavoriteCount(status?.favoriteCount)
        setFavoriteButton(status?.favorited)
        statusUpdateDelegate?.toggleFavorite(indexPath!)
    }
}
