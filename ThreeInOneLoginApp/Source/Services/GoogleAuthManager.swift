//
//  GoogleAuthManager.swift
//  ThreeInOneLoginApp
//
//  Created by Иван Барабанщиков on 10/29/19.
//  Copyright © 2019 Ivan Barabanshchykov. All rights reserved.
//

import Foundation
import GoogleSignIn

class GoogleAuthManager: NSObject, AuthManager {
    
    var profile: ProfileInfo?
    private var onLogInSuccess: (()->Void)?
    
    override init() {
        super.init()
        GIDSignIn.sharedInstance().delegate = self
    }
    
    // MARK: - Service methods
    func login(in viewController: UIViewController, onSuccess: @escaping () -> Void, onFailure: @escaping (String) -> Void) {
        GIDSignIn.sharedInstance()?.presentingViewController = viewController
        self.onLogInSuccess = onSuccess
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func logout() {
        GIDSignIn.sharedInstance().signOut()
        NotificationCenter.default.post(Notification(name: .init(Constants.Notifications.UserLogedOut)))
    }
    
    func checkAuthorization() -> Bool {
        if GIDSignIn.sharedInstance()?.hasPreviousSignIn() ?? false {
            GIDSignIn.sharedInstance()?.restorePreviousSignIn()
            return true
        } else {
            return false
        }
    }
    
    func restorePreviousLogin() {
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }
    
    func getProfileData(completion: @escaping (ProfileInfo) -> Void) {
        if let profile = profile {
            completion(profile)
        }
    }
}

// MARK: - GIDSignInDelegate methods

extension GoogleAuthManager: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        
        // Perform any operations on signed in user here.
        // user.userID                  // For client-side use only!
        // user.authentication.idToken // Safe to send to the server
        
        profile = ProfileInfo(firstName: user.profile.givenName, lastName: user.profile.familyName, fullName: user.profile.name, id: user.authentication.idToken, email: user.profile.email, imageURL: (user.profile.imageURL(withDimension:400)?.absoluteString)!)
        onLogInSuccess?()
    }
}
