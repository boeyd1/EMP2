//
//  MerchantInShopView.swift
//  EMP2
//
//  Created by Desmond Boey on 20/1/17.
//  Copyright © 2017 DominicBoey. All rights reserved.
//

import Foundation

class MerchantInShopView {
    
    private var _id = ""
    private var _shopName = ""
    private var _profilePicUrl = ""
    private var _industry = ""
    
    
    init(id: String, shopName: String, profilPicUrl: String, industry: String) {
        
        _id = id
        _shopName = shopName
        _profilePicUrl = profilPicUrl
        _industry = industry
        
    }
    
    var id: String {
        return _id
    }
    
    var shopName: String {
        return _shopName
    }
    
    var profilePicUrl: String {
        return _profilePicUrl
    }
    
    var industry: String {
        return _industry
    }
}
