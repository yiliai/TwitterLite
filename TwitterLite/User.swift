//
//  User.swift
//  TwitterLite
//
//  Created by Yili Aiwazian on 9/26/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import Foundation

var _currentUser: User?

let currentUserKey = "kCurrentUserKey"
let userDidSigninNotification = "userDidSigninNotification"
let userDidSignoutNotification = "userDidSignoutNotification"

class User: NSObject {
    var dictionaryReference: NSDictionary
    var userId: Int?
    var name: String?
    var screenName: String?
    var profileImageUrl: NSURL?
    var following: Bool?
    var friendsCount: Int?
    var followersCount: Int?
    var profileBannerUrl: NSURL?
    var location: String?
    var tagline: String?

    init(dictionary: NSDictionary) {
        self.dictionaryReference = dictionary
        // Get the user id
        if let id = dictionary["id"] as? Int {
            self.userId = id
        }
        // Get the user name
        if let name = dictionary["name"] as? NSString {
            self.name = name
        }
        // Get the user screen name
        if let screen_name = dictionary["screen_name"] as? NSString {
            self.screenName = screen_name
        }
        // Get the profile image url
        if let profile_image_url = dictionary["profile_image_url"] as? NSString {
            self.profileImageUrl = NSURL(string: profile_image_url)
        }
        // Get banner image url
        if let profile_banner_url = dictionary["profile_banner_url"] as? NSString {
            self.profileBannerUrl = NSURL(string: profile_banner_url)
        }
        // Get whether the signed user is following this user
        if let following = dictionary["following"] as? Int {
            self.following = following == 0 ? false : true
        }
        // Get friends count (following)
        if let friends_count = dictionary["friends_count"] as? Int {
            self.friendsCount = friends_count
        }
        // Get followers count
        if let followers_count = dictionary["followers_count"] as? Int {
            self.followersCount = followers_count
        }
        // Get the user location
        if let location = dictionary["location"] as? String {
            self.location = location
        }
        // Get the user description
        if let tagline = dictionary["description"] as? String {
            self.tagline = tagline
        }
    }
    
    func signout() {
        // Clear the current user
        User.currentUser = nil
        // Clear access token
        TwitterLiteClient.sharedInstance.requestSerializer.removeAccessToken()
        // Fire notification
        NSNotificationCenter.defaultCenter().postNotificationName(userDidSignoutNotification, object: nil)
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                var data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil {
                    var dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                var data = NSJSONSerialization.dataWithJSONObject(user!.dictionaryReference, options: nil, error: nil)
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    class var currentUserDictionary: NSDictionary? {
        get {
            if _currentUser == nil {
                return nil
            }
            else {
                let dictionary = NSMutableDictionary()
                dictionary["id"] = _currentUser!.userId
                dictionary["name"] = _currentUser!.name
                dictionary["screen_name"] = _currentUser!.screenName
                dictionary["profile_image_url"] = _currentUser!.profileImageUrl?.description
                dictionary["following"] = _currentUser!.following
                println(_currentUser!)
                return dictionary
            }
        }
    }
    
    func description() -> String {
        let lineBreak = "\n"
        
        let id: String = userId != nil ? String(userId!) : "nil"
        let n = name != nil ? name : "nil"
        let s = screenName != nil ? screenName : "nil"
        let p = profileImageUrl != nil ? profileImageUrl! : "nil"
        let f = following != nil ? following : false

        return "User ID:\(id), Name:\(n), Screen Name:\(s), Following:\(f)\(lineBreak)Profile image: \(p)"
    }
}