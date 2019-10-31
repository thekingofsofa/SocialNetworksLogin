//
//  AuthHelper.swift
//  ThreeInOneLoginApp
//
//  Created by Иван Барабанщиков on 10/30/19.
//  Copyright © 2019 Ivan Barabanshchykov. All rights reserved.
//

import Foundation

class AuthHelper {
    private var facebookAuthManager: FacebookAuthManager!
    private var googleAuthManager: GoogleAuthManager!
    private var appleAuthManager: AuthManager!
    
    func checkAuthorizationInAllManagers() -> Bool {
        if ((facebookAuthManager?.checkIfAuthorized) != nil) { return true }
        if ((googleAuthManager?.checkIfAuthorized) != nil) { return true }
        if #available(iOS 13, *) {
            appleAuthManager = AppleAuthManager()
            if ((appleAuthManager?.checkIfAuthorized) != nil) { return true }
        }
        return false
    }
    
    func logoutFromAllAuthManagers() {
        if ((facebookAuthManager?.checkIfAuthorized) != nil) { facebookAuthManager.logout() }
        if ((googleAuthManager?.checkIfAuthorized) != nil) { googleAuthManager.logout() }
        if #available(iOS 13, *) {
            appleAuthManager = AppleAuthManager()
            if ((appleAuthManager?.checkIfAuthorized) != nil) { appleAuthManager.logout() }
        }
    }
}
