//
//  LoginViewController.swift
//  ThreeInOneLoginApp
//
//  Created by Иван Барабанщиков on 10/29/19.
//  Copyright © 2019 Ivan Barabanshchykov. All rights reserved.
//

import UIKit
import AuthenticationServices

class LoginViewController: BaseViewController {
    
    var onLogInSuccess: (()->Void)?
    
    private var loginView = LoginView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.Titles.Login
        setupViews()
    }
    
    // MARK: - Setup UI
    private func setupViews() {
        view.backgroundColor = .red
        view.addSubview(loginView)
        loginView.anchor(top: nil, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, padding: .init(top: 0, left: 12, bottom: 0, right: 12), size: .init(width: 0, height: 200))
        loginView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        loginView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        loginView.facebookButton.action = Action(title: Constants.ButtonTitles.FBLogin, iconName: nil, handler: { [weak self] in
            self?.loginFacebook()
        })
        loginView.googleButton.action = Action(title: Constants.ButtonTitles.GoogleLogin, iconName: nil, handler: { [weak self] in
            self?.loginGoogle()
        })
        loginView.appleButton.action = Action(title: Constants.ButtonTitles.AppleLogin, iconName: nil, handler: { [weak self] in
            if #available(iOS 13, *) {
                self?.loginApple()
            }
        })
    }
    
    // MARK: - Actions
    @objc private func loginFacebook() {
        AuthHelper.instance.authManager = FacebookAuthManager()
        beginLogin()
    }
    
    @objc private func loginGoogle() {
        AuthHelper.instance.authManager = GoogleAuthManager()
        beginLogin()
    }
    
    @available(iOS 13, *)
    @objc private func loginApple() {
        AuthHelper.instance.authManager = AppleAuthManager()
        beginLogin()
    }
    
    private func beginLogin() {
        AuthHelper.instance.login(in: self, onSuccess: { [weak self] in
            self?.onLogInSuccess?()
        }) { [weak self] errorMessage in
            self?.showMessage(errorMessage)
        }
    }
}
