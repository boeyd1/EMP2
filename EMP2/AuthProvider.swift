//
//  AuthProvider.swift
//  EMP2
//
//  Created by Desmond Boey on 5/1/17.
//  Copyright © 2017 DominicBoey. All rights reserved.
//

import Foundation
import FirebaseAuth
import OneSignal
import UIKit

typealias LoginHandler = (_ msg: String?) -> Void

struct LoginErrorCode {
    static let INVALID_EMAIL = "Invalid email address. Please provide a real email address."
    static let WRONG_PASSWORD = "Wrong password. Please enter the correct password."
    static let PROBLEM_CONNECTING = "Problem connecting to database. Please try again later."
    static let USER_NOT_FOUND = "User not found. Please register."
    static let EMAIL_ALREADY_IN_USE = "Email already in use. Please use another email."
    static let WEAK_PASSWORD = "Password should be at least 6 characters long"
}
class AuthProvider {
    private static let _instance = AuthProvider()
    
    static var Instance: AuthProvider {
        return _instance
    }
    
    var userName = ""
    var userNameInitials = ""
    var currentUserIsMerchant : Bool?
    var currentMerchant: Merchant?{
        didSet{
            userName = currentMerchant!.shopName
        }
    }
    var currentCustomer: Customer?{
        didSet{
            userName = currentCustomer!.name
            userNameInitials = (userName.components(separatedBy: " ").reduce("") { $0.0 + String($0.1.characters.first!) }).uppercased()
        }
    }
    
    func login(withEmail: String, password: String, loginHandler: LoginHandler?, completed: ((FIRUser) -> Void)?) {
        
        FIRAuth.auth()?.signIn(withEmail: withEmail, password: password, completion: { (user, error) in
            
            if error != nil {
                self.handleErrors(err: error as! NSError, loginHandler: loginHandler)
            }else{
                
                loginHandler?(nil)
                completed?(user!)
                
                
            }
        })
        
    }
    
    //add function to store user info in database
    
    func signUp(name: String, pseudoEmail: String, actualEmail: String, password: String, mobileNum: String, shopName: String, shopContactNum: String, shopAddSt: String, shopAddBlk: String, shopAddUnit: String, shopAddPostCode: String, isMerchant: Bool, industry: String, profilePicImg: UIImage?, loginHandler: LoginHandler?, saveSuccess: ((Bool) -> Void)?) {
        
        FIRAuth.auth()?.createUser(withEmail: pseudoEmail, password: password, completion: { (user, error) in
            
            if error != nil {
                self.handleErrors(err: error as! NSError, loginHandler: loginHandler)
            } else{
                
                if user?.uid != nil {
                    
                    //store user in database CHECK IF CUSTOMER OR MERCHANT
                    //sign in user
                   self.login(withEmail: pseudoEmail, password: password, loginHandler: loginHandler, completed: { (user) in
                    if isMerchant{
                        
                        DBProvider.Instance.saveMerchant(withID: user.uid, name: name, pseudoEmail: pseudoEmail, actualEmail: actualEmail, password: password, mobileNum: mobileNum, shopName: shopName, shopContactNum: shopContactNum, shopAddSt: shopAddSt, shopAddBlk: shopAddBlk, shopAddUnit: shopAddUnit, shopAddPostCode: shopAddPostCode, industry: industry, profilePicImg: profilePicImg!, saveSuccess: saveSuccess)
                    }else{
                        DBProvider.Instance.saveCustomer(withID: user.uid, name: name, pseudoEmail: pseudoEmail, actualEmail: actualEmail, password: password, mobileNum: mobileNum, saveSuccess: saveSuccess)
                    }
                    })
                }
            }
        })
    }

    
    func isLoggedIn() -> Bool {
        if FIRAuth.auth()?.currentUser != nil {
            return true
        }
        
        return false
        
    }
    
    func logOut() -> Bool {
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                return true
            } catch {
                return false
            }
        }
        return true
    }
    
    func userID() -> String {
        return FIRAuth.auth()!.currentUser!.uid
    }
    
    
    private func handleErrors(err: NSError, loginHandler: LoginHandler?){
        
        if let errCode = FIRAuthErrorCode(rawValue: err.code) {
            
            switch errCode{
                
            case .errorCodeWrongPassword :
                loginHandler?(LoginErrorCode.WRONG_PASSWORD)
                break
                
            case .errorCodeInvalidEmail:
                loginHandler?(LoginErrorCode.INVALID_EMAIL)
                break
                
            case .errorCodeUserNotFound:
                loginHandler?(LoginErrorCode.USER_NOT_FOUND)
                break
                
            case .errorCodeEmailAlreadyInUse:
                loginHandler?(LoginErrorCode.EMAIL_ALREADY_IN_USE)
                break
                
            case .errorCodeWeakPassword:
                loginHandler?(LoginErrorCode.WEAK_PASSWORD)
                break
                
            default:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING)
                break
                
                
            }
        }
        
    }
}
