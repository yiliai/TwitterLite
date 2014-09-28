//
//  ComposeViewController.swift
//  TwitterLite
//
//  Created by Yili Aiwazian on 9/25/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import UIKit

let MAX_LENGTH = 140

class ComposeViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var composeText: UITextView!
    
    var composeDelegate: ComposeDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImage.fadeInImageFromURL(User.currentUser!.profileImageUrl!)
        userNameLabel.text = User.currentUser!.name
        let screenName = User.currentUser!.screenName
        screenNameLabel.text = screenName != nil ? "@\(screenName!)" : ""
        
        // Set up rounded corners on the profile image
        profileImage.layer.cornerRadius = 6.0
        profileImage.layer.masksToBounds = true
        
        screenNameLabel.textColor = BLUE_GRAY
        characterCountLabel.textColor = LIGHT_GRAY
        
        // Set up the text compose field
        composeText.textColor = LIGHT_GRAY
        composeText.delegate = self
        composeText.selectedTextRange = composeText.textRangeFromPosition(composeText.beginningOfDocument, toPosition: composeText.beginningOfDocument)
        
        // Tweet button is diabled at first
        tweetButton.enabled = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapTweet(sender: AnyObject) {
        composeText.resignFirstResponder()
        composeDelegate?.dismissComposeView(Status.createStatusFromCurrentUser(composeText.text))
    }
    
    @IBAction func onTapClose(sender: AnyObject) {
        composeText.resignFirstResponder()
        composeDelegate?.dismissComposeView(nil)
    }

    func textViewDidBeginEditing(textView: UITextView) {
        composeText.becomeFirstResponder()
        composeText.textColor = UIColor.blackColor()
        composeText.text = ""
    }
    
    func textViewDidChange(textView: UITextView) {
        
        let length = countElements(composeText.text)
        if length > 0 {
            tweetButton.enabled = true
        }
        characterCountLabel.text = String(MAX_LENGTH - length)
    }
    
    // Set the maximum number of characters of the text view to be MAX_LENGTH
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let newLength = countElements(textView.text) + countElements(text) - range.length
        return (newLength > MAX_LENGTH) ? false : true;
    }
}
