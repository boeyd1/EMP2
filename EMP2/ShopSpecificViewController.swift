//
//  ShopSpecificViewController.swift
//  EMP2
//
//  Created by Desmond Boey on 22/1/17.
//  Copyright © 2017 DominicBoey. All rights reserved.
//

import UIKit
import FirebaseStorage

class ShopSpecificViewController: UIViewController, FetchInventoryData, FetchSingleMerchantData {

    var merchant: Merchant? {
        didSet{
            DBProvider.Instance.getMerchantInventoryData(id: merchant!.id)
                collectionView.reloadData()
        }
    }
    var inventories = [Inventory]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let HEADER_ID = "merchantShopInfo"
    let SEGUE_TO_SPECIFIC_INV_VC = "segueToSpecificInventoryVC"
   
    @IBAction func unwindToCustShopVC(segue: UIStoryboardSegue){}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // setCollectionViewHeader()
        collectionView.delegate = self
        collectionView.dataSource = self
        DBProvider.Instance.inventoryDelegate  = self
        self.automaticallyAdjustsScrollViewInsets = false
        
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
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SEGUE_TO_SPECIFIC_INV_VC {
            
            //uncomment the bottom when convert specific inventory vc to table view and nested in the tab bar controller
            let navController = segue.destination as! UINavigationController
            let destinationVC = navController.topViewController as! SpecificInventoryViewController
            
            let _ = destinationVC.view
            
            if let cell = sender as? InventoryCollectionViewCell {
                
                let indexPath = collectionView.indexPath(for: cell)
                
                destinationVC.inventory = inventories[(indexPath?.row)!]
             
                destinationVC.productNameTF.isEnabled = false
                destinationVC.productDescTV.isEditable = false
                destinationVC.productPriceTF.isEnabled = false
                destinationVC.productQuantityTF.isEnabled = false
                destinationVC.selectImgBtn.isHidden = true
                destinationVC.shouldUnwindToCustomer = true
                destinationVC.saveButton.isEnabled = false
                destinationVC.saveButton.tintColor = UIColor.clear
            }
            
        }
    }
    
    @IBAction func followButtonTapped(_ sender: Any) {
        
        
        
    }
    
    

}

extension ShopSpecificViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inventories.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! InventoryCollectionViewCell
        
        cell.productImage.image = inventories[(indexPath.row)].image //take from firebase
        cell.productName.text = inventories[(indexPath.row)].name
        print("productName: \(inventories[(indexPath.row)].name)")
        cell.productPrice.text = inventories[(indexPath.row)].price
        print("productPrice: \(inventories[(indexPath.row)].price)")
        cell.productQuantity.text = inventories[(indexPath.row)].quantity
        print("productQty: \(inventories[(indexPath.row)].quantity)")
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        performSegue(withIdentifier: SEGUE_TO_SPECIFIC_INV_VC, sender: cell)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HEADER_ID, for: indexPath) as! ShopInfoCollectionViewHeader
        
        if let iImageURL = merchant?.profilePicUrl {
            
            let storageRef = FIRStorage.storage().reference(forURL: iImageURL)
            
            //retrieve image with max size 1mb
            storageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) in
                if error != nil {
                }else{
                    let img = UIImage(data: data!)
                    cell.shopImage.image = img
                }
            }
        }
        cell.shopName.text = merchant?.shopName ?? ""
        
        let addressBlk = merchant?.addressBlk ?? ""
        
        var addBlk = addressBlk.lowercased()
        
        if let blkRange = addBlk.range(of: "blk") {
                addBlk.replaceSubrange(blkRange, with: "")
        }
        if let blockRange = addBlk.range(of: "block") {
            addBlk.replaceSubrange(blockRange, with: "")
        }
        
        let addressSt = merchant?.addressStreet ?? ""
        
        
        if addBlk != ""{
            cell.shopAddress1.text = "Blk \(addBlk) \(addressSt)"
        }else{
            cell.shopAddress1.text = "\(addBlk) \(addressSt)"
        }
        
        let unit = merchant?.addressUnit ?? ""
        let postCode = merchant?.addressPostalCode ?? ""
        if postCode != "" {
            cell.shopAddress2.text = "Unit: \(unit)  |  S\(postCode)"
        }else{
            cell.shopAddress2.text = ""
        }
        
        
        cell.shopContactButton.setTitle(merchant?.contactNum, for: UIControlState.normal)
        
        
        //cell.shopDescription.text = merchant?.shopDescription ?? ""
        
        cell.autoresizingMask = UIViewAutoresizing.flexibleRightMargin
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var collectionViewSize = collectionView.frame.size
        collectionViewSize.width = collectionViewSize.width / 3.0 - 20
        collectionViewSize.height = 150
        return collectionViewSize
    }
    
}
