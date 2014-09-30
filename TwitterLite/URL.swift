//
//  URL.swift
//  TwitterLite
//
//  Created by Yili Aiwazian on 9/30/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import Foundation

enum URLType {
    case Text, Media
}

class URL: NSObject {
    var dictionaryReference: NSDictionary?
    var urlType: URLType?
    var displayUrl: String?
    var startIndex: Int?
    var endIndex: Int?
    var mediaUrl: NSURL?
    
    init(dictionary: NSDictionary, type: URLType) {
        self.urlType = type
        self.dictionaryReference = dictionary
        self.displayUrl = dictionary["display_url"] as String?
        if let indices = dictionary["indices"] as? NSArray {
            self.startIndex = indices[0] as? Int
            self.endIndex = indices[1] as? Int
        }
        if let mediaUrl = dictionary["media_url"] as? String {
            self.mediaUrl = NSURL(string: mediaUrl)
        }
    }
}
