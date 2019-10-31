//
//  AuthHelper.swift
//  ThreeInOneLoginApp
//
//  Created by Иван Барабанщиков on 10/30/19.
//  Copyright © 2019 Ivan Barabanshchykov. All rights reserved.
//

import Foundation

class AuthHelper {
    private var facebookAuthManager = FacebookAuthManager()
    private var googleAuthManager = GoogleAuthManager()
    private var appleAuthManager: AuthManager!
    
    func checkAuthorizationInAllManagers() -> Bool {
        if facebookAuthManager.checkIfAuthorized() == true { return true }
        if googleAuthManager.checkIfAuthorized() == true { return true }
        if #available(iOS 13, *) {
            appleAuthManager = AppleAuthManager()
            if appleAuthManager!.checkIfAuthorized() == true { return true }
        }
        return false
    }
    
    func logoutFromAllAuthManagers() {
        let datastore = ProfileDatastore()
        datastore.clearAllData()
        if facebookAuthManager.checkIfAuthorized() == true { facebookAuthManager.logout() }
        if googleAuthManager.checkIfAuthorized() == true { googleAuthManager.logout() }
        if #available(iOS 13, *) {
            appleAuthManager = AppleAuthManager()
            if appleAuthManager!.checkIfAuthorized() == true { appleAuthManager.logout() }
        }
    }
}
