//
//  PhotoTakingHelper.swift
//  EMP2
//
//  Created by Desmond Boey on 5/1/17.
//  Copyright © 2017 DominicBoey. All rights reserved.
//

import Foundation
import UIKit


typealias PhotoTakingHelperCallback = (UIImage?) -> Void

class PhotoTakingHelper : NSObject {
    
    // View controller on which AlertViewController and UIImagePickerController are presented
    weak var viewController: UIViewController!
    var callback: PhotoTakingHelperCallback
    var imagePickerController: UIImagePickerController?
    
    init(viewController: UIViewController, callback: @escaping PhotoTakingHelperCallback) {
        self.viewController = viewController
        self.callback = callback
        
        super.init()
        
        showPhotoSourceSelection()
    }
    
    
    func showPhotoSourceSelection() {
        // Allow user to choose between photo library and camera
        let alertController = UIAlertController(title: nil, message: "Where do you want to get your picture from?", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        //add cancel button to controller
        alertController.addAction(cancelAction)
        
        // Only show camera option if rear camera is available
        if (UIImagePickerController.isCameraDeviceAvailable(.rear)) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
                self.showImagePickerController(sourceType: .camera)
                //called when the "camera" pop-up button is clicked
            }
            //add the button to the controller
            alertController.addAction(cameraAction)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.showImagePickerController(sourceType: .photoLibrary)
            //called when the "photo library" pop-up button is clicked.
        }
        //add button to controller
        alertController.addAction(photoLibraryAction)
        //present the controller
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    //when button is clicked, this function is triggered
    func showImagePickerController(sourceType: UIImagePickerControllerSourceType) {
        imagePickerController = UIImagePickerController()
        imagePickerController!.sourceType = sourceType
        imagePickerController!.delegate = self
        imagePickerController!.allowsEditing = true
        if sourceType == .camera {
            imagePickerController!.showsCameraControls = true
            imagePickerController!.cameraCaptureMode = .photo
        }
        
        self.viewController.present(imagePickerController!, animated: true, completion: nil)
    }
}

extension PhotoTakingHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let selectedPhoto = info[UIImagePickerControllerEditedImage] as! UIImage
        
        callback(selectedPhoto)
        
        viewController.dismiss(animated: true, completion: nil)
    }
    //hide the image picker controller when user presses 'cancel' or selected image
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
}
