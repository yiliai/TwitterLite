//
//  NSURL+Extensions.swift
//  TwitterLite
//
//  Created by Yili Aiwazian on 9/27/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import Foundation

extension NSURL {
    func dictionaryFromQueryString() -> NSDictionary {
        var dictionary = NSMutableDictionary()
        var pairs = self.query?.componentsSeparatedByString("&")
        
        if (pairs != nil) {
            for pair in pairs! {
                
                let elements = pair.componentsSeparatedByString("=") as [String]
                let key = elements[0].stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
                let val = elements[1].stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
                println("key: \(key)")
                println("val: \(val)")
                
                dictionary[key!] = val
                println(dictionary[key!])
            }
        }
        return dictionary
    }
}