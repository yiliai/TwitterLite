//
//  TwitterLiteClient.swift
//  TwitterLite
//
//  Created by Yili Aiwazian on 9/26/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

let BASE_URL = "https://api.twitter.com"
let CONSUMER_KEY = "twn2AJHjJ1QV8VGldiJws2QlG"
let CONSUMER_SECRET = "eQrJ0cVeShk8SLiX80lGyEhcSZU2fc6Q3hJKRYfjKOW5oMewcA"

class TwitterLiteClient: BDBOAuth1RequestOperationManager {
    
    // MARK: Singleton instance
    class var sharedInstance : TwitterLiteClient {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : TwitterLiteClient? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = TwitterLiteClient(baseURL: NSURL(string: BASE_URL), consumerKey: CONSUMER_KEY, consumerSecret: CONSUMER_SECRET)
        }
        return Static.instance!
    }
    
    // MARK: Signin
    func signin() {
        self.requestSerializer.removeAccessToken()
        // 1. Get the request token
        self.fetchRequestTokenWithPath("oauth/request_token", method: "POST", callbackURL: NSURL(string: "twitterlite://oauth"), scope: nil, success: { (requestToken: BDBOAuthToken!) -> Void in
            NSLog("Got the request token")
            // 2. Go to the Twitter sign in URL
            let authURL = NSString(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(NSURL(string: authURL))
            //
            }) { (error: NSError!) -> Void in
            NSLog ("Failure to get the token \(error)")
        }
    }
    
    // MARK: Get home timeline
    func getHomeTimelineWithSuccess(
        success: ((operation: AFHTTPRequestOperation!, response: AnyObject!)->()),
        failure: ((operation: AFHTTPRequestOperation!, error: NSError!)->())) -> [Status] {
            
        var statusArray = [Status]()
        
        if let json: AnyObject = JsonDiskCache.cached() {
            println("Got cache data")
            //println(json)
        }
        else
        {
            self.GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                // Cache the response
                if response != nil {
                    let result = JsonDiskCache.cache(response)
                    println("Cache result: \(result)")
                }
                // Call the success block
                success(operation: operation, response: response)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                // Call the failure block
                failure(operation: operation, error: error)
            })
        }
        return statusArray
    }
    
    // MARK: Get user info
    func getUserInfo(
        success: ((operation: AFHTTPRequestOperation!, response: AnyObject!)->()),
        failure: ((operation: AFHTTPRequestOperation!, error: NSError!)->())) -> AFHTTPRequestOperation {
            return self.GET("1.1/account/verify_credentials.json", parameters: nil, success: success, failure: failure)
    }
}
