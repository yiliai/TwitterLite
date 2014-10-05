//
//  Int+Extentions.swift
//  TwitterLite
//
//  Created by Yili Aiwazian on 10/5/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import Foundation

extension Int {
    
    func prettyNumber() -> String {
        let num = abs(self)
        var pretty = ""
        
        if (num < 1000) {
            pretty = String(num)
        }
        else if (num < 1000000) {
            let double = Double(Double(num)/1000)
            pretty = NSString(format:"%.1f", double) + "K"
        }
        else {
            let double = Double(Double(num)/1000000)
            pretty = NSString(format:"%.1f", double) + "M"
        }
        
        if (self >= 0) {
            return pretty
        }
        else {
            return "-" + pretty
        }
    }
    
}