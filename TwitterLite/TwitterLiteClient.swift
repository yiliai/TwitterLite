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
    
    var statusArray = [Status]()

    var signinCompletion: ((user: User?, error: NSError?)->())?
    
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
    
    // MARK: Signin with completion block
    func signinWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        self.signinCompletion = completion
        
        self.requestSerializer.removeAccessToken()
        // 1. Get the request token
        self.fetchRequestTokenWithPath("oauth/request_token", method: "POST", callbackURL: NSURL(string: "twitterlite://oauth"), scope: nil, success: { (requestToken: BDBOAuthToken!) -> Void in
            NSLog("Got the request token")
            // 2. Go to the Twitter sign in URL
            let authURL = NSString(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(NSURL(string: authURL))
            }) { (error: NSError!) -> Void in
                NSLog ("Failure to get the token \(error)")
                self.signinCompletion?(user: nil, error: error)
        }
    }
    
    func openURL(url: NSURL) {
        var parameters = url.dictionaryFromQueryString()
        if (parameters["oauth_token"] != nil) && (parameters["oauth_verifier"] != nil) {
            
            //3. Fetch access token
            fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuthToken(queryString: url.query), success: { (accessToken: BDBOAuthToken!) -> Void in
                NSLog("Got the access token")
                TwitterLiteClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)

                //4. Get the user credentials
                TwitterLiteClient.sharedInstance.getUserInfo({ (operation, response) -> () in
                    NSLog("User info: \(response)")
                    var user = User(dictionary: response as NSDictionary)
                    //5. Persist the signed in user as the current user
                    User.currentUser = user
                    self.signinCompletion?(user:user, error:nil)
                    }, failure: { (operation, error) -> () in
                        NSLog("Failure to get user info")
                        self.signinCompletion?(user: nil, error: error)
                })
                
                }, failure: { (error: NSError!) -> Void in
                    NSLog("Failure to get the access token \(error)")
                    self.signinCompletion?(user: nil, error: error)
            })
        }
    }
    
    // MARK: Get the home timeline with optional parameters
    func getHomeTimelineWithParams(params: NSDictionary?, completion: (statuses: [Status]?, error: NSError?) -> ()) {
        if let json: AnyObject = JsonDiskCache.cached() {
            println("Got cache data")
            var statuses = Status.parseStatusesFromArray(json as [NSDictionary])
            // Call the completion block
            completion(statuses: statuses, error: nil)
        }
        else
        {
            self.GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                // Cache the response
                if response != nil {
                    let result = JsonDiskCache.cache(response)
                    println("Cache home timeline")
                    
                    var statuses = Status.parseStatusesFromArray(response as [NSDictionary])
                    // Call the completion block
                    completion(statuses: statuses, error: nil)
                }
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    // Call the completion block with error
                    completion(statuses: nil, error: error)
            })
        }
    }
    
    // MARK: Get user info
    func getUserInfo(
        success: ((operation: AFHTTPRequestOperation!, response: AnyObject!)->()),
        failure: ((operation: AFHTTPRequestOperation!, error: NSError!)->())) -> AFHTTPRequestOperation {
            return self.GET("1.1/account/verify_credentials.json", parameters: nil, success: success, failure: failure)
    }
}
