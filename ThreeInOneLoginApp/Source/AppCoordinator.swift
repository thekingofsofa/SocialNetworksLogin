//
//  AppCoordinator.swift
//  ThreeInOneLoginApp
//
//  Created by Иван Барабанщиков on 10/29/19.
//  Copyright © 2019 Ivan Barabanshchykov. All rights reserved.
//

import UIKit

class AppCoordinator {
    var navigationController: UINavigationController
    
    convenience init() {
        self.init(navigationController: UINavigationController())
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        configureNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func start() {
        let authHelper = AuthHelper()
        if authHelper.checkAuthorizationInAllManagers() {
            showProfilePage()
        } else {
            showLoginPage()
        }
    }
}

private extension AppCoordinator {
    
    // MARK: - Configuration
    func configureNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onDidLogout), name: Notification.Name.init(Constants.Notifications.UserLogedOut), object: nil)
    }
    
    // MARK: - Actions
    @objc func onDidLogout() {
        start()
    }
    
    // MARK: - Navigation Actions
    func showLoginPage() {
        navigationController.isNavigationBarHidden = false
        let vc = LoginViewController()
        vc.onLogInSuccess = { [weak self] in
            self?.showProfilePage()
        }
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func showProfilePage() {
        navigationController.isNavigationBarHidden = false
        let vc = ProfileViewController()
        let datastore = ProfileDatastore()
        navigationController.setViewControllers([vc], animated: true)
        vc.profile = datastore.fetchProfile()
    }
}
