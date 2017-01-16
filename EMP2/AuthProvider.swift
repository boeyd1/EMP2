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
    var currentUserIsMerchant : Bool?
    var currentMerchant: Merchant?
    var currentCustomer: Customer?
    
    func login(withEmail: String, password: String, loginHandler: LoginHandler?) {
        
        FIRAuth.auth()?.signIn(withEmail: withEmail, password: password, completion: { (user, error) in
            
            if error != nil {
                self.handleErrors(err: error as! NSError, loginHandler: loginHandler)
            }else{
                loginHandler?(nil)
                
            }
        })
    }
    
    //add function to store user info in database
    
    func signUp(salutation: String, name: String, withEmail: String, actualEmail: String, password: String, mobileNum: String, shopName: String?, shopContactNum: String?, shopAddSt: String?, shopAddBlk: String?, shopAddUnit: String?, shopAddPostCode: String?, isMerchant: Bool, loginHandler: LoginHandler?) {
        
        FIRAuth.auth()?.createUser(withEmail: withEmail, password: password, completion: { (user, error) in
            
            if error != nil {
                self.handleErrors(err: error as! NSError, loginHandler: loginHandler)
            } else{
                
                if user?.uid != nil {
                    
                    //store user in database CHECK IF CUSTOMER OR MERCHANT
                    
                    if isMerchant{
                        
                        var blkNum = (shopAddBlk?.lowercased())!
                        
                        if !blkNum.contains("blk") && !blkNum.contains("block") {
                            blkNum = "blk " + blkNum
                        }
                        
                        var postalCode = (shopAddPostCode?.lowercased())!
                        
                        if postalCode.contains("s") {
                            postalCode = postalCode.substring(from: postalCode.index(postalCode.startIndex, offsetBy: 1))
                        }
                        
                        DBProvider.Instance.saveMerchant(withID: user!.uid, salutation: salutation, name: name, pseudoEmail: withEmail, actualEmail: actualEmail, password: password, mobileNum: mobileNum, shopName: shopName!, shopContactNum: shopContactNum!, shopAddSt: shopAddSt!, shopAddBlk: blkNum, shopAddUnit: shopAddUnit!, shopAddPostCode: postalCode)
                    }else{
                        DBProvider.Instance.saveCustomer(withID: user!.uid, salutation: salutation, name: name, pseudoEmail: withEmail, actualEmail: actualEmail, password: password, mobileNum: mobileNum)
                    }
                    
                    
                    //sign in user
                    self.login(withEmail: withEmail, password: password, loginHandler: loginHandler)
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
