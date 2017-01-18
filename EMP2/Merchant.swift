//
//  Merchant.swift
//  EMP2
//
//  Created by Desmond Boey on 11/1/17.
//  Copyright © 2017 DominicBoey. All rights reserved.
//

import Foundation

class Merchant {
    
    private var _id = ""
    private var _salutation = ""
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
    
   // var _inventory : [Inventory]?
    
    init(id: String, salutation: String, name: String, email: String, mobileNum: String, shopName: String?, shopContactNum: String?, addressStreet: String?, addressBlk: String?, addressUnit: String?, addressPostalCode: String?, industry: String?/*, inventory: [Inventory]?*/) {
        
        _id = id
        _salutation = salutation
        _name = name
        _email = email
        _mobileNum = mobileNum

        _shop_name = shopName ?? ""
        _shop_contact_num = shopContactNum ?? ""
        _address_street = addressStreet ?? ""
        _address_blk = addressBlk ?? ""
        _address_unit = addressUnit ?? ""
        _address_postalCode = addressPostalCode ?? ""
        
        _industry = industry ?? ""
        
       // _inventory = inventory
    }
    
    var id: String {
        return _id
    }
    
    var salutation: String {
        return _salutation
    }
    
    var name: String {
        return _name
    }
    
    var email: String {
        return _email
    }
    
    var mobileNum: String {
        return _mobileNum
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
