//
//  Inventory.swift
//  EMP2
//
//  Created by Desmond Boey on 12/1/17.
//  Copyright © 2017 DominicBoey. All rights reserved.
//

import Foundation
import UIKit

class Inventory {
    
    private var _id = ""
    private var _name = ""
    private var _description = ""
    private var _price = ""
    private var _quantity = ""
    private var _image : UIImage?
    private var _url = ""
    
    init(id: String, name: String, description: String?, price: String?, quantity: String?, image: UIImage?, url: String){
        
        _id = id
        _name = name
        _description = description ?? ""
        _price = price ?? ""
        _quantity = quantity ?? ""
        _image = image
        _url = url
    }
    
    var url: String {
        return _url
    }
    
    var id: String {
        return _id
    }
    
    var name: String {
        return _name
    }
    
    var description: String {
        return _description
    }
    
    var price: String {
        return _price
    }
    
    var quantity: String {
        return _quantity
    }
    
    var image: UIImage? {
        return _image
    }
}
