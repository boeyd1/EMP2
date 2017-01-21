//
//  ShopTableViewController.swift
//  EMP2
//
//  Created by Desmond Boey on 17/1/17.
//  Copyright © 2017 DominicBoey. All rights reserved.
//

import UIKit

class ShopTableViewController: UIViewController, FetchIndustriesData {

    
    @IBOutlet weak var tableView: UITableView!
    
    var industriesData = [String: [MerchantInShopView]]()
    
    var industryName = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DBProvider.Instance.merchantIndustriesDelegate = self
        DBProvider.Instance.getMerchantsInIndustries()
        
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
