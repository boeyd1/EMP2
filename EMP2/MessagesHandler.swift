//
//  MessagesHandler.swift
//  EMP2
//
//  Created by Desmond Boey on 26/1/17.
//  Copyright © 2017 DominicBoey. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage

protocol MessageReceivedDelegate: class {
    func messageReceived(messages: [Message])
}

class MessagesHandler {
    
    var messages = [Message]() {
        didSet{
            messages.sort(by: {$0.lastUpdate < $1.lastUpdate})
            self.delegate?.messageReceived(messages: messages)
        }
    }
    
    private static let _instance = MessagesHandler()
    private init () {}
    
    weak var delegate: MessageReceivedDelegate?
    
    static var Instance: MessagesHandler {
        return _instance
    }
    
    func sendMessage(chatId: String, senderId: String, senderDisplayName: String, lastUpdate: Double, type: String, text: String?, url: String?) {
        
        DBProvider.Instance.saveMessage(chatId: chatId, senderId: senderId, senderDisplayName: senderDisplayName, lastUpdate: lastUpdate, type: type, text: text, url: url)
        
    }
    
    func sendMedia(chatId: String, senderDisplayName: String, senderId: String, lastUpdate: Double, type: String, text: String?, image: Data?, video: URL?, vc: UIViewController?){
        if image != nil {
            DBProvider.Instance.imageStorageRef.child(senderId + "\(NSUUID().uuidString).jpg").put(image!, metadata: nil){ (metadata: FIRStorageMetadata?, err: Error?)
                in
                
                if err != nil {
                    SimpleAlert.Instance.create(title: "Error", message: "Media message could not be sent", vc: vc!, handler: nil)
                }else{
                    self.sendMessage(chatId: chatId, senderId: senderId, senderDisplayName: senderDisplayName, lastUpdate: lastUpdate, type: Constants.IMAGE, text: nil, url: String(describing: metadata!.downloadURL()!))
                }
                
            }
        }else{
            
            DBProvider.Instance.videoStorageRef.child(senderId + "\(NSUUID().uuidString)").putFile(video!, metadata: nil) { (metadata: FIRStorageMetadata?, err: Error?) in
                
                
                if err != nil {
                    SimpleAlert.Instance.create(title: "Error", message: "Media message could not be sent", vc: vc!, handler: nil)
                } else {
                    self.sendMessage(chatId: chatId, senderId: senderId, senderDisplayName: senderDisplayName, lastUpdate: lastUpdate, type: Constants.VIDEO, text: nil, url: String(describing: metadata!.downloadURL()!))
                }
                
            }
        }
    }
    
    func observeMessage(chatId: String){
        DBProvider.Instance.chatRef.child(chatId).child(Constants.MESSAGE_IDS).observe(FIRDataEventType.childAdded) { (snapshot: FIRDataSnapshot) in
            
            let messageId = snapshot.value as! String
            DBProvider.Instance.messagesRef.child(messageId).observe(.value, with: {
                snapshot in
                
                if let data = snapshot.value as? NSDictionary {
                    
                    let senderDisplayName = data[Constants.SENDER_NAME] as? String
                    let senderId = data[Constants.SENDER_ID] as? String
                    let lastUpdate = data[Constants.LAST_UPDATE] as? Double
                    let type = data[Constants.TYPE] as? String
                    
                    let text = data[Constants.TEXT] as? String
                    
                    let url = data[Constants.URL] as? String

                    self.messages.append(Message(id: messageId, senderDisplayName: senderDisplayName!, senderID: senderId!, lastUpdate: lastUpdate!, type: type!, text: text!, url: url))
                }
                
            })
            
        }
    }
    
    /*
     func observeMediaMessages(){
        DBProvider.Instance.mediaMessagesRef.observe(FIRDataEventType.childAdded) { (snapshot: FIRDataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary{
                if let id = data[Constants.SENDER_ID] as? String{
                    if let name = data[Constants.SENDER_NAME] as? String{
                        if let fileURL = data[Constants.URL] as? String{
                            self.delegate?.mediaReceived(senderId: id, senderName: name, url: fileURL)
                        }
                    }
                }
            }
        }
    }
    */
    
}

