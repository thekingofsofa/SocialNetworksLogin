//
//  FacebookAuthManager.swift
//  PharosTestApp
//
//  Created by Andriy Roshchin on 10/21/19.
//  Copyright © 2019 Andriy Roshchin. All rights reserved.
//

import Foundation
import FacebookCore
import FacebookLogin

class FacebookAuthManager: AuthManager {
    
    func login(in viewController: UIViewController, onSuccess: @escaping () -> Void, onFailure: @escaping (String) -> Void) {
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email", "public_profile"], from: viewController) { (result, error) -> Void in
            if let error = error {
                onFailure((error as NSError).localizedDescription)
                return
            }
            if let result = result, result.grantedPermissions.contains("email") {
                onSuccess()
                return
            }
            onFailure("Access Not Granted")
        }
    }
    
    func logout() {
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logOut()
        NotificationCenter.default.post(Notification(name: .init(Constants.Notifications.UserLogedOut)))
    }
    
    func checkAuthorization() -> Bool {
        return AccessToken.current != nil
    }
    
    func getProfileData(completion: @escaping (ProfileInfo)->Void){
        if((AccessToken.current) != nil) {
            let params = FieldsHelper.getParameters(for: [.id, .picture, . email, .name])
            GraphRequest(graphPath: "me", parameters: params).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil), let result = result as? [String:Any] {
                    let profileInfo = ProfileInfo(dict: result)
                    completion(profileInfo)
                }
            })
        }
    }
}
