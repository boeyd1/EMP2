//
//  ShopSpecificViewController.swift
//  EMP2
//
//  Created by Desmond Boey on 22/1/17.
//  Copyright © 2017 DominicBoey. All rights reserved.
//

import UIKit

class ShopSpecificViewController: UIViewController, FetchInventoryData, FetchSingleMerchantData {

    var merchant: Merchant? {
        didSet{
            DBProvider.Instance.getMerchantInventoryData(id: merchant!.id)
        }
    }
    var inventories = [Inventory]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let HEADER_ID = "merchantShopInfo"
    let SEGUE_TO_SPECIFIC_INV_VC = "segueToSpecificInventoryVC"
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionViewHeader()
        collectionView.delegate = self
        collectionView.dataSource = self
        DBProvider.Instance.inventoryDelegate  = self
        
        print("shopspecificcontroller presented")

        
        // Do any additional setup after loading the view.
    }
    
    func singleMerchantDataReceived(merchant: Merchant) {
        self.merchant = merchant
        print("merchant received")
    }
    
    func inventoryDataReceived(inventories: [Inventory]) {
        print("inventory of \(merchant?.shopName) received")
        self.inventories = inventories
        collectionView.reloadData()
    }
    
    func setCollectionViewHeader(){
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: 0, height: 200)
        collectionView.collectionViewLayout = layout
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SEGUE_TO_SPECIFIC_INV_VC {
            
            //uncomment the bottom when convert specific inventory vc to table view and nested in the tab bar controller
            //let navController = segue.destination as! UINavigationController
            //let destinationVC = navController.topViewController as! SpecificInventoryViewController
            
            let destinationVC = segue.destination as! SpecificInventoryViewController
            
            let _ = destinationVC.view
            
            if let cell = sender as? InventoryCollectionViewCell {
                
                let indexPath = collectionView.indexPath(for: cell)
                
                destinationVC.inventory = inventories[(indexPath?.row)!]
             
                destinationVC.productNameTF.isEnabled = false
                destinationVC.productDescTV.isEditable = false
                destinationVC.productPriceTF.isEnabled = false
                destinationVC.productQuantityTF.isEnabled = false
                destinationVC.selectImgBtn.isHidden = true
                
            }
            
        }
    }

}

extension ShopSpecificViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inventories.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! InventoryCollectionViewCell
        
        cell.productImage.image = inventories[(indexPath.row)].image //take from firebase
        cell.productName.text = inventories[(indexPath.row)].name
        cell.productPrice.text = inventories[(indexPath.row)].price
        cell.productQuantity.text = inventories[(indexPath.row)].quantity
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        performSegue(withIdentifier: SEGUE_TO_SPECIFIC_INV_VC, sender: cell)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HEADER_ID, for: indexPath)
        
        return headerView
    }
    
    
}
