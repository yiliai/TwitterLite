//
//  Status.swift
//  TwitterLite
//
//  Created by Yili Aiwazian on 9/26/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import Foundation

class Status {
    
    enum StatusType {
        case Tweet, Retweet
    }
    var dictionaryReference: NSDictionary?
    var id: Int?
    var createdAt: NSDate?
    var retweetedStatus: Status?
    var user: User?
    var favoriateCount: Int?
    var retweetCount: Int?
    var favorited: Bool?
    var retweeted: Bool?

    init(dictionary: NSDictionary) {
        
    }
}