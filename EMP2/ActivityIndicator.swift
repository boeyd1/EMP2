//
//  ActivityIndicator.swift
//  EMP2
//
//  Created by Desmond Boey on 13/1/17.
//  Copyright © 2017 DominicBoey. All rights reserved.
//

import Foundation
import UIKit

class ActivityIndicator {
    static let actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 150, height: 150)) as UIActivityIndicatorView
    
    static let window = UIApplication.shared.keyWindow
    
    static func startAnimating(){
        actInd.center = window!.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        window!.addSubview(actInd)
        actInd.startAnimating()
    }
    
    static func stopAnimating(){
        actInd.stopAnimating()
        window!.willRemoveSubview(actInd)
    }
    
}
