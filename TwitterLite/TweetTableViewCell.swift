//
//  TweetTableViewCell.swift
//  TwitterLite
//
//  Created by Yili Aiwazian on 9/23/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import UIKit

let BLUE_GRAY = UIColor(red: 0.53333, green: 0.6, blue: 0.65, alpha: 1.0)


class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var reasonImage: UIImageView!
    @IBOutlet weak var reasonLabel: UILabel!
    
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorScreenNameLabel: UILabel!
    @IBOutlet weak var statusTextLabel: UILabel!
    
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var reasonImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var reasonHeightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setAuthorName(name: String) {
        self.authorNameLabel.numberOfLines = 0
        self.authorNameLabel.text = name
        self.authorNameLabel.sizeToFit()
    }
    
    func setScreenName(screenName: String) {
        self.authorScreenNameLabel.numberOfLines = 0
        self.authorScreenNameLabel.text = screenName
        self.authorScreenNameLabel.sizeToFit()
    }
    
    func setStatusText(text: String) {
        self.statusTextLabel.numberOfLines = 0
        self.statusTextLabel.text = text
        self.statusTextLabel.sizeToFit()
    }
    
    func setAuthorImage(url: NSURL) {
        self.authorImage.fadeInImageFromURL(url)
    }
    
    func setRetweetReason(text: String) {
        
    }
}
