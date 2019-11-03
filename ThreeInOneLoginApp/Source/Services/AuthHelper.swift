//
//  AuthHelper.swift
//  ThreeInOneLoginApp
//
//  Created by Иван Барабанщиков on 10/30/19.
//  Copyright © 2019 Ivan Barabanshchykov. All rights reserved.
//

import UIKit

class AuthHelper {
    
    static let instance = AuthHelper()
    var authManager: AuthManager!
    private let datastore = ProfileDatastore()
    
    func isAuthorized() -> Bool {
        let facebookAuthManager = FacebookAuthManager()
        if facebookAuthManager.checkAuthorization() == true {
            authManager = facebookAuthManager
            return true
        }
        let googleAuthManager = GoogleAuthManager()
        if googleAuthManager.checkAuthorization() == true {
            authManager = googleAuthManager
            return true
        }
        if #available(iOS 13, *) {
            let appleAuthManager = AppleAuthManager()
            if appleAuthManager.checkAuthorization() == true {
                authManager = googleAuthManager
                return true
            }
        }
        return false
    }
    
    func login(in viewController: UIViewController, onSuccess: @escaping () -> Void, onFailure: @escaping (String) -> Void) {
        authManager.login(in: viewController, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    func logout() {
        datastore.clearAllData()
        authManager.logout()
    }
    
    func fetchProfile(completion: @escaping (Profile) -> Void ) {
        if let profile = datastore.fetchProfile() {
            completion(profile)
        } else {
            updateProfile(completion: completion)
        }
    }
    
    func updateProfile(completion: @escaping (Profile) -> Void ) {
        authManager.getProfileData { [weak self] (profileInfo) in
            onMainQueue {
                self?.datastore.appendProfile(profileInfo: profileInfo, completion: completion)
            }
        }
    }
    
    func clearAllData() {
        datastore.clearAllData()
    }
}
