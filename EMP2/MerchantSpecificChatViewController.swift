//
//  MerchantSpecificChatViewController.swift
//  EMP2
//
//  Created by Desmond Boey on 8/1/17.
//  Copyright © 2017 DominicBoey. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import MobileCoreServices
import AVKit
import SDWebImage

class MerchantSpecificChatViewController: JSQMessagesViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MessageReceivedDelegate{
    
    var chat: Chat?{
        didSet{
            //called multiple times that's why print multiple times too
            MessagesHandler.Instance.observeMessage(chatId: chat!.id)
        }
    }

    var customerId: String?
    var customerName: String?
    var merchantId: String?
    var merchantName: String?

    private var jsqMessages = [JSQMessage]()
    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.senderId = AuthProvider.Instance.userID()
        self.senderDisplayName = AuthProvider.Instance.userName
        
        picker.delegate = self
        MessagesHandler.Instance.delegate = self
        automaticallyScrollsToMostRecentMessage = true
        showTypingIndicator = true
        

        
    }
    
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        let lastUpdate = Date().timeIntervalSince1970
        
        MessagesHandler.Instance.sendMessage(chatId: chat!.id, senderId: senderId, senderDisplayName: senderDisplayName, lastUpdate: lastUpdate, type: Constants.TEXT, text: text, url: nil)
        
        
        //removes text from textfield
        finishSendingMessage()
        DBProvider.Instance.getAllChats()
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        let alert = UIAlertController(title: "Media Messages", message: "Please select media type", preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let photos = UIAlertAction(title: "Photos", style: .default, handler: {(alert: UIAlertAction) in
            self.chooseMedia(type: kUTTypeImage)
         })
        
        let videos = UIAlertAction(title: "Videos", style: .default, handler: {(alert: UIAlertAction) in
            self.chooseMedia(type: kUTTypeMovie)
        })
        
        alert.addAction(photos)
        alert.addAction(videos)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    //PICKER VIEW FUNCTIONS
    
    private func chooseMedia(type: CFString){
        picker.mediaTypes = [type as String!]
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let lastUpdate = Date().timeIntervalSince1970
        if let pic = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let data = UIImageJPEGRepresentation(pic, 0.01)
            
            
            MessagesHandler.Instance.sendMedia(chatId: chat!.id, senderDisplayName: self.senderDisplayName, senderId: self.senderId, lastUpdate: lastUpdate, type: Constants.IMAGE, text: nil, image: data, video: nil,  vc: self)
            
        }else if let vidUrl = info[UIImagePickerControllerMediaURL] as? URL {
            
            MessagesHandler.Instance.sendMedia(chatId: chat!.id, senderDisplayName: self.senderDisplayName, senderId: self.senderId, lastUpdate: lastUpdate, type: Constants.VIDEO, text: nil, image: nil, video: vidUrl,  vc: self)
        }
        
        self.dismiss(animated: true, completion: nil)
        finishSendingMessage()
        
    }
    
    //COLLECTION VIEW FUNCTIONS
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "boy"), diameter: 30)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        let message = jsqMessages[indexPath.item]
        
        if message.senderId == self.senderId {
           return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.blue)
        } else{
            return bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.lightGray)
        }
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return jsqMessages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        
        let msg = jsqMessages[indexPath.item]
        
        if msg.isMediaMessage {
            if let mediaItem = msg.media as? JSQVideoMediaItem {
                let player = AVPlayer(url: mediaItem.fileURL)
                let playerController = AVPlayerViewController()
                playerController.player = player
                
                self.present(playerController, animated: true, completion: nil)
                
                
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jsqMessages.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        return cell
    }
    
    //Delegation functions
    func messageReceived(message: Message) {
            
            if let _ = message.url {
                
                jsqMessages.append(JSQMessage(senderId: "", displayName: "", text: "...downloading media..."))
                
                let index = jsqMessages.count - 1
                
                let url = URL(string:message.url!)!
                do {
                    
                    let data = try Data(contentsOf: url)
                    
                    if let _ = UIImage(data: data) {
                        
                        let _ = SDWebImageDownloader.shared().downloadImage(with: url, options: [], progress: nil, completed: { (image, data, error, finished) in
                            
                            DispatchQueue.main.async {
                                let photo = JSQPhotoMediaItem(image: image)
                                if message.senderID == self.senderId {
                                    photo?.appliesMediaViewMaskAsOutgoing = true
                                } else {
                                    photo?.appliesMediaViewMaskAsOutgoing = false
                                }
                                
                                self.jsqMessages[index] = JSQMessage(senderId: message.senderID, displayName: message.senderDisplayName, media: photo)
                                self.finishReceivingMessage()
                                

                            }
                            
                            
                        })
                    } else{
                        let video = JSQVideoMediaItem(fileURL: url, isReadyToPlay: true)
                        
                        if message.senderID == self.senderId {
                            video?.appliesMediaViewMaskAsOutgoing = true
                        } else {
                            video?.appliesMediaViewMaskAsOutgoing = false
                        }
                        
                        self.jsqMessages.append(JSQMessage(senderId: message.senderID, displayName: message.senderDisplayName, media: video))
                        finishReceivingMessage()
                    }
                    
                }catch{
                    
                }
                
            }else{
                
                self.jsqMessages.append(JSQMessage(senderId: message.senderID, displayName: message.senderDisplayName, text: message.text))
                
            }
        finishReceivingMessage()
        
    }
    
    /*
    
    func mediaReceived(senderId: String, senderName: String, url: String) {
        
        if let mediaURL = URL(string: url){
            
            do {
                
                let data = try Data(contentsOf: mediaURL)
                
                if let _ = UIImage(data: data) {
                    
                    let _ = SDWebImageDownloader.shared().downloadImage(with: mediaURL, options: [], progress: nil, completed: { (image, data, error, finished) in
                        
                        DispatchQueue.main.async {
                            let photo = JSQPhotoMediaItem(image: image)
                            if senderId == self.senderId {
                                photo?.appliesMediaViewMaskAsOutgoing = true
                            } else {
                                photo?.appliesMediaViewMaskAsOutgoing = false
                            }
                            
                            self.jsqMessages.append(JSQMessage(senderId: senderId, displayName: senderName, media: photo))
                            
                            self.collectionView.reloadData()
                        }
                        
                        
                    })
                } else{
                    let video = JSQVideoMediaItem(fileURL: mediaURL, isReadyToPlay: true)
                    
                    if senderId == self.senderId {
                        video?.appliesMediaViewMaskAsOutgoing = true
                    } else {
                        video?.appliesMediaViewMaskAsOutgoing = false
                    }
                    jsqMessages.append(JSQMessage(senderId: senderId, displayName: senderName, media: video))
                   self.collectionView.reloadData()
                }
                
            }catch{
                
            }
        }
    }
 
 */

}
