//
//  MenuViewController.swift
//  TwitterLite
//
//  Created by Yili Aiwazian on 10/4/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userName: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let user = User.currentUser
        userProfileImage.layer.cornerRadius = 24.0
        userProfileImage.layer.masksToBounds = true
        userProfileImage.fadeInImageFromURL(User.currentUser!.profileImageUrl!)
        userName.titleLabel?.text = User.currentUser!.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onTapHome(sender: AnyObject) {
        let containerVC = self.parentViewController as ContainerViewController
        containerVC.setViewController(0)
        containerVC.closeMenu()
    }
    
    @IBAction func onTapProfile(sender: AnyObject) {
        let containerVC = self.parentViewController as ContainerViewController
        containerVC.setViewController(1)
        containerVC.closeMenu()
    }
    
    @IBAction func onTapMentions(sender: AnyObject) {
        let containerVC = self.parentViewController as ContainerViewController
        containerVC.setViewController(2)
        containerVC.closeMenu()
    }
    
    @IBAction func onTapSignOut(sender: AnyObject) {
        User.currentUser?.signout()
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
