//
//  SimpleAlert.swift
//  EMP2
//
//  Created by Desmond Boey on 12/1/17.
//  Copyright © 2017 DominicBoey. All rights reserved.
//

import UIKit

class SimpleAlert {
    private static let _instance = SimpleAlert()
    
    static var Instance: SimpleAlert {
        return _instance
    }
    
    func create(title: String, message: String, vc: UIViewController, handler: ((UIAlertAction) -> Void)?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Ok", style: .default, handler: handler)
        
        alert.addAction(ok)
        vc.present(alert, animated: true, completion: nil)
    
    }
    
    
}
