//
//  AllChatViewController.swift
//  EMP2
//
//  Created by Desmond Boey on 28/1/17.
//  Copyright © 2017 DominicBoey. All rights reserved.
//

import UIKit

class AllChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FetchSingleChatData, FetchChatIdsData{

    @IBAction func unwindToCustomerAllChatsVC(segue: UIStoryboardSegue){}
    
    @IBOutlet weak var tableView: UITableView!
    
    private let CHAT_CELL = "ChatCell"
    private let SHOW_SPECIFIC_CHAT = "segueToSpecificChat"
    private let SHOW_NEW_CHAT = "segueToAddChatVC"
    
    var chats = [Chat](){
        didSet{
            chats.sort(by: {$0.lastUpdate > $1.lastUpdate})
            
            var newChatIds = [String]()
            
            for chat in chats {
                newChatIds.append(chat.id)
            }
            chatIds = newChatIds
            tableView.reloadData()
        }
    }

    
    var chatIds = [String]()
    
    func chatIdsReceived(ids: [String]) {

        for id in ids {
            if !chatIds.contains(id){
                DBProvider.Instance.getChat(withId: id)
            }
        }
        //might need to check if chat is deleted
    }
    
    func chatReceived(chat: Chat) {
        
        var shouldAddChat = true
        for (index, iChat) in chats.enumerated() {
            if chat.id == iChat.id{
                chats[index] = chat
                shouldAddChat = false
            }
        }
        if shouldAddChat{
            chats.append(chat)
        }
        
        tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        DBProvider.Instance.chatIdsDelegate = self
        DBProvider.Instance.singleChatDelegate = self
        DBProvider.Instance.getChatIds(userId: AuthProvider.Instance.userID())
        
         self.automaticallyAdjustsScrollViewInsets = false
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.tableView != nil {
            self.tableView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SHOW_SPECIFIC_CHAT {
            
            let navController = segue.destination as! UINavigationController
            let destinationVC = navController.topViewController as! CustomerSpecificChatViewController
            
            let _ = destinationVC.view
            
            if let cell = sender as? ChatTableViewCell{
                
                let indexPath = tableView.indexPath(for: cell)
                
                let customerId = AuthProvider.Instance.userID()
                let merchantId = chats[(indexPath?.row)!].merchantId
                
                destinationVC.customerId = customerId
                destinationVC.merchantId = merchantId
                
                destinationVC.chat = chats[(indexPath?.row)!]
            }
        }
    }
    
    @IBAction func newChatButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: SHOW_NEW_CHAT, sender: nil)
    }

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return chats.count
        //return number of active chats
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CHAT_CELL, for: indexPath) as! ChatTableViewCell
        
        // Configure the cell...
        
        if chats.count != 0 {
        cell.userImage.image = chats[indexPath.row].merchantProfileImage
            
        cell.userImage.layer.cornerRadius = cell.userImage.frame.size.height/4
        cell.userImage.layer.masksToBounds = true
            
        cell.userName.text = chats[indexPath.row].merchantDisplayName
        cell.lastMessageContent.text = chats[indexPath.row].lastMessage
        cell.lastMessageTime.text = TimeConverter.Instance.getTimeLabel(dt: chats[indexPath.row].lastUpdate)
        
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        performSegue(withIdentifier: SHOW_SPECIFIC_CHAT, sender: cell)    }

}
