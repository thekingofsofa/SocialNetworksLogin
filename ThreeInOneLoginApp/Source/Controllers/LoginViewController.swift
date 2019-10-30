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
    private let facebookButton = ActionButton()
    private let googleButton = ActionButton()
    private let appleButton = ActionButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.Titles.Login
        setupViews()
        GoogleAuthManager.instance.login(presentingViewController: self, onSuccess: onLogInSuccess)
    }
    
    // MARK: - Setup UI
    private func setupViews() {
        view.backgroundColor = .red
        setupGIDButton()
        setupFBButton()
        if #available(iOS 13, *) {
            setUpSignInAppleButton()
        }
    }
    
    @available(iOS 13, *)
    func setUpSignInAppleButton() {
        view.addSubview(appleButton)
        appleButton.anchor(top: nil, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, padding: .init(top: 0, left: 12, bottom: 0, right: 12), size: .init(width: 0, height: 50))
        appleButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 60).isActive = true
        appleButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        appleButton.setupUI(bordered: false, textColor: .white, secondaryColor: .lightGray)
        appleButton.action = Action(title: Constants.ButtonTitles.AppleLogin, iconName: nil, handler: { [weak self] in
            self?.handleAppleIdRequest()
        })
    }
    
    private func setupFBButton() {
        view.addSubview(facebookButton)
        facebookButton.anchor(top: nil, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, padding: .init(top: 0, left: 12, bottom: 0, right: 12), size: .init(width: 0, height: 50))
        facebookButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        facebookButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        facebookButton.setupUI(bordered: false, textColor: .white, secondaryColor: .lightGray)
        facebookButton.action = Action(title: Constants.ButtonTitles.FBLogin, iconName: nil, handler: { [weak self] in
            self?.loginFacebook()
        })
    }
    
    private func setupGIDButton() {
        
        view.addSubview(googleButton)
        googleButton.anchor(top: nil, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, padding: .init(top: 0, left: 12, bottom: 0, right: 12), size: .init(width: 0, height: 50))
        googleButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -60).isActive = true
        googleButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        googleButton.setupUI(bordered: false, textColor: .white, secondaryColor: .lightGray)
        googleButton.action = Action(title: Constants.ButtonTitles.GoogleLogin, iconName: nil, handler: { [weak self] in
            self?.loginGoogle()
        })
    }
    
    // MARK: - Actions
    @objc private func loginFacebook() {
        FacebookAuthManager.instance.login(in: self, onSuccess: { [weak self] in
            self?.onLogInSuccess?()
        }) { [weak self] errorMessage in
            self?.showMessage(errorMessage)
        }
    }
    
    @objc private func loginGoogle() {
        GoogleAuthManager.instance.login(presentingViewController: self, onSuccess: onLogInSuccess)
    }
    
    @available(iOS 13, *)
    @objc func handleAppleIdRequest() {
        AppleAuthManager.instance.onLogInSuccess = onLogInSuccess
        AppleAuthManager.instance.handleAppleIdRequest()
    }
}
