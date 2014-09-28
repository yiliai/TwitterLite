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
let HIGHLIGHT = UIColor(red: 1.0, green: 0.6745, blue: 0.2, alpha: 1.0)
let decimalFormatter = NSNumberFormatter()

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var reasonImage: UIImageView!
    @IBOutlet weak var reasonLabel: UILabel!
    
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorScreenNameLabel: UILabel!
    @IBOutlet weak var statusTextLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!
    
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var reasonImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var reasonHeightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        decimalFormatter.numberStyle = .DecimalStyle
        retweetCount.textColor = BLUE_GRAY
        favoriteCount.textColor = BLUE_GRAY
        reasonLabel.textColor = BLUE_GRAY
        
        retweetButton.setImage(UIImage(named: "retweet_highlighted"), forState: .Selected)
        favoriteButton.setImage(UIImage(named: "star_highlighted"), forState: .Selected)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
            self.retweetCount.textColor = HIGHLIGHT
        }
        else {
            self.retweetButton.selected = false
            self.retweetCount.textColor = BLUE_GRAY
        }
    }
    func setFavoriteButton(favorited: Bool?) {
        if (favorited != nil && favorited == true) {
            self.favoriteButton.selected = true
            self.favoriteCount.textColor = HIGHLIGHT
        }
        else {
            self.favoriteButton.selected = false
            self.favoriteCount.textColor = BLUE_GRAY
        }
    }
    @IBAction func onTapRetweet(sender: AnyObject) {
        println("tapped on retweet")
    }
    
    @IBAction func onTapFavorite(sender: AnyObject) {
        println("tapped on favorite")
    }
}
