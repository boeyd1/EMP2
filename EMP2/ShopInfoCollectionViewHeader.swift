//
//  ShopInfoCollectionViewHeader.swift
//  EMP2
//
//  Created by Desmond Boey on 25/1/17.
//  Copyright © 2017 DominicBoey. All rights reserved.
//

import UIKit

class ShopInfoCollectionViewHeader: UICollectionViewCell {
    
    @IBOutlet weak var shopImage: UIImageView!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var shopDescription: UILabel!
    @IBOutlet weak var shopAddress1: UILabel!
    @IBOutlet weak var shopAddress2: UILabel!
    
    @IBOutlet weak var shopContactButton: UIButton!
    
    @IBAction func shopContactTapped(_ sender: Any) {
        
    }
    
    @IBAction func chatButtonTapped(_ sender: Any) {
    }
    
}
