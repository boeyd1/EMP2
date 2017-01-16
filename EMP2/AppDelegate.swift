//
//  AppDelegate.swift
//  EMP2
//
//  Created by Desmond Boey on 8/11/16.
//  Copyright © 2016 DominicBoey. All rights reserved.
//

import UIKit
import Firebase
import OneSignal



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let oneSignalAppId = "1cfdea0d-4138-4f03-b59c-9982f4c8638e"
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        

        OneSignal.initWithLaunchOptions(launchOptions, appId: oneSignalAppId) { (result) in
            
            // This block gets called when the user reacts to a notification received
            
            let payload = result.notification.payload
            let messageTitle = "OneSignal Example"
            var fullMessage = payload.title
            
            //Try to fetch the action selected
            if let additionalData = payload.additionalData && actionSelected = additionalData["actionSelected"] as? String {
                fullMessage =  fullMessage + "\nPressed ButtonId:\(actionSelected)"
            }
            
            let alertView = UIAlertView(title: messageTitle, message: fullMessage, delegate: nil, cancelButtonTitle: "Close")
            alertView.show()
        }
        
        FIRApp.configure()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
