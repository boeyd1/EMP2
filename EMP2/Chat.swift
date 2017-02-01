//
//  Chat.swift
//  EMP2
//
//  Created by Desmond Boey on 31/1/17.
//  Copyright © 2017 DominicBoey. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class Chat
{
    private var _id: String
    private var _customerId: String
    private var _merchantId: String
    private var _lastMessage: String
    private var _lastUpdate: Double
    private var _merchantProfileImage: UIImage
    
    init(id: String, customerId: String, merchantId: String, lastMessage: String?, lastUpdate: Double?, merchantProfileImage: UIImage)
    {
        _id = id
        _customerId = customerId
        _merchantId = merchantId
        _lastMessage = lastMessage ?? ""
        _lastUpdate = lastUpdate ?? 0.0
        
        _merchantProfileImage = merchantProfileImage
    }
 
    var id: String{
        return _id
    }
    
    var customerId: String{
        return _customerId
    }
    
    var merchantId: String{
        return _merchantId
    }
    
    var lastMessage: String{
        return _lastMessage
    }
    
    var lastUpdate: Double{
        return _lastUpdate
    }
    
    var merchantProfileImage: UIImage{
        return _merchantProfileImage
    }
    
    
}



























