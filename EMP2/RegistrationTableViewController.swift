//
//  RegistrationTableViewController.swift
//  EMP2
//
//  Created by Desmond Boey on 19/1/17.
//  Copyright © 2017 DominicBoey. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class RegistrationTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private let SHOW_MERCHANT_STORYBOARD = "showMerchantStoryBoard"
    private let SHOW_CUSTOMER_STORYBOARD = "showCustomerStoryBoard"
    private let UNWIND_TO_SIGN_IN_VC = "unwindToSignInVC"
    
    @IBOutlet weak var profilePicImg: UIImageView!
    @IBOutlet weak var userOrMerchantSwitch: UISwitch!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var mobileNumTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var repeatPasswordTF: UITextField!
    @IBOutlet weak var shopNameTF: UITextField!
    @IBOutlet weak var shopNumTF: UITextField!
    @IBOutlet weak var industryPV: UIPickerView!
    @IBOutlet weak var streetTF: UITextField!
    @IBOutlet weak var blockTF: UITextField!
    @IBOutlet weak var unitTF: UITextField!
    @IBOutlet weak var postalCodeTF: UITextField!
    
    @IBOutlet weak var viewWithProfilePic: UIView!
    
    
    var pseudoEmail: String?
    var userIsMerchant = false
    
    var photoTakingHelper : PhotoTakingHelper?
    
    @IBAction func switchChangeValue(_ sender: Any) {
        if userOrMerchantSwitch.isOn {
            userIsMerchant = true
            viewWithProfilePic.frame.size.height = 120
            profilePicImg.image = UIImage(named: "addImage")
        }else{
            userIsMerchant = false
            viewWithProfilePic.frame.size.height = 0
            profilePicImg.image = nil
        }
        tableView.reloadData()
    }
    
    @IBAction func changeProfilePicBtnTapped(_ sender: Any) {
        
        photoTakingHelper = PhotoTakingHelper(viewController: self, callback: { (image: UIImage?) in
            self.profilePicImg.image = image
        })
        
    }
    @IBAction func createNewAccountBtnTapped(_ sender: Any) {
        ActivityIndicator.startAnimating()
        
        pseudoEmail = "\(userOrMerchantSwitch.isOn)" + emailTF.text!
        
        //add other constraints to test if fields are filled
        if userIsMerchant {
            if emailTF.text == "" && passwordTF.text == "" && nameTF.text == "" && mobileNumTF.text == "" && shopNameTF.text == "" && streetTF.text == "" && blockTF.text == "" && unitTF.text == "" && postalCodeTF.text == "" {
               
                ActivityIndicator.stopAnimating()
                SimpleAlert.Instance.create(title: "Fields not completed", message: "Please fill up all input fields", vc: self, handler: nil)
                return
            }
            
            if profilePicImg.image == UIImage(named: "addImage") {
                
                ActivityIndicator.stopAnimating()
                SimpleAlert.Instance.create(title: "Error", message: "Please select a profile image", vc: self, handler: nil)
                return
                
            }
        } else {
            
            if emailTF.text == "" && passwordTF.text == "" && nameTF.text == "" && mobileNumTF.text == "" {
                
                ActivityIndicator.stopAnimating()
                SimpleAlert.Instance.create(title: "Fields not completed", message: "Please fill up all input fields", vc: self, handler: nil)
                return
            }
        }
        
            if !isValidEmail(testStr: emailTF.text!){
                ActivityIndicator.stopAnimating()
                SimpleAlert.Instance.create(title: "Invalid Email Address", message: "Please enter a valid email address", vc: self, handler: nil)
                return
            }
            
            if passwordTF.text != repeatPasswordTF.text {
                ActivityIndicator.stopAnimating()
                SimpleAlert.Instance.create(title: "Re-entered Password Does Not Match", message: "Please ensure that both passwords entered are the same",vc: self, handler: nil)
                
                return
            }
            
            let industryText = Constants.BIZ_CATEGORIES[self.industryPV.selectedRow(inComponent: 0)]
            
        AuthProvider.Instance.signUp(name: self.nameTF.text!, pseudoEmail: self.pseudoEmail!.lowercased(), actualEmail: self.emailTF.text!.lowercased(), password: self.passwordTF.text!, mobileNum: self.mobileNumTF.text!, shopName: self.shopNameTF.text!, shopContactNum: self.shopNumTF.text!, shopAddSt: self.streetTF.text!, shopAddBlk: self.blockTF.text!, shopAddUnit: self.unitTF.text!, shopAddPostCode: self.postalCodeTF.text!, isMerchant: self.userOrMerchantSwitch.isOn, industry: industryText, profilePicImg: self.profilePicImg.image, loginHandler: { (message) in
                
            
                
                if message != nil {
                    ActivityIndicator.stopAnimating()
                    SimpleAlert.Instance.create(title: "Problem with creating new user", message: message!, vc: self, handler: nil)
                }else{
                    
                    self.nameTF.text = ""
                    self.emailTF.text = ""
                    self.mobileNumTF.text = ""
                    self.passwordTF.text = ""
                    self.repeatPasswordTF.text = ""
                    self.shopNameTF.text = ""
                    self.shopNameTF.text = ""
                    self.streetTF.text = ""
                    self.blockTF.text = ""
                    self.unitTF.text = ""
                    self.postalCodeTF.text = ""
                    
                    
                }
        }, saveSuccess: { (success) in
            
                ActivityIndicator.stopAnimating()
                SimpleAlert.Instance.create(title: "", message: "Registration Successful!", vc: self, handler: { (action) in
                    self.performSegue(withIdentifier: self.UNWIND_TO_SIGN_IN_VC, sender: nil)
                })
        
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewWithProfilePic.frame.size.height = 0
        
        nameTF.text = ""
        emailTF.text = ""
        mobileNumTF.text = ""
        passwordTF.text = ""
        repeatPasswordTF.text = ""
        shopNameTF.text = ""
        shopNameTF.text = ""
        streetTF.text = ""
        blockTF.text = ""
        unitTF.text = ""
        postalCodeTF.text = ""
        
        tableView.delegate = self
        tableView.dataSource = self
        industryPV.delegate = self
        industryPV.dataSource = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    // VERIFY EMAIL FUNC
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        print(emailTest.evaluate(with: testStr))
        
        return emailTest.evaluate(with: testStr)
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if !userIsMerchant && section == 2 {
            return 0.1
        }else if !userIsMerchant && section == 3 {
            return 0.1
        }else if !userIsMerchant && section == 4 {
            return 0.1
        }
        return super.tableView(tableView, heightForHeaderInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0{
            return  "REGISTER AS:"
        } else if section == 1 {
            return "PERSONAL PARTICULARS"
        } else if section == 2 {
            if !userIsMerchant {
                return ""
            }else{
                return "BUSINESS INFORMATION"
            }
        } else if section == 3 {
            if !userIsMerchant {
                return ""
            }else{
                return "SELECT INDUSTRY:"
            }
        } else if section == 4 {
            if !userIsMerchant {
                return ""
            }else{
                return "SHOP ADDRESS"
            }
        }
        return ""
    }
    
       override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            if !userIsMerchant && section == 2 {
                return 0.1
            }else if !userIsMerchant && section == 3 {
                return 0.1
            }else if !userIsMerchant && section == 4 {
                return 0.1
            }
            return super.tableView(tableView, heightForFooterInSection: section)
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            if section == 2 {
                if !userIsMerchant {
                    return 0
                }else{
                    return 2
                }
            }
            
            if section == 3 {
                if !userIsMerchant {
                    return 0
                }else{
                    return 1
                }
            }
            if section == 4 {
                if !userIsMerchant {
                    return 0
                }else{
                    return 2
                }
            }
            
            return super.tableView(tableView, numberOfRowsInSection: section)
            
        }
        
        //PICKER VIEW FUNC
        
        public func numberOfComponents(in pickerView: UIPickerView) -> Int{
            return 1
            
        }
        
        public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
            
            return Constants.BIZ_CATEGORIES.count
            
        }
        
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            var label = view as! UILabel!
            if label == nil {
                label = UILabel()
            }
            
            
            let data = Constants.BIZ_CATEGORIES[row]
            
            let title = NSAttributedString(string: data, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightRegular)])
            label?.attributedText = title
            label?.textAlignment = .left
            return label!
            
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            
            return Constants.BIZ_CATEGORIES[row]
            
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            
            
        }
        
        
}


