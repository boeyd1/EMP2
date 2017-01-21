//
//  ShopCollectionViewCell2.swift
//  EMP2
//
//  Created by Desmond Boey on 21/1/17.
//  Copyright © 2017 DominicBoey. All rights reserved.
//

import UIKit
import FirebaseStorage

class ShopCollectionViewCell2: UICollectionViewCell {
    
    @IBOutlet weak var shopImage: UIImageView!
    @IBOutlet weak var shopName: UILabel!
    var merchantInShopView: MerchantInShopView? {
        didSet{
            print("byebye")
            shopName.text = merchantInShopView!.shopName
            let storageRef = FIRStorage.storage().reference(forURL: merchantInShopView!.profilePicUrl)
            
            storageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) in
            
                if error != nil {
                    print("error retrieving shop profile pic")
                }else{
                    let img = UIImage(data: data!)
                    self.shopImage.image = img
                    self.shopImage.layer.cornerRadius = self.shopImage.frame.size.height/4
                    self.shopImage.layer.masksToBounds = true
                }
            }
            
            
        }
    }
    
}
