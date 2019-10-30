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
                self.getProfileData { (profileInfo) in
                    let datastore = ProfileDatastore()
                    let profile = Profile(context: datastore.managedContext)
                    onMainQueue {
                        profile.givenName = profileInfo.first_name
                        profile.familyName = profileInfo.last_name
                        profile.email = profileInfo.email
                        datastore.appendProfile(profileInfo: profile)
                    }
                }
                onSuccess()
                return
            }
            onFailure("Access Not Granted")
        }
    }
    
    
    static let instance = FacebookAuthManager()
    
    var isAuthorized = {
        return AccessToken.current != nil
    }
    
    func logout() {
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logOut()
        NotificationCenter.default.post(Notification(name: .init(Constants.Notifications.UserLogedOut)))
    }
    
    func getProfileData(completion: @escaping (FBProfileInfo)->Void){
        if((AccessToken.current) != nil) {
            let params = FieldsHelper.getParameters(for: [.id, .picture, . email, .name])
            GraphRequest(graphPath: "me", parameters: params).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil), let result = result as? [String:Any] {
                    completion(FBProfileInfo(dict: result))
                }
            })
        }
    }
}
