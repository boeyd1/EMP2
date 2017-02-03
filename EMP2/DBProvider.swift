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

protocol FetchMerchantsForChatData: class {
    
    func merchantsForChatDataReceived(merchants: [MerchantForChat])
    
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
    
    func industriesDataReceived(industries: [String: [MerchantInShopView]])
}

protocol FetchSingleMerchantData: class {
    func singleMerchantDataReceived(merchant: Merchant)
}

protocol FetchChatData: class {
    func chatsReceived(chat: [Chat])
}

protocol FetchSingleChatData: class {
    func chatReceived(chat: Chat)
}

protocol FetchChatDataOnce: class {
    func oneChatReceived(chat: Chat)
}

protocol FetchChatIdsData: class {
    func chatIdsReceived(ids: [String])
}

class DBProvider {
    
    
    
    private static let _instance = DBProvider()
    
    weak var customersDelegate: FetchCustomerData?
    weak var merchantsForChatDelegate: FetchMerchantsForChatData?
    weak var userDelegate: FetchCurrentUserData?
    weak var inventoryDelegate: FetchInventoryData?
    weak var followersDelegate: FetchFollowersData?
    weak var merchantIndustriesDelegate: FetchIndustriesData?
    weak var singleMerchantDelegate: FetchSingleMerchantData?
    weak var chatDelegate: FetchChatData?
    weak var singleChatDelegate: FetchSingleChatData?
    weak var oneChatDelegate: FetchChatDataOnce?
    weak var chatIdsDelegate: FetchChatIdsData?
    
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
    var chatRef: FIRDatabaseReference {
        return dbRef.child(Constants.CHAT)
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
    
    //MARK: ONESIGNAL UPDATE FUNC
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
    
    //MARK: CUSTOMER FUNC
    
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

    
    //MARK: MERCHANT FUNC
    
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
        print("getMerchantsInIndustries method called")
        industriesRef.observe(FIRDataEventType.value) { (snapshot:FIRDataSnapshot) in
            
            var industriesMerchant = [String: [MerchantInShopView]]()
            
            if let industriesData = snapshot.value as? NSDictionary {
                
                for (key, value) in industriesData {
                    //key is industry types & values are merchantIds
                    let industry = key as! String
                    if let industryMerchants = value as? NSDictionary {
                        var merchantArray = [MerchantInShopView]()
                        for (mKey, mValue) in industryMerchants {
                            //mKey is merchantId & mValue is shopName/pic
                            
                            if let merchantData = mValue as? NSDictionary{
                                
                                let industry = key as! String
                                let id = mKey as! String
                                let shopName = merchantData[Constants.SHOP_NAME] as! String
                                let shopPicUrl = merchantData[Constants.URL] as! String
                                
                                let merchantInShopView = MerchantInShopView(id: id, shopName: shopName, profilPicUrl: shopPicUrl, industry: industry)
                                
                                merchantArray.append(merchantInShopView)
                                
                            }
                        }
                        industriesMerchant[industry] = merchantArray
                    }
                }
                
                
            }
            self.merchantIndustriesDelegate?.industriesDataReceived(industries: industriesMerchant)
            
        }
    }
    
    func getMerchantProfileImageUrl(withId: String, url: @escaping (String) -> Void) {
        
        
        merchantsRef.child(withId).child(Constants.URL).observeSingleEvent(of: FIRDataEventType.value) { (snapshot: FIRDataSnapshot) in
            
            if let urlStr = snapshot.value as? String {
                url(urlStr)
            }
            
            
        }
        
    }
    
    func getMerchantsForChat() {
        
        merchantsRef.observeSingleEvent(of: FIRDataEventType.value) { (snapshot: FIRDataSnapshot) in
            
            var merchants = [MerchantForChat]()
            
            if let myMerchants = snapshot.value as? NSDictionary {
                for (key, value) in myMerchants {
                    if let merchantData = value as? NSDictionary {
                        if let _ = merchantData[Constants.PSEUDO_EMAIL] as? String {
                            
                            let id = key as! String
                            let shopName = merchantData[Constants.SHOP_NAME] as! String
                            let industry = merchantData[Constants.INDUSTRY] as! String
                            let profilePicUrl = merchantData[Constants.URL] as! String
                            
                            let storageRef = FIRStorage.storage().reference(forURL: profilePicUrl)
                            
                            storageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) in
                                
                                if error != nil {
                                    print("couldn't download profilePicImage")
                                }else{
                                    let profileImage = UIImage(data: data!)
                                    
                                    let newMerchant = MerchantForChat(id: id, displayName: shopName, industry: industry, profilePicImage: profileImage!)
                                    
                                    merchants.append(newMerchant)
                                    
                                    self.merchantsForChatDelegate?.merchantsForChatDataReceived(merchants: merchants)
                                }
                            }
                            
                            
                        }
                    }
                }
            }
            
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
    
    func getMerchantDataWithId(id: String) {
        print("merchantData func called")
        merchantsRef.child(id).observeSingleEvent(of: FIRDataEventType.value) { (snapshot: FIRDataSnapshot) in
            
            if let merchantData = snapshot.value as? NSDictionary {
                let merchantId = id
                let name = merchantData[Constants.NAME] as! String
                let email = merchantData[Constants.ACTUAL_EMAIL] as! String
                let mobileNum = merchantData[Constants.MOBILE_NUM] as! String
                let shopName = merchantData[Constants.SHOP_NAME] as! String
                let shopContact = merchantData[Constants.SHOP_CONTACT_NUM] as! String
                let addressStreet = merchantData[Constants.SHOP_ADDRESS_STREET] as! String
                let addressBlk = merchantData[Constants.SHOP_ADDRESS_BLK] as! String
                let addressUnit = merchantData[Constants.SHOP_ADDRESS_UNIT] as! String
                let addressPostCode = merchantData[Constants.SHOP_ADDRESS_POST_CODE] as! String
                let industry = merchantData[Constants.INDUSTRY] as! String
                let profilePicUrl = merchantData[Constants.URL] as! String
                
                let merchant = Merchant(id: merchantId, name: name, email: email, mobileNum: mobileNum, shopName: shopName, shopContactNum: shopContact, addressStreet: addressStreet, addressBlk: addressBlk, addressUnit: addressUnit, addressPostalCode: addressPostCode, industry: industry, profilePicUrl: profilePicUrl)
                
                self.singleMerchantDelegate?.singleMerchantDataReceived(merchant: merchant)
            }
            
        }
        
    }
    
    func getMerchantInventoryData(id: String){
        
        print("getMerchantInventoryData called with id: \(id)")
        
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
                                
                              print("inventory is appending")
                                self.inventoryDelegate?.inventoryDataReceived(inventories: inventories)
                            }
                        }
                    }
                    
                }
            }
            
        }
        
    }
    
    //MARK: BOTH FUNC
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
    
    //MARK: CHAT FUNC
    
    func checkForExistingChat(customerId: String, merchantId: String, chatId: ((String?) -> Void)?){
        
        customersRef.child(customerId).child(Constants.CHAT_IDS).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            
            if let chatIds = snapshot.value as? NSDictionary{
                
                var idToReturn: String?
                for(key, value) in chatIds{
                    let idToVerify = value as! String
                    if merchantId == idToVerify{
                        idToReturn = key as! String 
                    }
                }
                chatId!(idToReturn)
                
                
            }else{
                chatId!(nil)
            }
        })
    }
    
    func saveNewChatUsers(customerId: String, customerName: String, merchantId: String, merchantName: String, saveSuccess: ((String) -> Void)?){
                                                       
        let chatRefId = self.chatRef.childByAutoId().key
        
        chatRef.child(chatRefId).child(Constants.MERCHANTS).setValue([Constants.MERCHANT_ID: merchantId, Constants.NAME: merchantName])
        
        chatRef.child(chatRefId).child(Constants.CUSTOMERS).setValue([Constants.CUSTOMER_ID: customerId, Constants.NAME: customerName]){
            (error, FIRDatabaseReference) in
            
            if let _ = error {
                print("save new chat failed")
            }else{
                saveSuccess!(chatRefId)
            }
        }
        
        //update Merchant chats
        merchantsRef.child(merchantId).child(Constants.CHAT_IDS).child(chatRefId).setValue( customerId)
       
        
        //update Customer chats
        customersRef.child(customerId).child(Constants.CHAT_IDS).child(chatRefId).setValue(merchantId)
        
    }
    
    func updateChat(id: String, lastMessage: String, lastUpdate: Double, messageId: String){
        
         let dataForChatRef: Dictionary<String, Any> = [Constants.LAST_MESSAGE: lastMessage, Constants.LAST_UPDATE: lastUpdate]
        
        chatRef.child(id).updateChildValues(dataForChatRef)
        
        chatRef.child(id).child(Constants.MESSAGE_IDS).child(messageId).setValue(lastMessage)
    }
    
    func saveMessage(chatId: String, senderId: String, senderDisplayName: String, lastUpdate: Double, type: String, text: String, url: String?){
        
        var data = Dictionary<String, Any>()
        
        if type == Constants.TEXT {
            
            data = [Constants.SENDER_ID: senderId, Constants.SENDER_NAME: senderDisplayName, Constants.LAST_UPDATE: lastUpdate, Constants.TYPE: type, Constants.TEXT: text]
            
            
        } else {
            data = [Constants.SENDER_ID: senderId, Constants.SENDER_NAME: senderDisplayName, Constants.LAST_UPDATE: lastUpdate, Constants.TYPE: type, Constants.TEXT: text, Constants.URL: url!]
        }
        
        let ref = DBProvider.Instance.messagesRef.childByAutoId()
        ref.setValue(data)
        
        self.updateChat(id: chatId, lastMessage: text, lastUpdate: lastUpdate, messageId: ref.key)
    }
    
    func getOneChat(withId: String){
        chatRef.child(withId).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            
            if let chats = snapshot.value as? NSDictionary{
                
                let id = withId
                
                let lastMessage = chats[Constants.LAST_MESSAGE] as? String
                let lastUpdate = chats[Constants.LAST_UPDATE] as? Double
                
                if let customer = chats[Constants.CUSTOMERS] as? NSDictionary {
                    
                    let customerId = customer[Constants.CUSTOMER_ID] as? String
                    
                    let customerName = customer[Constants.NAME] as? String
                    
                    if let merchant = chats[Constants.MERCHANTS] as? NSDictionary {
                        let merchantId = merchant[Constants.MERCHANT_ID] as? String
                        let merchantName = merchant[Constants.NAME] as? String
                        
                        self.getMerchantProfileImageUrl(withId: merchantId!, url: { (url) in
                            
                            let storageRef = FIRStorage.storage().reference(forURL: url)
                            
                            storageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) in
                                
                                if error != nil {
                                    print("couldn't download profilePicImage")
                                }else{
                                    let profileImage = UIImage(data: data!)
                                    
                                    self.oneChatDelegate?.oneChatReceived(chat: Chat(id: id, customerId: customerId!, merchantId: merchantId!, customerDisplayName: customerName!, merchantDisplayName: merchantName!, lastMessage: lastMessage, lastUpdate: lastUpdate, merchantProfileImage: profileImage!))
                                }
                            }
                        })}
                }
                
            }
            
        })
    }
    
    func getChat(withId: String){
        chatRef.child(withId).observe(FIRDataEventType.value, with: { (snapshot) in
            
            if let chats = snapshot.value as? NSDictionary{
                
                let id = withId
                
                let lastMessage = chats[Constants.LAST_MESSAGE] as? String
                let lastUpdate = chats[Constants.LAST_UPDATE] as? Double
                
                if let customer = chats[Constants.CUSTOMERS] as? NSDictionary {
                    
                    let customerId = customer[Constants.CUSTOMER_ID] as? String
                    
                    let customerName = customer[Constants.NAME] as? String
                    
                    if let merchant = chats[Constants.MERCHANTS] as? NSDictionary {
                        let merchantId = merchant[Constants.MERCHANT_ID] as? String
                        let merchantName = merchant[Constants.NAME] as? String
                    
                    self.getMerchantProfileImageUrl(withId: merchantId!, url: { (url) in
                        
                        let storageRef = FIRStorage.storage().reference(forURL: url)
                        
                        storageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) in
                            
                            if error != nil {
                                print("couldn't download profilePicImage")
                            }else{
                                let profileImage = UIImage(data: data!)
                                
                                self.singleChatDelegate?.chatReceived(chat: Chat(id: id, customerId: customerId!, merchantId: merchantId!, customerDisplayName: customerName!, merchantDisplayName: merchantName!, lastMessage: lastMessage, lastUpdate: lastUpdate, merchantProfileImage: profileImage!))
                            }
                        }
                    })}
                }
                
            }
            
        })
    }
    
    func getChatIds(userId: String){
        
        if AuthProvider.Instance.currentUserIsMerchant!{
            
            merchantsRef.child(AuthProvider.Instance.userID()).child(Constants.CHAT_IDS).observe(.value, with: { snapshot in
                
                if let chats = snapshot.value as? NSDictionary{
                    
                    var chatIds = [String]()
                    
                    for (key, _) in chats{
                        chatIds.append(key as! String)
                        
                    }
                    self.chatIdsDelegate?.chatIdsReceived(ids: chatIds)
                }
                
            })
        }else{
            customersRef.child(AuthProvider.Instance.userID()).child(Constants.CHAT_IDS).observe(.value, with: { snapshot in
                
                if let chats = snapshot.value as? NSDictionary{
                    
                    var chatIds = [String]()
                    
                    for (key, _) in chats{
                        chatIds.append(key as! String)
                        
                    }
                    self.chatIdsDelegate?.chatIdsReceived(ids: chatIds)
                }
            })
        }
        
    }
    
    
    func observeChats(withId: [String]) {
        var arrayOfChats = [Chat]()
        
        for id in withId{
            self.chatRef.child(id).observe(.value, with: { snapshot in
                
                if let chats = snapshot.value as? NSDictionary{
                    let id = id
                    let lastMessage = chats[Constants.LAST_MESSAGE] as? String
                    let lastUpdate = chats[Constants.LAST_UPDATE] as? Double
                    
                    
                    if let customer = chats[Constants.CUSTOMERS] as? NSDictionary {
                        
                        let customerId = customer[Constants.CUSTOMER_ID] as? String
                        
                        let customerName = customer[Constants.NAME] as? String
                        
                        if let merchant = chats[Constants.MERCHANTS] as? NSDictionary {
                            let merchantId = merchant[Constants.MERCHANT_ID] as? String
                            let merchantName = merchant[Constants.NAME] as? String
                            
                            self.getMerchantProfileImageUrl(withId: merchantId!, url: { (url) in
                                
                                let storageRef = FIRStorage.storage().reference(forURL: url)
                                
                                storageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) in
                                    
                                    if error != nil {
                                        print("couldn't download profilePicImage")
                                    }else{
                                        let profileImage = UIImage(data: data!)
                                        
                                        arrayOfChats.append(Chat(id: id, customerId: customerId!, merchantId: merchantId!, customerDisplayName: customerName!, merchantDisplayName: merchantName!, lastMessage: lastMessage, lastUpdate: lastUpdate, merchantProfileImage: profileImage!))
                                        
                                        self.chatDelegate?.chatsReceived(chat: arrayOfChats)
                                        
                                    }
                                }
                            })
                        }
                    }
                }
            })
        }
        
        
        
    }
    
    
}

