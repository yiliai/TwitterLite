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
    var replyToScreenName: String?
    var replyToId: Int?
    
    
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
        composeText.delegate = self
        // Pre-populate the reply to information if this is a reply
        if (replyToScreenName != nil) {
            composeText.text = "@" + replyToScreenName!
            composeText.textColor = UIColor.blackColor()
            characterCountLabel.text = String(MAX_LENGTH - countElements(composeText.text))
        }
        else {
            composeText.textColor = LIGHT_GRAY
            composeText.selectedTextRange = composeText.textRangeFromPosition(composeText.beginningOfDocument, toPosition: composeText.beginningOfDocument)
        }
        
        // Tweet button is diabled at first
        tweetButton.enabled = false
        
        println(replyToId)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapTweet(sender: AnyObject) {
        composeText.resignFirstResponder()
        composeDelegate?.dismissComposeView(Status.createStatus(User.currentUser!, text: composeText.text, replyToId: replyToId))
    }
    
    @IBAction func onTapClose(sender: AnyObject) {
        composeText.resignFirstResponder()
        composeDelegate?.dismissComposeView(nil)
    }

    func textViewDidBeginEditing(textView: UITextView) {
        composeText.becomeFirstResponder()
        composeText.textColor = UIColor.blackColor()
        
        // Clear the helper text for a brand new tweet
        if (replyToScreenName == nil) {
            composeText.text = ""
        }
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
