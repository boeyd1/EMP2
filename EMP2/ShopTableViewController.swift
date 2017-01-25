//
//  ShopTableViewController.swift
//  EMP2
//
//  Created by Desmond Boey on 17/1/17.
//  Copyright © 2017 DominicBoey. All rights reserved.
//

import UIKit

class ShopTableViewController: UIViewController, FetchIndustriesData {

     @IBAction func unwindToShopTableViewVC(segue: UIStoryboardSegue){}
    
    @IBOutlet weak var tableView: UITableView!
    
    let SHOW_SPECIFIC_SHOP = "showSpecificShop"
    
    var industriesData = [String: [MerchantInShopView]]()
    
    var industryName = [String]()
    
    var merchantIndexToShow = 0
    var merchantIndustry = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        DBProvider.Instance.merchantIndustriesDelegate = self
        DBProvider.Instance.getMerchantsInIndustries()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SHOW_SPECIFIC_SHOP {
            
            print("going to specific shop vc")
            let destinationVC = segue.destination as! ShopSpecificViewController
            let merchantArray = industriesData[merchantIndustry]
            let merchant = merchantArray?[merchantIndexToShow]
            DBProvider.Instance.singleMerchantDelegate = destinationVC
            DBProvider.Instance.getMerchantDataWithId(id: (merchant?.id)!)
            
        }
        
        //didselect is in collectionviewcell
    }

    func industriesDataReceived(industries: [String: [MerchantInShopView]]) {
        
        self.industriesData = industries
        let lazyCollectionMap = industries.keys
        industryName = Array(lazyCollectionMap)
        industryName.sort(){$0 < $1}
        
        print("industries: \(industryName)")
        
        for(key, value) in industriesData{
            print("key is: \(key)")
            print("value is: \(value)")
        }
        
        tableView.reloadData()
        
    }
    
}

protocol ShowSpecificShopDelegate {
    func showShop(row: Int, industry: String)
}

extension ShopTableViewController: ShowSpecificShopDelegate{
    
    func showShop(row: Int, industry: String){
        
        print("showShopFunc called")
        
        merchantIndexToShow = row
        merchantIndustry = industry
        
        performSegue(withIdentifier: SHOW_SPECIFIC_SHOP, sender: nil)
    }
}

extension ShopTableViewController: UITableViewDelegate, UITableViewDataSource {

    //MARK: TABLE VIEW FUNCTIONS
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return industryName.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }
        return industryName[section - 1]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell1", for: indexPath) as! TableViewCell1
            
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell2", for: indexPath) as! TableViewCell2
            
         
            cell.showSpecificShopDelegate = self
            cell.industry = industryName[indexPath.section - 1]
            
            cell.arrayOfMerchants = industriesData[industryName[indexPath.section - 1]]!
            
            //pass data from here to table to collection
            
            return cell
            
        }
        
    }
    
    /*
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let idealHeight =  UIScreen.main.bounds.height / 5.0
        
        return idealHeight
    }
    */
    
    
}
