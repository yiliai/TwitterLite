//
//  ProgressTableViewCell.swift
//  Yelp
//
//  Created by Yili Aiwazian on 9/22/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import UIKit

class ProgressTableViewCell: UITableViewCell {

    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    @IBOutlet weak var twitterIcon: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        twitterIcon.hidden = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func endOfList() {
        progressIndicator.stopAnimating()
        twitterIcon.hidden = false
    }
}
