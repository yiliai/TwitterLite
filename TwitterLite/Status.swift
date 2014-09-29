//
//  Status.swift
//  TwitterLite
//
//  Created by Yili Aiwazian on 9/26/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import Foundation

let STATUS_DATE_FORMAT = "EEE MMM dd HH:mm:ss Z yyyy"

class Status: NSObject {
    
    enum StatusType {
        case Tweet, Retweet
    }
    var dictionaryReference: NSDictionary?
    var statusId: Int?
    var createdAt: NSDate?
    var retweetedStatus: Status?
    var author: User?
    var text: NSString?
    var favoriteCount: Int?
    var retweetCount: Int?
    var favorited: Bool?
    var retweeted: Bool?
    var retweetId: Int?

    init(dictionary: NSDictionary) {
        self.dictionaryReference = dictionary
        // Get the status id
        if let id = dictionary["id"] as? Int {
            self.statusId = id
        }
        // Get the created date of the status
        if let created_at = dictionary["created_at"] as? NSString {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = STATUS_DATE_FORMAT
            self.createdAt = dateFormatter.dateFromString(created_at)
        }
        // Get the retweeted status, if it exists
        if let retweeted_status = dictionary["retweeted_status"] as? NSDictionary {
            self.retweetedStatus = Status(dictionary: retweeted_status)
        }
        // Get the user info
        if let user = dictionary["user"] as? NSDictionary {
            self.author = User(dictionary: user)
        }
        // Get the text of the status
        if let text = dictionary["text"] as? NSString {
            self.text = text
        }
        // Get the favorite count
        if let favorite_count = dictionary["favorite_count"] as? Int {
            self.favoriteCount = favorite_count
        }
        // Get the retweet count
        if let retweet_count = dictionary["retweet_count"] as? Int {
            self.retweetCount = retweet_count
        }
        // Get whether the signed in user as favorited the status
        if let favorited = dictionary["favorited"] as? Int {
            self.favorited = favorited == 0 ? false : true
        }
        // Get whether the signed in user as retweeted the status
        if let retweeted = dictionary["retweeted"] as? Int {
            self.retweeted = retweeted == 0 ? false : true
        }
    }
    
    func description() -> String {
        let lineBreak = "\n"
        
        let id: String = statusId != nil ? String(statusId!) : "nil"
        let c = createdAt != nil ? createdAt! : "nil"
        let rs = retweetedStatus != nil ? retweetedStatus!.description() : "nil"
        let u = author != nil ? author!.description() : "nil"
        let t = text != nil ? text : "nil"
        let fc = favoriteCount != nil ? String(favoriteCount!) : "nil"
        let rc = retweetCount != nil ? String(retweetCount!) : "nil"
        let f = favorited != nil ? favorited : false
        let r = retweeted != nil ? retweeted : false

        return "Status ID:\(id), Created at:\(c)\(lineBreak)User:\(u)\(lineBreak)Text:\(t)\(lineBreak)favoriteCount: \(fc), retweetCount: \(rc), favorited: \(f), retweeted: \(r)\(lineBreak)Retweet: \(rs)"
    }
    
    func toggleFavorite() {
        if favorited == true {
            favorited = false
            decrementFavoriteCount()
            unfavoriteStatus()
        }
        else {
            favorited = true
            incrementFavoriteCount()
            favoriteStatus()
        }
    }
    func toggleRetweet() {
        if retweeted == true {
            retweeted = false
            decrementRetweetCount()
            undoRetweetStatus()
        }
        else {
            retweeted = true
            incrementRetweetCount()
            retweetStatus()
        }
    }
    private func incrementFavoriteCount() {
        if self.favoriteCount == nil {
            self.favoriteCount = 1
        }
        else {
            self.favoriteCount = self.favoriteCount! + 1
        }
    }
    private func decrementFavoriteCount() {
        if self.favoriteCount != nil && self.favoriteCount > 0 {
            self.favoriteCount = self.favoriteCount! - 1
        }
    }
    private func incrementRetweetCount() {
        if self.retweetCount == nil {
            self.retweetCount = 1
        }
        else {
            self.retweetCount = self.retweetCount! + 1
        }
    }
    private func decrementRetweetCount() {
        if self.retweetCount != nil && self.retweetCount > 0 {
            self.retweetCount = self.retweetCount! - 1
        }
    }
    
    class func parseStatusesFromArray(array: [NSDictionary]) -> [Status] {
        var statusArray = [Status]()
        
        for item in array {
            let status = Status(dictionary: item)
            statusArray.append(status)
            println(statusArray.count)
            println(status.description())
        }
        NSLog ("Finished parsing status array")
        return statusArray
    }
    
    class func createStatus(fromUser: User, text: String) -> Status {
        let dictionary = NSMutableDictionary()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = STATUS_DATE_FORMAT
        dictionary["created_at"] = dateFormatter.stringFromDate(NSDate())
        
        dictionary["user"] = fromUser.dictionaryReference
        dictionary["text"] = text
        
        // Actually post it to Twitter
        postStatus(text)
        return Status(dictionary: dictionary)
    }
    
    /*func retweetStatus(fromUser: User) -> Status {
        let dictionary = NSMutableDictionary()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = STATUS_DATE_FORMAT
        dictionary["created_at"] = dateFormatter.stringFromDate(NSDate())
        
        dictionary["retweeted_status"] = self.dictionaryReference
        dictionary["user"] = fromUser.dictionaryReference
        dictionary["text"] = "RT " + "@" + self.author!.screenName! + " " + self.text!
        
        self.retweeted = true
        self.incrementRetweetCount()
        
        // Actually post retweet to Twitter
        retweetStatus()
        return Status(dictionary: dictionary)
    }*/
    
    // MARK: Posting a new status update
    private class func postStatus(text: String) {
        
        println("")
        println("POSTING STATUS...")
        
        let params = NSMutableDictionary()
        params["status"] = text
        TwitterLiteClient.sharedInstance.postStatusWithParams(params, completion: { (status, error) -> () in
            println("Status.postStatus - completed")
        })
    }
    
    // MARK: Favorite this status
    private func favoriteStatus() {
        println("")
        println("FAVORITING STATUS...\(self.statusId)")
        
        let params = NSMutableDictionary()
        params["id"] = self.statusId
        TwitterLiteClient.sharedInstance.favoriteStatusWithParams(params, completion: { (status, error) -> () in
            println("Status.favoriteStatus - completed")
        })
    }
    
    // MARK: Favorite this status
    private func unfavoriteStatus() {
        println("")
        println("UNFAVORITING STATUS...\(self.statusId)")
        
        let params = NSMutableDictionary()
        params["id"] = self.statusId
        TwitterLiteClient.sharedInstance.unfavoriteStatusWithParams(params, completion: { (status, error) -> () in
            println("Status.unfavoriteStatus - completed")
        })
    }
    
    // MARK: Retweet this status
    private func retweetStatus() {
        println("")
        println("RETWEETING STATUS...\(self.statusId)")
        
        let statusString = String(self.statusId!)
        TwitterLiteClient.sharedInstance.retweetStatusWithCompletion(statusString, completion: { (status, error) -> () in
            self.retweetId = status?.statusId
            println("Status.retweetStatus - completed. Retweet id:\(self.retweetId)")
        })
    }
    
    // TODO: Implement me
    private func undoRetweetStatus() {
        println("")
        println("UNDO RETWEETING STATUS...\(self.statusId)")
        
        if (retweetId != nil) {
            let statusString = String(self.retweetId!)
            TwitterLiteClient.sharedInstance.undoRetweetWithCompletion(statusString, completion: { (status, error) -> () in
                println("Undo retweet - completed")
            })
        }
        else {
            println("There's no retweet id - TODO: Figure out how to look up the id")
        }
    }
}