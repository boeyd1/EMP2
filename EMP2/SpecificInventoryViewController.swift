//
//  SpecificInventoryViewController.swift
//  EMP2
//
//  Created by Desmond Boey on 4/1/17.
//  Copyright © 2017 DominicBoey. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class SpecificInventoryViewController: UIViewController {
    
    private let UNWIND_TO_INVENTORY_VC = "unwindToInventoryVC"

    @IBOutlet weak var productNameTF: UITextField!
    
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var productDescTV: UITextView!
    
    @IBOutlet weak var productPriceTF: UITextField!
    
    @IBOutlet weak var productQuantityTF: UITextField!
    
    @IBOutlet weak var selectImgBtn: UIButton!
    
    
    var inventory: Inventory? {
        didSet{
            productNameTF.text = inventory?.name ?? ""
            productDescTV.text = inventory?.description ?? ""
            productPriceTF.text = inventory?.price ?? ""
            productQuantityTF.text = inventory?.quantity ?? ""
            productImage.image = inventory?.image ?? UIImage(named: "no-image-selected")
        }
    }
    
    var photoTakingHelper : PhotoTakingHelper?
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboard()
        
        productNameTF.layer.borderWidth = 1.0
        productNameTF.layer.cornerRadius = 5.0
        productDescTV.layer.borderWidth = 1.0
        productDescTV.layer.cornerRadius = 5.0
        productPriceTF.layer.borderWidth = 1.0
        productPriceTF.layer.cornerRadius = 5.0
        productQuantityTF.layer.borderWidth = 1.0
        productQuantityTF.layer.cornerRadius = 5.0
        selectImgBtn.layer.borderWidth = 1.0
        selectImgBtn.layer.cornerRadius = 10.0
        productImage.image = inventory?.image ?? UIImage(named: "no-image-selected")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectImgBtnTapped(_ sender: AnyObject) {
        
        photoTakingHelper = PhotoTakingHelper(viewController: self){ (image: UIImage?) in
            self.productImage.image = image
        }
    }
    
    @IBAction func saveBtnTapped(_ sender: AnyObject) {
        
        ActivityIndicator.startAnimating()
        
        let currentUserId = AuthProvider.Instance.userID()
        
        let currentShopName = AuthProvider.Instance.currentMerchant?.shopName
        
        if productImage.image == UIImage(named: "no-image-selected") {
            
            ActivityIndicator.stopAnimating()
            SimpleAlert.Instance.create(title: "Error", message: "Please select an image", vc: self, handler: nil)
            
        }else if inventory != nil {
            
            let storageRef = FIRStorage.storage().reference(forURL: inventory!.url)
            
            storageRef.delete(completion: { (error) in
                
                if error != nil {
                    print("Error in deleting photo")
                }
            })
            
            let data = UIImageJPEGRepresentation(productImage.image!, 0.1)

            
            DBProvider.Instance.imageStorageRef.child(currentUserId + "\(NSUUID().uuidString).jpg").put(data!,metadata: nil) { (metadata: FIRStorageMetadata?, err: Error?) in
                
                ActivityIndicator.stopAnimating()
                
                if err != nil {
                    //add delegate here and implement func in this class after calling storing method in dbprovider returning a possible error
                }else {
                    DBProvider.Instance.updateInventory(merchantID: currentUserId, inventoryID: self.inventory!.id, shopName: currentShopName!, name: self.productNameTF.text!, description: self.productDescTV.text, price: self.productPriceTF.text!,quantity: self.productQuantityTF.text!, url: String(describing: metadata!.downloadURL()!))
                    
                    SimpleAlert.Instance.create(title: "Update Success", message: "Inventory has been updated!", vc: self) {(handler) in
                        self.performSegue(withIdentifier: self.UNWIND_TO_INVENTORY_VC, sender: nil)
                        
                    }
                }
            }
            
        }else{
            
           let data = UIImageJPEGRepresentation(productImage.image!, 0.1)
            
            DBProvider.Instance.imageStorageRef.child(currentUserId + "\(NSUUID().uuidString).jpg").put(data!,metadata: nil) { (metadata: FIRStorageMetadata?, err: Error?) in
                
                ActivityIndicator.stopAnimating()
                
                if err != nil {
                    //add delegate here and implement func in this class after calling storing method in dbprovider returning a possible error
                    print("imageUpload error")
                }else {
                    print("imageUpload success")
                    DBProvider.Instance.createInventory(merchantID: currentUserId, shopName: currentShopName!, name: self.productNameTF.text!, description: self.productDescTV.text, price: self.productPriceTF.text!,quantity: self.productQuantityTF.text!, url: String(describing: metadata!.downloadURL()!))
                    
                    print("create inventory successful")
                    SimpleAlert.Instance.create(title: "Upload Success", message: "Inventory has been uploaded!", vc: self) {(handler) in
                        self.performSegue(withIdentifier: self.UNWIND_TO_INVENTORY_VC, sender: nil)
                        
                    }
                }
            }
        }
    }
    
}

extension SpecificInventoryViewController {
    
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

