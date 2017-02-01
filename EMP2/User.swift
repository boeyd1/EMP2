//
//  User.swift
//  EMP2
//
//  Created by Desmond Boey on 31/1/17.
//  Copyright © 2017 DominicBoey. All rights reserved.
//

import Foundation

class User {
    
    private var _id = ""
    private var _name = ""
    private var _email = ""
    private var _mobileNum = ""
    
    
    init(id: String, name: String, email: String, mobileNum: String) {
        
        _id = id
        _name = name
        _email = email
        _mobileNum = mobileNum
        
    }
    
    var id: String {
        return _id
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
