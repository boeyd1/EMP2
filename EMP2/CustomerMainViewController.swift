//
//  CustomerMainViewController.swift
//  EMP2
//
//  Created by Desmond Boey on 12/1/17.
//  Copyright © 2017 DominicBoey. All rights reserved.
//

import UIKit

class CustomerMainViewController: UIViewController {

    private let UNWIND_TO_SIGNIN_VC = "unwindToSignInVC"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutBtnTapped(_ sender: AnyObject) {
        
        if AuthProvider.Instance.logOut() {
            performSegue(withIdentifier: UNWIND_TO_SIGNIN_VC, sender: nil)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
