//
//  ShopTableViewController.swift
//  EMP2
//
//  Created by Desmond Boey on 17/1/17.
//  Copyright © 2017 DominicBoey. All rights reserved.
//

import UIKit

class ShopTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    var storedOffsets = [Int: CGFloat]()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
        //based on number of categories
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell1", for: indexPath)
            
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell2", for: indexPath)
            
            return cell
            
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
        guard let tableViewCell = cell as? TableViewCell1 else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
        }else{
            guard let tableViewCell = cell as? TableViewCell2 else { return }
            
            tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
            tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
        guard let tableViewCell = cell as? TableViewCell1 else { return }
        
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
        }else{
            guard let tableViewCell = cell as? TableViewCell2 else { return }
            
            storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
        }
    }
}

extension ShopTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //    return model[collectionView.tag].count
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell1", for: indexPath)
            
            return cell
            
        } else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell2", for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
    }
}
