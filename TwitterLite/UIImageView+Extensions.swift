//
//  UIImageView+Extensions.swift
//  TwitterLite
//
//  Created by Yili Aiwazian on 9/27/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import Foundation

extension UIImageView {
    func fadeInImageFromURL(url: NSURL) {
        let request = NSURLRequest(URL: url)
        self.setImageWithURLRequest(request, placeholderImage: nil, success: { (request, response, image) -> Void in
            if (response == nil) {
                self.image = image
                return
            }
            self.alpha = 0.0
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.image = image
                self.alpha = 1.0
            })
            }, failure: nil)
    }
}
