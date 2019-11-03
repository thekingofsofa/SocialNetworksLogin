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
    
    var profile: ProfileInfo?
    var onLogInSuccess: (()->Void)?
    
    func login(in viewController: UIViewController, onSuccess: @escaping () -> Void, onFailure: @escaping (String) -> Void) {
        onLogInSuccess = onSuccess
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
    
    func checkAuthorization() -> Bool {
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
    
    func getProfileData(completion: @escaping (ProfileInfo) -> Void) {
        if let profile = profile {
            completion(profile)
        }
    }
}

// MARK: - ASAuthorizationControllerDelegate methods

@available(iOS 13, *)
extension AppleAuthManager: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            profile = ProfileInfo(firstName: appleIDCredential.fullName?.givenName, lastName: appleIDCredential.fullName?.familyName, fullName: appleIDCredential.fullName?.description, id: userIdentifier, email: appleIDCredential.email, imageURL: nil)
            
            // For the purpose of this demo app, store the userIdentifier in the keychain.
            do {
                try KeychainItem(service: "com.example.apple-samplecode.juice", account: "userIdentifier").saveItem(userIdentifier)
            } catch {
                print("Unable to save userIdentifier to keychain.")
            }
            onLogInSuccess?()
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}
