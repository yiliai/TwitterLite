//
//  LogInViewController.swift
//  TwitterLite
//
//  Created by Yili Aiwazian on 9/25/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var signinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapSignin(sender: AnyObject) {
        println("tapped on log in")
        TwitterLiteClient.sharedInstance.signinWithCompletion() {
            (user: User?, error: NSError?) in
            if user != nil {

                let containerViewController = ContainerViewController(nibName: "ContainerViewController", bundle: nil)
                self.presentViewController(containerViewController, animated: true, completion: { () -> Void in
                    NSLog("Successfully pushed the container view")
                })
            }
            else {
                //handle login error
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
