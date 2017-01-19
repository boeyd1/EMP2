//
//  DBProvider.swift
//  EMP2
//
//  Created by Desmond Boey on 6/1/17.
//  Copyright © 2017 DominicBoey. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import UIKit

protocol FetchCustomerData: class {
    
    func customersDataReceived(customers: [Customer])
    
}

protocol FetchMerchantData: class {
    
    func merchantsDataReceived(merchants: [Merchant])
    
}

protocol FetchCurrentUserData: class {
    
    func currentUserDataReceived(user: Any)
    
}

protocol FetchInventoryData: class {
    
    func inventoryDataReceived(inventories: [Inventory])
    
}

protocol FetchFollowersData: class {
    
    func followersIdReceived(ids: [String])
}

protocol FetchIndustriesData: class {
    
    func industriesDataReceived(industries: NSDictionary)
}


class DBProvider {
    
    
    
    private static let _instance = DBProvider()
    
    weak var customersDelegate: FetchCustomerData?
    weak var merchantsDelegate: FetchMerchantData?
    weak var userDelegate: FetchCurrentUserData?
    weak var inventoryDelegate: FetchInventoryData?
    weak var followersDelegate: FetchFollowersData?
    weak var merchantIndustriesDelegate: FetchIndustriesData?
    
    private init() {}
    
    static var Instance: DBProvider {
        return _instance
    }
    
    var dbRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    var merchantsRef: FIRDatabaseReference {
        return dbRef.child(Constants.MERCHANTS)
    }
    
    var inventoriesRef: FIRDatabaseReference {
        return dbRef.child(Constants.INVENTORIES)
    }
    
    var industriesRef: FIRDatabaseReference {
        return dbRef.child(Constants.INDUSTRY)
    }
    
    var customersRef: FIRDatabaseReference {
        return dbRef.child(Constants.CUSTOMERS)
    }
    
    var messagesRef: FIRDatabaseReference {
        return dbRef.child(Constants.MESSAGES)
    }
    
    var mediaMessagesRef: FIRDatabaseReference {
        return dbRef.child(Constants.MEDIA_MESSAGES)
    }
    
    var storageRef: FIRStorageReference {
        return FIRStorage.storage().reference(forURL: "gs://emp2-db1b4.appspot.com")
    }
    
    var imageStorageRef: FIRStorageReference {
        return storageRef.child(Constants.IMAGE_STORAGE)
    }
    
    var videoStorageRef: FIRStorageReference {
        return storageRef.child(Constants.VIDEO_STORAGE)
    }
    
    func updateOneSignalUserId(isMerchant: Bool, id: String){
        if isMerchant{
            let dataForMerchantRef: Dictionary<String, Any> = [Constants.ONE_SIGNAL_UID: id]
            merchantsRef.child(AuthProvider.Instance.userID()).updateChildValues(dataForMerchantRef)
            
        }else{
            let dataForCustomerRef: Dictionary<String, Any> = [Constants.ONE_SIGNAL_UID: id]
            customersRef.child(AuthProvider.Instance.userID()).updateChildValues(dataForCustomerRef)
        }
    }
    
    func updateOneSignalPushToken(isMerchant: Bool, token: String){
        if isMerchant{
            let dataForMerchantRef: Dictionary<String, Any> = [Constants.ONE_SIGNAL_TOKEN: token]
            merchantsRef.child(AuthProvider.Instance.userID()).updateChildValues(dataForMerchantRef)
            
        }else{
            let dataForCustomerRef: Dictionary<String, Any> = [Constants.ONE_SIGNAL_TOKEN: token]
            customersRef.child(AuthProvider.Instance.userID()).updateChildValues(dataForCustomerRef)
        }
        
    }
    
    func createInventory(merchantID: String, shopName: String, name: String, description: String, price: String, quantity: String,url: String){
        
        let dataForInvRef: Dictionary<String, Any> = [Constants.NAME: name, Constants.MERCHANT_ID: merchantID, Constants.SHOP_NAME: shopName, Constants.DESCRIPTION: description, Constants.PRICE: price, Constants.QUANTITY: quantity, Constants.URL: url]
        
        let invId = inventoriesRef.childByAutoId()
        invId.setValue(dataForInvRef)
        
        let idAsString = invId.key
        
        let dataForMerchantRef: Dictionary<String, Any> = [Constants.NAME: name, Constants.DESCRIPTION: description, Constants.PRICE: price, Constants.QUANTITY: quantity, Constants.URL: url]
        
        merchantsRef.child(AuthProvider.Instance.userID()).child(Constants.INVENTORIES).child(idAsString).setValue(dataForMerchantRef)
        
    }
    
    func updateInventory(merchantID: String, inventoryID: String, shopName: String, name: String, description: String, price: String, quantity: String,url: String){
        
        let dataForInvRef: Dictionary<String, Any> = [Constants.NAME: name, Constants.MERCHANT_ID: merchantID, Constants.SHOP_NAME: shopName, Constants.DESCRIPTION: description, Constants.PRICE: price, Constants.QUANTITY: quantity, Constants.URL: url]
        
        let invId = inventoriesRef.child(inventoryID)
        invId.updateChildValues(dataForInvRef)
        
        let idAsString = invId.key
        
        let dataForMerchantRef: Dictionary<String, Any> = [Constants.NAME: name, Constants.DESCRIPTION: description, Constants.PRICE: price, Constants.QUANTITY: quantity, Constants.URL: url]
        
        merchantsRef.child(AuthProvider.Instance.userID()).child(Constants.INVENTORIES).child(idAsString).updateChildValues(dataForMerchantRef)
        
    }
    
    
    
    func saveCustomer(withID: String, name: String, pseudoEmail: String, actualEmail: String, password: String, mobileNum: String, saveSuccess: ((Bool) -> Void)?){
        
        let data: Dictionary<String, Any> = [Constants.PSEUDO_EMAIL: pseudoEmail, Constants.ACTUAL_EMAIL: actualEmail, Constants.PASSWORD: password, Constants.NAME: name, Constants.MOBILE_NUM: mobileNum]
        
        customersRef.child(withID).setValue(data) { (error, FIRDatabaseReference) in
            if let _ = error {
                print("saveCustomer ref error")
            }else{
                saveSuccess!(true)
            }
        }
    }
    
    func saveMerchant(withID: String, name: String, pseudoEmail: String, actualEmail: String, password: String, mobileNum: String, shopName: String, shopContactNum: String, shopAddSt: String, shopAddBlk: String, shopAddUnit: String, shopAddPostCode: String, industry: String, profilePicImg: UIImage, saveSuccess: ((Bool) -> Void)?){
        
        
        let data = UIImageJPEGRepresentation(profilePicImg, 0.1)
        
        DBProvider.Instance.imageStorageRef.child(withID + "\(NSUUID().uuidString).jpg").put(data!,metadata: nil) { (metadata: FIRStorageMetadata?, err: Error?) in
           
            ActivityIndicator.stopAnimating()
           
            if err != nil {
                print("error storing image")
                
            }else{
                
                let profilePicUrl = String(describing: metadata!.downloadURL()!)
                
                let data: Dictionary<String, Any> = [Constants.PSEUDO_EMAIL: pseudoEmail, Constants.ACTUAL_EMAIL: actualEmail, Constants.PASSWORD: password, Constants.NAME: name, Constants.MOBILE_NUM: mobileNum, Constants.SHOP_NAME: shopName, Constants.SHOP_CONTACT_NUM: shopContactNum, Constants.SHOP_ADDRESS_STREET: shopAddSt, Constants.SHOP_ADDRESS_BLK: shopAddBlk, Constants.SHOP_ADDRESS_UNIT: shopAddUnit, Constants.SHOP_ADDRESS_POST_CODE: shopAddPostCode, Constants.INDUSTRY: industry, Constants.URL: profilePicUrl]
                
                self.merchantsRef.child(withID).setValue(data, withCompletionBlock: { (error, FIRDatabaseReference) in
                    if let _ = error {
                        print("saveMerchant ref error")
                    }else{
                        saveSuccess!(true)
                    }
                })
                
                self.updateIndustry(merchantId: withID, shopName: shopName, profilePic: profilePicUrl, industry: industry)
                
            }}
    }
    
    func updateIndustry(merchantId: String, shopName: String, profilePic: String, industry: String){
            if let currIndustry = AuthProvider.Instance.currentMerchant?.industry {
                industriesRef.child(currIndustry).child(merchantId).removeValue(completionBlock: { (error, FIRDatabaseReference) in
                    
                    if error != nil {
                        print("error deleting merchantId from industry data")
                    }else{
                        print("successfully deleted")
                    }
                })
            }
        let data: Dictionary<String, Any> = [Constants.SHOP_NAME: shopName, Constants.URL: profilePic]
        
        industriesRef.child(industry).child(merchantId).setValue(data)
        }
        
        func getMerchantsInIndustries(){
            industriesRef.observe(FIRDataEventType.value) { (snapshot:FIRDataSnapshot) in
                
                var industriesMerchant: Dictionary<String, [String]>
                
                if let industries = snapshot.value as? NSDictionary {
                    for (key,value) in industries {
                        if let merchantData = value as? NSDictionary {
                            let merchantId = merchantData[Constants.MERCHANT_ID]
                            let merchantShopName = merchantData[Constants.SHOP_NAME]
                        }
                    }
                }
            }
        }
        
        func getCustomers() {
            
            customersRef.observeSingleEvent(of: FIRDataEventType.value) { (snapshot: FIRDataSnapshot) in
                
                var customers = [Customer]()
                
                if let mycustomers = snapshot.value as? NSDictionary {
                    for (key, value) in mycustomers {
                        if let customerData = value as? NSDictionary {
                            if let _ = customerData[Constants.PSEUDO_EMAIL] as? String {
                                
                                let id = key as! String
                                let name = customerData[Constants.NAME] as! String
                                let actualEmail = customerData[Constants.ACTUAL_EMAIL] as! String
                                let mobileNum = customerData[Constants.MOBILE_NUM] as! String
                                
                                
                                
                                let newCustomer = Customer(id: id, name: name, email: actualEmail, mobileNum: mobileNum)
                                
                                customers.append(newCustomer)
                            }
                        }
                    }
                }
                self.customersDelegate?.customersDataReceived(customers: customers)
            }   // this delegate calls the dataReceived method so that it can pass the customers from this DBProvider to the VC that extends the protocol FetchData. when the delegate above calls dataReceived, all controllers that extends the protocol FetchData will trigger the method dataReceived and be parsed the customers values from here
        }
        
        func getMerchants() {
            
            merchantsRef.observeSingleEvent(of: FIRDataEventType.value) { (snapshot: FIRDataSnapshot) in
                
                var merchants = [Merchant]()
                
                if let myMerchants = snapshot.value as? NSDictionary {
                    for (key, value) in myMerchants {
                        if let merchantData = value as? NSDictionary {
                            if let _ = merchantData[Constants.PSEUDO_EMAIL] as? String {
                                
                                let id = key as! String
                                let name = merchantData[Constants.NAME] as! String
                                let actualEmail = merchantData[Constants.ACTUAL_EMAIL] as! String
                                let mobileNum = merchantData[Constants.MOBILE_NUM] as! String
                                let shopName = merchantData[Constants.SHOP_NAME] as! String
                                let shopContactNum = merchantData[Constants.SHOP_CONTACT_NUM] as! String
                                let addressStreet = merchantData[Constants.SHOP_ADDRESS_STREET] as! String
                                let addressBlk = merchantData[Constants.SHOP_ADDRESS_BLK] as! String
                                let addressUnit = merchantData[Constants.SHOP_ADDRESS_UNIT] as! String
                                let addressPostalCode = merchantData[Constants.SHOP_ADDRESS_POST_CODE] as! String
                                let industry = merchantData[Constants.INDUSTRY] as! String
                                
                                let profilePicUrl = merchantData[Constants.URL] as! String
                                
                                
                                let newMerchant = Merchant(id: id, name: name, email: actualEmail, mobileNum: mobileNum, shopName: shopName, shopContactNum: shopContactNum, addressStreet: addressStreet, addressBlk: addressBlk, addressUnit: addressUnit, addressPostalCode: addressPostalCode, industry: industry, profilePicUrl: profilePicUrl /*, inventory: nil*/)
                                
                                merchants.append(newMerchant)
                            }
                        }
                    }
                }
                self.merchantsDelegate?.merchantsDataReceived(merchants: merchants)
            }   // this delegate calls the dataReceived method so that it can pass the customers from this DBProvider to the VC that extends the protocol FetchData. when the delegate above calls dataReceived, all controllers that extends the protocol FetchData will trigger the method dataReceived and be parsed the customers values from here
        }
        
        func getMerchantFollowersOSId(merchantId: String){
            
            merchantsRef.child(merchantId).child(Constants.FOLLOWERS).observe(FIRDataEventType.value) {
                (snapshot: FIRDataSnapshot) in
                
                var ids = [String]()
                
                if let followersDict = snapshot.value as? NSDictionary {
                    
                    for (_,value) in followersDict {
                        
                        if let followerData = value as? NSDictionary {
                            
                            let id = followerData[Constants.ONE_SIGNAL_UID] as! String
                            
                            ids.append(id)
                        }
                    }
                }
                self.followersDelegate?.followersIdReceived(ids: ids)
            }
        }
        
        
        func getMerchantInventoryData(id: String){
            
            
            //for customers do they need to see it constantly updating?
            merchantsRef.child(id).child(Constants.INVENTORIES).observe(FIRDataEventType.value) {
                (snapshot: FIRDataSnapshot) in
                
                var inventories = [Inventory]()
                
                if let inventoryDict = snapshot.value as? NSDictionary {
                    
                    for (key, value) in inventoryDict {
                        
                        if let inventoryData = value as? NSDictionary {
                            
                            let iImageURL = inventoryData[Constants.URL] as! String
                            
                            let storageRef = FIRStorage.storage().reference(forURL: iImageURL)
                            
                            //retrieve image with max size 1mb
                            storageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) in
                                
                                let id = key as! String
                                let name = inventoryData[Constants.NAME] as! String
                                let desc = inventoryData[Constants.DESCRIPTION] as! String
                                let price = inventoryData[Constants.PRICE] as! String
                                let quantity = inventoryData[Constants.QUANTITY] as! String
                                
                                
                                if error != nil {
                                    
                                }else{
                                    let img = UIImage(data: data!)
                                    
                                    inventories.append(Inventory(id: id, name: name, description: desc, price: price, quantity: quantity, image: img, url: iImageURL))
                                    
                                    self.inventoryDelegate?.inventoryDataReceived(inventories: inventories)
                                }
                            }
                        }
                        
                    }
                }
                
            }
            
            
        }
        
        func getUserData(id: String) {
            
            if AuthProvider.Instance.currentUserIsMerchant!{
                
                merchantsRef.child(id).observeSingleEvent(of: FIRDataEventType.value) {
                    (snapshot: FIRDataSnapshot) in
                    
                    if let merchantData = snapshot.value as? NSDictionary {
                        
                        let name = merchantData[Constants.NAME] as! String
                        let actualEmail = merchantData[Constants.ACTUAL_EMAIL] as! String
                        let mobileNum = merchantData[Constants.MOBILE_NUM] as! String
                        let shopName = merchantData[Constants.SHOP_NAME] as! String
                        let shopContactNum = merchantData[Constants.SHOP_CONTACT_NUM] as! String
                        let addressStreet = merchantData[Constants.SHOP_ADDRESS_STREET] as! String
                        let addressBlk = merchantData[Constants.SHOP_ADDRESS_BLK] as! String
                        let addressUnit = merchantData[Constants.SHOP_ADDRESS_UNIT] as! String
                        let addressPostalCode = merchantData[Constants.SHOP_ADDRESS_POST_CODE] as! String
                        let industry = merchantData[Constants.INDUSTRY] as! String
                        let profilePicUrl = merchantData[Constants.URL] as! String
                        
                        let newMerchant = Merchant(id: id, name: name, email: actualEmail, mobileNum: mobileNum, shopName: shopName, shopContactNum: shopContactNum, addressStreet: addressStreet, addressBlk: addressBlk, addressUnit: addressUnit, addressPostalCode: addressPostalCode, industry: industry , profilePicUrl: profilePicUrl /* , inventory: nil */)
                        
                        
                        AuthProvider.Instance.currentMerchant = newMerchant
                        
                    }
                }
                
            }else{
                
                customersRef.child(id).observeSingleEvent(of: FIRDataEventType.value) {
                    (snapshot: FIRDataSnapshot) in
                    
                    if let customerData = snapshot.value as? NSDictionary {
                        
                        let name = customerData[Constants.NAME] as! String
                        let actualEmail = customerData[Constants.ACTUAL_EMAIL] as! String
                        let mobileNum = customerData[Constants.MOBILE_NUM] as! String
                        let newCustomer = Customer(id: id, name: name, email: actualEmail, mobileNum: mobileNum)
                        
                        AuthProvider.Instance.currentCustomer = newCustomer
                    }
                }
            }
        }
        
        
        
}


    /* the VC that is inheriting from this class must extend the protocol
     
     //the delegate does what it needs to do in the DBProvider class then the value is sent to the class inheriting the protocol
     
     func dataReceived(customers: [customer]) {
     self.customers = customers
     
     myTable.reloadData()    //tableView
     }
     
     //inside viewDidLoad() include:
     DBProvider.Instance.delegate = self
     DBProvider.Instance.getcustomers()
     
     */

