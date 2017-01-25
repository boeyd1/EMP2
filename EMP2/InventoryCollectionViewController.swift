//
//  InventoryCollectionViewController.swift
//  EMP2
//
//  Created by Desmond Boey on 3/1/17.
//  Copyright © 2017 DominicBoey. All rights reserved.
//

import UIKit

class InventoryCollectionViewController: UIViewController, FetchInventoryData {
    
    let SEGUE_TO_SPECIFIC_VC = "segueToSpecificVC"
    
    @IBOutlet weak var InventoryCollectionView: UICollectionView!
    
    @IBAction func unwindToInventoryVC(segue: UIStoryboardSegue){}
    
    @IBOutlet weak var addProductButton: UIButton!
    
    var inventories = [Inventory]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.InventoryCollectionView.delegate = self
        self.InventoryCollectionView.dataSource = self
        addProductButton.layer.borderWidth = 1.0
        addProductButton.layer.cornerRadius = 10.0
        DBProvider.Instance.inventoryDelegate = self
        DBProvider.Instance.getMerchantInventoryData(id: AuthProvider.Instance.userID())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    //actions
    @IBAction func addButtonTapped(_ sender: AnyObject) {
        performSegue(withIdentifier: SEGUE_TO_SPECIFIC_VC, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == SEGUE_TO_SPECIFIC_VC {
            
            let navController = segue.destination as! UINavigationController
            let destinationVC = navController.topViewController as! SpecificInventoryViewController
            
            let _ = destinationVC.view
            
            if let cell = sender as? InventoryCollectionViewCell {
            
            let indexPath = InventoryCollectionView.indexPath(for: cell)
            
            destinationVC.inventory = inventories[(indexPath?.row)!]
                
            destinationVC.shouldUnwindToCustomer = false
                
            }
            
        }
    }
    
    func inventoryDataReceived(inventories: [Inventory]) {
        self.inventories = inventories
        InventoryCollectionView.reloadData()
    }
    
}


extension InventoryCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        performSegue(withIdentifier: SEGUE_TO_SPECIFIC_VC, sender: cell)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var collectionViewSize = collectionView.frame.size
        collectionViewSize.width = collectionViewSize.width / 3.0 - 20
        collectionViewSize.height = 150
        return collectionViewSize
    }
}



