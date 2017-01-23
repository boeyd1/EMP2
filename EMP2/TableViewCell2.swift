//
//  TableViewCell2.swift
//  EMP2
//
//  Created by Desmond Boey on 17/1/17.
//  Copyright © 2017 DominicBoey. All rights reserved.
//

import UIKit

class TableViewCell2: UITableViewCell {
    
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    
    var arrayOfMerchants = [MerchantInShopView]() {
        didSet{
            collectionView.reloadData()
            print("didSet")
        }
    }
    var industry = ""

    var showSpecificShopDelegate: ShowSpecificShopDelegate?
    
}

extension TableViewCell2: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfMerchants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell2", for: indexPath) as! ShopCollectionViewCell2
        
    
        cell.merchantInShopView = arrayOfMerchants[indexPath.row]
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //segue should go 
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? ShopCollectionViewCell2 {
            showSpecificShopDelegate?.showShop(row: indexPath.row, industry: industry)
            print("\(indexPath.row) shop selected")
        }
        
    }
    
}

extension TableViewCell2: UICollectionViewDelegateFlowLayout{
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let itemsPerRow:CGFloat = 4
//        let hardCodedPadding:CGFloat = 5
//        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
//        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
//        return CGSize(width: itemWidth, height: itemHeight)
//    }
    
}
