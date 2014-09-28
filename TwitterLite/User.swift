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

    init(dictionary: NSDictionary) {
        self.dictionaryReference = dictionary
        // Get the user id
        if let id = dictionary["id"] as? Int {
            self.userId = id
        } else {
            self.userId = -1
        }
        // Get the user name
        if let name = dictionary["name"] as? NSString {
            self.name = name
        } else {
            self.name = ""
        }
        // Get the user screen name
        if let screen_name = dictionary["screen_name"] as? NSString {
            self.screenName = screen_name
        } else {
            self.screenName = ""
        }
        // Get the profile image url
        if let profile_image_url = dictionary["profile_image_url"] as? NSString {
            self.profileImageUrl = NSURL(string: profile_image_url)
        }
        // Get whether the signed user is following this user
        if let following = dictionary["following"] as? Int {
            self.following = following == 0 ? false : true
        } else {
            self.following = false
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