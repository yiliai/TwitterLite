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
    var imageStartRect: CGRect?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var tapRecognizer: UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.backgroundView.backgroundColor = UIColor.clearColor()
        if imageURL != nil {
            imageView.fadeInImageFromURL(imageURL!)
        }
        
        
        /*if imageStartRect != nil {
            imageView.frame = CGRect(origin: imageStartRect!.origin, size: imageStartRect!.size)
            println(imageView.frame)
            self.imageView.fadeInImageFromURL(self.imageURL!)
            UIView.animateWithDuration(5.0, animations: { () -> Void in
                //self.imageView.fadeInImageFromURL(self.imageURL!)

            })
        }*/
        
        
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
