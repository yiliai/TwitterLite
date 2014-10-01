//
//  ImageViewController.swift
//  TwitterLite
//
//  Created by Yili Aiwazian on 9/30/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    var imageURL: NSURL?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var backgroundView: UIView!
    
    @IBOutlet var tapRecognizer: UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.backgroundView.backgroundColor = UIColor.clearColor()
        if imageURL != nil {
            imageView.fadeInImageFromURL(imageURL!)
        }
        
        //UIView.animateWithDuration(1.0, animations: { () -> Void in
        
        //    self.backgroundView.backgroundColor = UIColor.blackColor()
        
        //})
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onTap(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            println("Dismissing the image view")
        })
    }

}
