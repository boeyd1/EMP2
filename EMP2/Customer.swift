//
//  Customer.swift
//  EMP2
//
//  Created by Desmond Boey on 6/1/17.
//  Copyright © 2017 DominicBoey. All rights reserved.
//

import Foundation

class Customer {
    
    private var _id = ""
    private var _salutation = ""
    private var _name = ""
    private var _email = ""
    private var _mobileNum = ""
    
    
    init(id: String, salutation: String, name: String, email: String, mobileNum: String) {
        
        _id = id
        _salutation = salutation
        _name = name
        _email = email
        _mobileNum = mobileNum
        
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
}
