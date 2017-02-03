//
//  AddChatViewController.swift
//  EMP2
//
//  Created by Desmond Boey on 1/2/17.
//  Copyright © 2017 DominicBoey. All rights reserved.
//

import UIKit
import Firebase


class AddChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FetchMerchantsForChatData, FetchChatDataOnce {

    private let CELL = "Cell"
    private let SHOW_SPECIFIC_CHAT = "segueToSpecificChat"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var arrayOfMerchantsForChat = [MerchantForChat](){
        didSet{
            arrayOfMerchantsForChat.sort(by: {$0.displayName < $1.displayName})
            tableView.reloadData()
        }
    }
    
    
    func oneChatReceived(chat: Chat) {
        performSegue(withIdentifier: SHOW_SPECIFIC_CHAT, sender: chat)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        DBProvider.Instance.merchantsForChatDelegate = self
        DBProvider.Instance.getMerchantsForChat()
        DBProvider.Instance.oneChatDelegate = self
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Do any additional setup after loading the view.
    }
    
    func merchantsForChatDataReceived(merchants: [MerchantForChat]){
        arrayOfMerchantsForChat = merchants
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SHOW_SPECIFIC_CHAT {
            
            let navController = segue.destination as! UINavigationController
            let destinationVC = navController.topViewController as! CustomerSpecificChatViewController
            
            let _ = destinationVC.view
            
            if let cell = sender as? NewChatTableViewCell{
                
                let indexPath = tableView.indexPath(for: cell)
                
                let customerId = AuthProvider.Instance.userID()
                let customerName = AuthProvider.Instance.userNameInitials
                let merchantId = arrayOfMerchantsForChat[(indexPath?.row)!].id
                let merchantName = arrayOfMerchantsForChat[(indexPath?.row)!].displayName
                
                destinationVC.customerId = customerId
                destinationVC.merchantId = merchantId
                destinationVC.customerDisplayName = customerName
                destinationVC.merchantDisplayName = merchantName
                
            }else{
                if let existingChat = sender as? Chat{
                    
                    destinationVC.chat = existingChat
                    destinationVC.customerId = existingChat.customerId
                    destinationVC.customerDisplayName = existingChat.customerDisplayName
                    destinationVC.merchantId = existingChat.merchantId
                    destinationVC.merchantDisplayName = existingChat.merchantDisplayName
                }
            }
        }
    }

    
    // MARK: - Search bar delegate

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keywords = searchBar.text
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayOfMerchantsForChat.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL, for: indexPath) as! NewChatTableViewCell
        
        // Configure the cell...
        
        if arrayOfMerchantsForChat.count != 0 {
            cell.shopNameLabel.text = arrayOfMerchantsForChat[indexPath.row].displayName
            cell.industryLabel.text = arrayOfMerchantsForChat[indexPath.row].industry
            cell.profileImage.image = arrayOfMerchantsForChat[indexPath.row].profilePicImage
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? NewChatTableViewCell{
            
            let customerId = AuthProvider.Instance.userID()
            let merchantId = arrayOfMerchantsForChat[indexPath.row].id
            
            DBProvider.Instance.checkForExistingChat(customerId: customerId, merchantId: merchantId, chatId: { (idReturned) in
                
                if idReturned == nil {
                    self.performSegue(withIdentifier: self.SHOW_SPECIFIC_CHAT, sender: cell)
                }else{
                    DBProvider.Instance.getOneChat(withId: idReturned!)
                }
            })
        }
    }
}
