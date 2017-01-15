//
//  SignInViewController.swift
//  EMP2
//
//  Created by Desmond Boey on 5/1/17.
//  Copyright © 2017 DominicBoey. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {

    
    private let SHOW_MERCHANT_STORYBOARD = "showMerchantStoryBoard"
    private let SHOW_CUSTOMER_STORYBOARD = "showCustomerStoryBoard"
    private let USER_IS_MERCHANT = "true"
    
    
    var pseudoEmail: String?
    
    @IBOutlet weak var userOrMerchantSwitch: UISwitch!
    
    @IBOutlet weak var emailTF: UITextField!
    
    
    @IBOutlet weak var passwordTF: UITextField!
    
    
    @IBAction func unwindToSignInVC(segue: UIStoryboardSegue){}

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboard()

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
                    self.alertUser(title: "Problem with authentication", message: message!)
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
            })
            
        } else {
            ActivityIndicator.stopAnimating()
            alertUser(title: "Email and Password are required", message: "Please enter email and password in the text fields")
            
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

}

extension SignInViewController {
    
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

