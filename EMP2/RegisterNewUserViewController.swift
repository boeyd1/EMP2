//
//  RegisterNewUserViewController.swift
//  EMP2
//
//  Created by Desmond Boey on 6/1/17.
//  Copyright © 2017 DominicBoey. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class RegisterNewUserViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    private let SHOW_MERCHANT_STORYBOARD = "showMerchantStoryBoard"
    
    private let SHOW_CUSTOMER_STORYBOARD = "showCustomerStoryBoard"
    
    private let UNWIND_TO_SIGN_IN_VC = "unwindToSignInVC"
    
    var pseudoEmail: String?
    
    @IBOutlet weak var businessInfoLabel: UILabel!
    @IBOutlet weak var viewOnScrollView: UIView!
    @IBOutlet weak var userOrMerchantSwitch: UISwitch!
    @IBOutlet weak var salutationPV: UIPickerView!
    @IBOutlet weak var pickerViewTF: UITextField!
    
    @IBOutlet weak var industryTF: UITextField!
    @IBOutlet weak var industryPV: UIPickerView!
    
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var repeatPasswordTF: UITextField!
    @IBOutlet weak var mobileNumTF: UITextField!
    
    @IBOutlet weak var shopNameTF: UITextField!
    
    @IBOutlet weak var shopNumTF: UITextField!
    @IBOutlet weak var streetTF: UITextField!
    
    @IBOutlet weak var blockTF: UITextField!
    @IBOutlet weak var unitTF: UITextField!
    
    @IBOutlet weak var postalCodeTF: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var heightConstraint : NSLayoutConstraint?
    var regBtnToMobileConstraint : NSLayoutConstraint?
    var bizInfoToMobileConstraint_new : NSLayoutConstraint?
    
    var list = ["Mr", "Ms", "Mrs", "Mdm"]
    
    
    @IBAction func switchChangeValue(_ sender: AnyObject) {
        switchBetweenUserAndMerchantView()
    }
    
    func switchBetweenUserAndMerchantView() {
         if !userOrMerchantSwitch.isOn {
            let screenSize = UIScreen.main.bounds
            let screenHeight = screenSize.height
            
            viewHeightConstraint.isActive = false
            regBtnToBottomConstraint.isActive = false
            regBtnToIndustryPVConstraint.isActive = false
            bizInfoToMobileConstraint.isActive = false
            
            heightConstraint = NSLayoutConstraint(item: viewOnScrollView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: screenHeight)
            
            viewOnScrollView.addConstraint(self.heightConstraint!)
            
            regBtnToMobileConstraint = NSLayoutConstraint(item: registerBtn, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: mobileNumTF, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 50)
            
            bizInfoToMobileConstraint_new = NSLayoutConstraint(item: mobileNumTF, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: businessInfoLabel, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 1000)
            
            view.addConstraints([self.regBtnToMobileConstraint!,self.bizInfoToMobileConstraint_new!])
            
            scrollView.scrollToTop()
            scrollView.isScrollEnabled = false
            
        }else{
            
            
            scrollView.isScrollEnabled = true
            
            heightConstraint?.isActive = false
            
            regBtnToMobileConstraint?.isActive = false
            
            bizInfoToMobileConstraint_new?.isActive = false
            
            viewHeightConstraint.isActive = true
            regBtnToIndustryPVConstraint.isActive = true
            regBtnToBottomConstraint.isActive = true
            bizInfoToMobileConstraint.isActive = true
        }
    }
    
    @IBOutlet var bizInfoToMobileConstraint: NSLayoutConstraint!
    @IBOutlet var regBtnToBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var regBtnToIndustryPVConstraint: NSLayoutConstraint!
    @IBOutlet var viewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        
        industryPV.delegate = self
        industryPV.dataSource = self
        industryTF.delegate = self
        
        switchBetweenUserAndMerchantView()
        salutationPV.delegate = self
        salutationPV.dataSource = self
        pickerViewTF.delegate = self
        
        
        self.hideKeyboard()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
    }
    //Action
    
    @IBAction func signUpButtonTapped(_ sender: AnyObject) {
        
        ActivityIndicator.startAnimating()
        
        pseudoEmail = "\(userOrMerchantSwitch.isOn)" + emailTF.text!
        
        //add other constraints to test if fields are filled
        
        if emailTF.text != "" && passwordTF.text != "" {
            
            if !isValidEmail(testStr: emailTF.text!){
                ActivityIndicator.stopAnimating()
                alertUser(title: "Invalid Email Address", message: "Please enter a valid email address")
                return
            }
            
            if passwordTF.text != repeatPasswordTF.text {
                ActivityIndicator.stopAnimating()
                alertUser(title: "Re-entered Password Does Not Match", message: "Please ensure that both passwords entered are the same")
                
                return
            }
            
            AuthProvider.Instance.signUp(salutation: pickerViewTF.text!, name: nameTF.text!, withEmail: pseudoEmail!, actualEmail: emailTF.text!, password: passwordTF.text!, mobileNum: mobileNumTF.text!, shopName: shopNameTF.text, shopContactNum: shopNumTF.text, shopAddSt: streetTF.text, shopAddBlk: blockTF.text, shopAddUnit: unitTF.text, shopAddPostCode: postalCodeTF.text, isMerchant: userOrMerchantSwitch.isOn, industry: industryTF.text, loginHandler: { (message) in
                
                ActivityIndicator.stopAnimating()
                
                if message != nil {
                    self.alertUser(title: "Problem with creating new user", message: message!)
                }else{
                    
                    self.emailTF.text! = ""
                    self.passwordTF.text! = ""
                    
                    SimpleAlert.Instance.create(title: "", message: "Registration completed!", vc: self) {(handler) in
                        self.performSegue(withIdentifier: self.UNWIND_TO_SIGN_IN_VC, sender: nil)
                        
                    }
                    
                    // need to connect segue on storyboard. currently not connected because not finished
                    
                    
                }
            })
            
         }else{
           ActivityIndicator.stopAnimating()
            alertUser(title: "Email and Password required", message: "Please enter email and password in the text fields")
        }
    }
    
    private func alertUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    // VERIFY EMAIL FUNC
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        print(emailTest.evaluate(with: testStr))
        
        return emailTest.evaluate(with: testStr)
    }
    
    
    
    //PICKER VIEW FUNC
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        if pickerView.tag == 0 {
            return list.count
        }else{
            return Constants.BIZ_CATEGORIES.count
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as! UILabel!
        if label == nil {
            label = UILabel()
        }
        
        
        let data: String!
            
        if pickerView.tag == 0 {
            data = list[row]
        } else {
            data = Constants.BIZ_CATEGORIES[row]
        }
        
        let title = NSAttributedString(string: data, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15.0, weight: UIFontWeightRegular)])
        label?.attributedText = title
        label?.textAlignment = .left
        return label!
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.view.endEditing(true)
        
        if pickerView.tag == 0{
        return list[row]
        } else{
            return Constants.BIZ_CATEGORIES[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        if pickerView.tag == 0{
            self.pickerViewTF.text = self.list[row]
            self.salutationPV.isHidden = true
        }else{
            self.industryTF.text = Constants.BIZ_CATEGORIES[row]
            self.industryPV.isHidden = true
        }
        
        
    }
    
    
    
    // TEXT FIELD FUNCTIONS
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        view.endEditing(true)
        
        
        if textField == self.pickerViewTF {
            self.salutationPV.isHidden = false
           
            
            //if you dont want the users to see the keyboard type:
        } else if textField == self.industryTF {
            self.industryPV.isHidden = false
            
        }
        
        textField.endEditing(true)
        
    }

}

//return scroll view to top
extension UIScrollView {
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
}


//hide stuff
extension RegisterNewUserViewController {

    
    
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
       
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
        salutationPV.isHidden = true
        industryPV.isHidden = true
    }
}

class noAutoScroll : UIScrollView {
    override func scrollRectToVisible(_ rect: CGRect, animated: Bool) {
        
    }
}
