//
//  ProfileHeaderView.swift
//  TwitterLite
//
//  Created by Yili Aiwazian on 10/4/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var gradientImage: UIImageView!
    
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    
    var portraitYOffset: CGFloat?
    var landscapeYOffset: CGFloat?
    
    var user: User?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        screenNameLabel.textColor = BLUE_GRAY
        followersLabel.textColor = BLUE_GRAY
        followingLabel.textColor = BLUE_GRAY
        
        profileImage.layer.cornerRadius = 4.0
        profileImage.layer.masksToBounds = true
        profileImage.layer.borderColor = UIColor.whiteColor().CGColor
        profileImage.layer.borderWidth = 3.0
    }
    
    func setUserInfo(user: User) {
        self.user = user
        profileImage.fadeInImageFromURL(user.profileImageUrl!)
        nameLabel.text = user.name!
        screenNameLabel.text = "@" + user.screenName!
        followersCount.text = (user.followersCount!).prettyNumber()
        followingCount.text = (user.friendsCount!).prettyNumber()
       
        let linebreak = "\n"
        let tagline = user.tagline == "" ? "" : user.tagline! + linebreak
        let location = user.location == "" ? "" : user.location
        
        locationLabel.numberOfLines = 0
        locationLabel.text = tagline + location!
        locationLabel.sizeToFit()
        
        if (user.profileBannerUrl != nil) {
            bannerImage.fadeInImageFromURL(user.profileBannerUrl!)
        }
        else {
            bannerImage.backgroundColor = TWITTER_BLUE
        }
    }
    
}
