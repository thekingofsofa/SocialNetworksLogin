//
//  AppDelegate.swift
//  ThreeInOneLoginApp
//
//  Created by Иван Барабанщиков on 10/29/19.
//  Copyright © 2019 Ivan Barabanshchykov. All rights reserved.
//

import UIKit
import GoogleSignIn
import FacebookCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // FBSI.
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // GSI. Configure the GIDSignIn shared instance and set the sign-in delegate.
        GIDSignIn.sharedInstance().clientID = "953352529496-khfhegh7m7em8r53l2bl9djdl591dpur.apps.googleusercontent.com"
        
        coordinator = AppCoordinator()
        coordinator?.start()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = coordinator?.navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    // GSI. Implement application:openURL:options: method. The method should call the handleURL method of the GIDSignIn instance, which will properly handle the URL that your application receives at the end of the authentication process.
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        if ApplicationDelegate.shared.application(app, open: url, options: options) {
            return true
        } else if GIDSignIn.sharedInstance().handle(url) {
            return true
        }
        return false
    }
}

