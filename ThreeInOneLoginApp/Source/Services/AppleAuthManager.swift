//
//  AppleAuthManager.swift
//  ThreeInOneLoginApp
//
//  Created by Иван Барабанщиков on 10/29/19.
//  Copyright © 2019 Ivan Barabanshchykov. All rights reserved.
//

import Foundation
import AuthenticationServices

@available(iOS 13, *)
class AppleAuthManager: NSObject, ASAuthorizationControllerDelegate, AuthManager {
    
    static let instance = AppleAuthManager()
    private let datastore = ProfileDatastore()
    
    var onLogInSuccess: (()->Void)?
    
    func login(in viewController: UIViewController, onSuccess: @escaping () -> Void, onFailure: @escaping (String) -> Void) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    func logout() {
        // For the purpose of this demo app, delete the user identifier that was previously stored in the keychain.
        KeychainItem.deleteUserIdentifierFromKeychain()
        NotificationCenter.default.post(Notification(name: .init(Constants.Notifications.UserLogedOut)))
    }
    
    func checkAuthorization(completionHandler: @escaping(_ isAuthorized: Bool) -> Void) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier) { (credentialState, error) in
             switch credentialState {
                case .authorized:
                    // The Apple ID credential is valid.
                    DispatchQueue.main.async {
                        completionHandler(true)
                    }
                case .revoked:
                    // The Apple ID credential is revoked.
                    DispatchQueue.main.async {
                        completionHandler(false)
                    }
                case .notFound:
                    // No credential was found, so show the sign-in UI.
                    DispatchQueue.main.async {
                        completionHandler(false)
                    }
                default:
                    break
             }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let profile = Profile(context: datastore.managedContext)
            let userIdentifier = appleIDCredential.user
            profile.givenName = appleIDCredential.fullName?.givenName
            profile.familyName = appleIDCredential.fullName?.familyName
            profile.email = appleIDCredential.email
            
            datastore.appendProfile(profileInfo: profile)
            // For the purpose of this demo app, store the userIdentifier in the keychain.
            do {
                try KeychainItem(service: "com.example.apple-samplecode.juice", account: "userIdentifier").saveItem(userIdentifier)
            } catch {
                print("Unable to save userIdentifier to keychain.")
            }
            onLogInSuccess!()
        }
    }
}