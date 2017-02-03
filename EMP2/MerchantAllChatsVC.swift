//
//  MerchantAllChatsVC.swift
//  EMP2
//
//  Created by Desmond Boey on 6/1/17.
//  Copyright © 2017 DominicBoey. All rights reserved.
//

import UIKit

class MerchantAllChatsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, FetchChatIdsData, FetchSingleChatData{

    private let CHAT_CELL = "ChatCell"
    private let SHOW_SPECIFIC_CHAT = "showSpecificChat"
    
    @IBOutlet weak var chatTableView: UITableView!
    
    @IBAction func unwindToMerchantAllChatsVC(segue: UIStoryboardSegue){}

    var chats = [Chat](){
        didSet{
            chats.sort(by: {$0.lastUpdate > $1.lastUpdate})
            
            var newChatIds = [String]()
            
            for chat in chats {
                newChatIds.append(chat.id)
            }
            chatIds = newChatIds
            chatTableView.reloadData()
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
        
        chatTableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.delegate = self
        chatTableView.dataSource = self
        
        DBProvider.Instance.chatIdsDelegate = self
        DBProvider.Instance.singleChatDelegate = self
        DBProvider.Instance.getChatIds(userId: AuthProvider.Instance.userID())
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.chatTableView != nil {
            self.chatTableView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SHOW_SPECIFIC_CHAT {
            
            let navController = segue.destination as! UINavigationController
            let destinationVC = navController.topViewController as! MerchantSpecificChatViewController
            
            let _ = destinationVC.view
            
            if let cell = sender as? ChatTableViewCell{
                
                let indexPath = chatTableView.indexPath(for: cell)
                
                destinationVC.chat = chats[(indexPath?.row)!]
            }
            
        }
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
        if chats.count != 0{
        
            var boyImg = UIImage(named: "boy")
            

            cell.userImage.image = UIImage(named: "boy")
            cell.userImage.layer.cornerRadius = cell.userImage.frame.size.height/4
            cell.userImage.layer.masksToBounds = true
            
            cell.userName.text = chats[(indexPath.row)].customerDisplayName
        
            cell.lastMessageContent.text = chats[(indexPath.row)].lastMessage
            
            let lastUpdateTime = chats[(indexPath.row)].lastUpdate
            
            cell.lastMessageTime.text = TimeConverter.Instance.getTimeLabel(dt: lastUpdateTime)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        performSegue(withIdentifier: SHOW_SPECIFIC_CHAT, sender: cell)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
