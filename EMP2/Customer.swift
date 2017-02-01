//
//  Customer.swift
//  EMP2
//
//  Created by Desmond Boey on 6/1/17.
//  Copyright © 2017 DominicBoey. All rights reserved.
//

import Foundation

class Customer: User {
    
    private var _id = ""
    private var _name = ""
    private var _email = ""
    private var _mobileNum = ""
    
    
    override init(id: String, name: String, email: String, mobileNum: String) {
        
        super.init(id: id, name: name, email: email, mobileNum: mobileNum)
        
    }
}
