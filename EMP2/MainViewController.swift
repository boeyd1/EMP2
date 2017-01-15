//
//  SideMenuViewController.swift
//  EMP2
//
//  Created by Desmond Boey on 8/11/16.
//  Copyright © 2016 DominicBoey. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {

    @IBOutlet var mainView: UIView!
    var mainViewWidth : CGFloat?
    
    @IBOutlet weak var sidebarMenuView: UIView!
    
    @IBOutlet weak var sidebarWidthConstraint: NSLayoutConstraint!
    
    var menuIsShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainViewWidth = mainView.layer.visibleRect.width
        sidebarWidthConstraint.constant = 0
        
    }

    @IBOutlet weak var MenuButton: UIButton!
    
    @IBAction func MenuButtonTapped(_ sender: AnyObject) {
        if menuIsShowing {
            sidebarWidthConstraint.constant = 0
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            
        }else{
            sidebarWidthConstraint.constant = 0.4*mainViewWidth!
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            
        }
        menuIsShowing = !menuIsShowing
        
    }

}

