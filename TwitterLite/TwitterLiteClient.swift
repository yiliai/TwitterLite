//
//  TwitterLiteClient.swift
//  TwitterLite
//
//  Created by Yili Aiwazian on 9/26/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

class TwitterLiteClient: BDBOAuth1RequestOperationManager {
    
    // MARK: Singleton instance
    class var sharedInstance : TwitterLiteClient {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : TwitterLiteClient? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = TwitterLiteClient(baseURL: NSURL(string: "https://api.twitter.com"), consumerKey: "twn2AJHjJ1QV8VGldiJws2QlG", consumerSecret: "eQrJ0cVeShk8SLiX80lGyEhcSZU2fc6Q3hJKRYfjKOW5oMewcA")
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
        failure: ((operation: AFHTTPRequestOperation!, error: NSError!)->())) -> AFHTTPRequestOperation {
        return self.GET("1.1/statuses/home_timeline.json", parameters: nil, success: success, failure: failure)
    }
}
