//
//  MerchantNotificationsViewController.swift
//  EMP2
//
//  Created by Desmond Boey on 16/1/17.
//  Copyright © 2017 DominicBoey. All rights reserved.
//

import UIKit
import OneSignal

class MerchantNotificationsViewController: UIViewController, UITextViewDelegate, FetchFollowersData {

    var followerOSIds : [String]?
    
    
    @IBOutlet weak var textView: UITextView!
    var placeholderLabel : UILabel!
    
    @IBOutlet weak var charLimitLabel: UILabel!
    
    @IBAction func sendButtonTapped(_ sender: AnyObject) {
        
        OneSignal.postNotification(["contents": ["en": textView.text], "include_player_ids": followerOSIds!])

        
        
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        DBProvider.Instance.followersDelegate = self
        
        DBProvider.Instance.getMerchantFollowersOSId(merchantId: AuthProvider.Instance.userID())
        
        self.hideKeyboard()
        
        charLimitLabel.text = "0/180 characters"
        
        textView.delegate = self
        
        createTextViewPlaceholder(tv: textView)
        // Do any additional setup after loading the view.
    }
    
    // dataReceived functions
    
    func followersIdReceived(ids: [String]){
        self.followerOSIds = ids
    }
    
    // appearance functions
    
    func createTextViewPlaceholder(tv: UITextView){
        
        placeholderLabel = UILabel()
        placeholderLabel.text = "Type your message here..."
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (textView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newLength = textView.text.characters.count + text.characters.count - range.length
        if(newLength <= 180){
            self.charLimitLabel.text = "\(newLength)/180 characters"
            return true
        }else{
            return false
            
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }

    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
