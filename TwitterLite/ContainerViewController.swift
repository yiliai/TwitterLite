//
//  ContainerViewController.swift
//  TwitterLite
//
//  Created by Yili Aiwazian on 10/4/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import UIKit

let OPEN_MAX_WIDTH = CGFloat(250)
let THRESHOLD = OPEN_MAX_WIDTH/2.5

class ContainerViewController: UIViewController {

    @IBOutlet weak var contentViewXConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    var menuOpen = false
    @IBOutlet weak var menuView: UIView!
    
    var viewControllers = [UIViewController]()
    var activeViewController: UIViewController? {
        didSet(oldViewControllerOrNil) {
            if activeViewController == oldViewControllerOrNil? {
                return
            }
            if let oldVC = oldViewControllerOrNil {
                oldVC.willMoveToParentViewController(nil)
                oldVC.view.removeFromSuperview()
                oldVC.removeFromParentViewController()
            }
            if let newVC = activeViewController {
                self.addChildViewController(newVC)
                newVC.view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
                newVC.view.frame = contentView.bounds
                contentView.addSubview(newVC.view)
                newVC.didMoveToParentViewController(self)
            }
        }
    }
    var menuViewController: UIViewController? {
        didSet(oldViewControllerOrNil) {
            if let oldVC = oldViewControllerOrNil {
                oldVC.willMoveToParentViewController(nil)
                oldVC.view.removeFromSuperview()
                oldVC.removeFromParentViewController()
            }
            if let newVC = menuViewController {
                self.addChildViewController(newVC)
                newVC.view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
                newVC.view.frame = menuView.bounds
                menuView.addSubview(newVC.view)
                newVC.didMoveToParentViewController(self)
            }
        }
    }
    
    func setupViewControllers() {
        
        // 1. Home Timeline
        let homeViewController = TimelineViewController(nibName: "TimelineViewController", bundle: nil)
        homeViewController.timelineType = .Home
        let navController = UINavigationController(rootViewController: homeViewController)
        viewControllers.append(navController)
        
        // 2. Profile Timeline
        let profileViewController = TimelineViewController(nibName: "TimelineViewController", bundle: nil)
        profileViewController.timelineType = .Profile
        let navController2 = UINavigationController(rootViewController: profileViewController)
        viewControllers.append(navController2)
        
        // 3. Mentions Timeline
        let mentionsViewController = TimelineViewController(nibName: "TimelineViewController", bundle: nil)
        mentionsViewController.timelineType = .Mentions
        let navController3 = UINavigationController(rootViewController: mentionsViewController)
        viewControllers.append(navController3)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if menuOpen == true {
            contentViewXConstraint.constant = OPEN_MAX_WIDTH
        } else {
            contentViewXConstraint.constant = 0
        }
        
        setupViewControllers()
        setViewController(0)
        
        // Set the menu view controller
        let menu = MenuViewController(nibName: "MenuViewController", bundle: nil)
        menuViewController = menu
        
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPan(sender: UIPanGestureRecognizer) {
        
        var location = sender.locationInView(view)
        var translation = sender.translationInView(view)
        var velocity = sender.velocityInView(view)
        
        //imageView.center = location
        
        if (sender.state == UIGestureRecognizerState.Began) {
            //println("pan began")
        } else if (sender.state == UIGestureRecognizerState.Changed){
            //println("pan changed: \(translation.x)")
            
            if(!menuOpen && translation.x > 0 && translation.x <= OPEN_MAX_WIDTH) {
                contentViewXConstraint.constant = -translation.x
                contentView.layoutIfNeeded()
            } else if (menuOpen && translation.x < 0 && translation.x >= -OPEN_MAX_WIDTH) {
                contentViewXConstraint.constant = -OPEN_MAX_WIDTH-translation.x
                contentView.layoutIfNeeded()
            }
            
        } else if (sender.state == UIGestureRecognizerState.Ended) {
            //println("pan ended")
            
            // menu is currently closed
            if (!menuOpen) {
                if (translation.x > THRESHOLD) {
                    openMenu()
                }
                else {
                    closeMenu()
                }
            }
            // menu is currently open
            else {
                if (abs(translation.x) > THRESHOLD) {
                    closeMenu()
                }
                else {
                    openMenu()
                }
            }
        }
    }
    func closeMenu() {
        self.contentView.layoutIfNeeded()
        UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.contentViewXConstraint.constant = 0
            self.contentView.layoutIfNeeded()
            }, completion: nil)
        menuOpen = false
    }
    func openMenu() {
        self.contentView.layoutIfNeeded()
        UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.contentViewXConstraint.constant = -OPEN_MAX_WIDTH
            self.contentView.layoutIfNeeded()
            }, completion: nil)
        menuOpen = true
    }
    
    func openCloseMenu() {
        if menuOpen {
            closeMenu()
        }
        else {
            openMenu()
        }
    }
    
    func setViewController(index: Int) {
        if (index < viewControllers.count) {
            activeViewController = viewControllers[index]
        }
        else {
            println("ERROR")
        }
    }
}
