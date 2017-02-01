//
//  Merchant.swift
//  EMP2
//
//  Created by Desmond Boey on 11/1/17.
//  Copyright © 2017 DominicBoey. All rights reserved.
//

import Foundation
import FirebaseStorage
import UIKit

class Merchant: User {
    
    private var _id = ""
    private var _name = ""
    private var _email = ""
    private var _mobileNum = ""
    
    private var _shop_name = ""
    private var _shop_contact_num = ""
    private var _address_street = ""
    private var _address_blk = ""
    private var _address_unit = ""
    private var _address_postalCode = ""
    private var _industry = ""
    private var _profilePicUrl = ""
    
   // var _inventory : [Inventory]?
    
    init(id: String, name: String, email: String, mobileNum: String, shopName: String?, shopContactNum: String?, addressStreet: String?, addressBlk: String?, addressUnit: String?, addressPostalCode: String?, industry: String?, profilePicUrl: String? /*, inventory: [Inventory]?*/) {
        
        
        super.init(id: id, name: name, email: email, mobileNum: mobileNum)
        
        _shop_name = shopName ?? ""
        _shop_contact_num = shopContactNum ?? ""
        _address_street = addressStreet ?? ""
        _address_blk = addressBlk ?? ""
        _address_unit = addressUnit ?? ""
        _address_postalCode = addressPostalCode ?? ""
        
        _industry = industry ?? ""
        
        _profilePicUrl = profilePicUrl ?? ""
        
       // _inventory = inventory
    }
    
    var profilePicUrl: String {
        return _profilePicUrl
    }
    
    var shopName: String {
        return _shop_name
    }
    
    var contactNum: String{
        return _shop_contact_num
    }
    
    var addressBlk: String {
        return _address_blk
    }
    
    var addressStreet: String {
        return _address_street
    }
    
    var addressUnit: String {
        return _address_unit
    }
    
    var addressPostalCode: String {
        return _address_postalCode
    }
    
    var industry: String {
        return _industry
    }
    
/*    var inventory: [Inventory]? {
        return _inventory
    } 
 */
}

class MerchantForChat {
    
    private var _id = ""
    private var _displayName = ""
    private var _industry = ""
    
    private var _profilePicImage: UIImage?
    
    init(id: String, displayName: String, industry: String, profilePicImage: UIImage){
        
        _id = id
        _displayName = displayName
        _industry = industry
        _profilePicImage = profilePicImage
        
        
        
    }
    
    var id: String {
        return _id
    }
    
    var displayName: String {
        return _displayName
    }
    
    var industry: String {
        return _industry
    }
    
    var profilePicImage: UIImage {
        return _profilePicImage!
    }
}
