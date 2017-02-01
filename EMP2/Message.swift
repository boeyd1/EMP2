//
//  Message.swift
//  EMP2
//
//  Created by Desmond Boey on 31/1/17.
//  Copyright © 2017 DominicBoey. All rights reserved.
//

import Foundation

class Message
{
    private var _id: String
    private var _senderDisplayName: String
    private var _senderID: String
    private var _lastUpdate: Double
    private var _type: String
    private var _text: String
    private var _url: String?
    
    init(id: String, senderDisplayName: String, senderID: String, lastUpdate: Double, type: String, text: String, url: String?)
    {
        
        _id = id
        _senderDisplayName = senderDisplayName
        _senderID = senderID
        _type = type
        _lastUpdate = lastUpdate
        _text = text
        _url = url
    }
    
    var id: String {
        return _id
    }
    
    var senderDisplayName: String {
        return _senderDisplayName
    }
    
    var senderID: String {
        return _senderID
    }
    
    var type: String {
        return _type
    }
    
    var lastUpdate: Double {
        return _lastUpdate
    }
    
    var text: String {
        return _text
    }
    
    var url: String? {
        return _url
    }
    
}
