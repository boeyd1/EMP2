//
//  SignInViewController.swift
//  EMP2
//
//  Created by Desmond Boey on 5/1/17.
//  Copyright © 2017 DominicBoey. All rights reserved.
//

import UIKit
import FirebaseAuth
import OneSignal

class SignInViewController: UIViewController {
    
    
    private let SHOW_MERCHANT_STORYBOARD = "showMerchantStoryBoard"
    private let SHOW_CUSTOMER_STORYBOARD = "showCustomerStoryBoard"
    
    private let SHOW_REGISTRATION_VIEW = "showRegistrationVC"
    
    private let USER_IS_MERCHANT = "true"
    
    
    
    var pseudoEmail: String?
    
    @IBOutlet weak var userOrMerchantSwitch: UISwitch!
    
    @IBOutlet weak var emailTF: UITextField!
    
    
    @IBOutlet weak var passwordTF: UITextField!
    
    
    @IBAction func unwindToSignInVC(segue: UIStoryboardSegue){}
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.hideKeyboard()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if AuthProvider.Instance.isLoggedIn() {
            
            if isUserMerchant(email: (FIRAuth.auth()?.currentUser!.email)!) {
                AuthProvider.Instance.currentUserIsMerchant = true
                performSegue(withIdentifier: SHOW_MERCHANT_STORYBOARD, sender: nil)
            }else{
                AuthProvider.Instance.currentUserIsMerchant = false
                performSegue(withIdentifier: SHOW_CUSTOMER_STORYBOARD, sender: nil)
            }
            
           DBProvider.Instance.getUserData(id: AuthProvider.Instance.userID())
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //actions
    @IBAction func loginButtonTapped(_ sender: AnyObject) {
        
        ActivityIndicator.startAnimating()
        
        pseudoEmail = "\(userOrMerchantSwitch.isOn)" + emailTF.text!
        
        if emailTF.text != "" && passwordTF.text != "" {
            
            AuthProvider.Instance.login(withEmail: pseudoEmail!, password: passwordTF.text!, loginHandler: { (message) in
                ActivityIndicator.stopAnimating()
                if message != nil {
                    SimpleAlert.Instance.create(title: "Problem with authentication", message: message!, vc: self, handler: nil)
                    
                }else{
                    
                    self.emailTF.text! = ""
                    self.passwordTF.text! = ""
                    
                    if self.isUserMerchant(email: self.pseudoEmail!) {
                        AuthProvider.Instance.currentUserIsMerchant = true
                        self.performSegue(withIdentifier: self.SHOW_MERCHANT_STORYBOARD, sender: nil)
                    }else{
                        AuthProvider.Instance.currentUserIsMerchant = false
                        self.performSegue(withIdentifier: self.SHOW_CUSTOMER_STORYBOARD, sender: nil)
                    }
                    
                    DBProvider.Instance.getUserData(id: AuthProvider.Instance.userID())
                }
            }, completed: nil)
            
        } else {
            ActivityIndicator.stopAnimating()
            SimpleAlert.Instance.create(title: "Email and Password are required", message: "Please enter email and password in the text fields", vc: self, handler: nil)
        }
    }
    
    func isUserMerchant(email: String) -> Bool {
        let index = email.index(email.startIndex, offsetBy: 4)
        
        let checkUserType = email.substring(to: index)
        
        return checkUserType == USER_IS_MERCHANT
        
        
    }
    
    private func alertUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: SHOW_REGISTRATION_VIEW, sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SHOW_MERCHANT_STORYBOARD {
            
            OneSignal.idsAvailable({ (userId, pushToken) in
                
                print("UserId:%@", userId)
                DBProvider.Instance.updateOneSignalUserId(isMerchant: true, id: userId!)
                if (pushToken != nil) {
                    print("pushToken:%@", pushToken)
                    DBProvider.Instance.updateOneSignalPushToken(isMerchant: true, token: pushToken!)
                    
                }
            })
        }else if segue.identifier == SHOW_CUSTOMER_STORYBOARD {
            OneSignal.idsAvailable({ (userId, pushToken) in
                print("UserId:%@", userId)
                DBProvider.Instance.updateOneSignalUserId(isMerchant: false, id: userId!)
                if (pushToken != nil) {
                    print("pushToken:%@", pushToken)
                    DBProvider.Instance.updateOneSignalPushToken(isMerchant: false, token: pushToken!)
                    
                }
            })
        }
    }
    
    
}
//
//extension SignInViewController {
//    
//    
//    func hideKeyboard()
//    {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        view.addGestureRecognizer(tap)
//    }
//    
//    func dismissKeyboard()
//    {
//        view.endEditing(true)
//    }
//}

