//
//  InventoryCollectionViewCell.swift
//  EMP2
//
//  Created by Desmond Boey on 4/1/17.
//  Copyright © 2017 DominicBoey. All rights reserved.
//

import UIKit

class InventoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
   
    @IBOutlet weak var productName: UILabel!
    
    
    @IBOutlet weak var productPrice: UILabel!
    
    
    @IBOutlet weak var productQuantity: UILabel!
}
