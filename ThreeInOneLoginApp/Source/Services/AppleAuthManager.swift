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
class AppleAuthManager: NSObject, AuthManager {
    
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
    
    func checkIfAuthorized() -> Bool {
        let semaphore = DispatchSemaphore(value: 0)
        var result = false
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier) { (credentialState, error) in
            switch credentialState {
            case .authorized:
                // The Apple ID credential is valid.
                result = true
                semaphore.signal()
            case .revoked:
                // The Apple ID credential is revoked.
                semaphore.signal()
            case .notFound:
                // No credential was found, so show the sign-in UI.
                semaphore.signal()
            default:
                semaphore.signal()
                break
            }
        }
        semaphore.wait()
        return result
    }
}

// MARK: - ASAuthorizationControllerDelegate methods

@available(iOS 13, *)
extension AppleAuthManager: ASAuthorizationControllerDelegate {
    
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
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}
