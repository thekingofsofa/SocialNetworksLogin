//
//  LoginView.swift
//  ThreeInOneLoginApp
//
//  Created by Иван Барабанщиков on 11/1/19.
//  Copyright © 2019 Ivan Barabanshchykov. All rights reserved.
//

import UIKit

class LoginView: BaseView {
    
    let facebookButton = ActionButton()
    let googleButton = ActionButton()
    let appleButton = ActionButton()
    
    override func setupSubviews() {
        setupFBButton()
        setupGIDButton()
        if #available(iOS 13, *) {
            setUpSignInAppleButton()
        }
    }
    
    @available(iOS 13, *)
    private func setUpSignInAppleButton() {
        addSubview(appleButton)
        appleButton.anchor(top: nil, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 0, left: 12, bottom: 0, right: 12), size: .init(width: 0, height: 50))
        appleButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 60).isActive = true
        appleButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        appleButton.setupUI(bordered: false, textColor: .white, secondaryColor: .lightGray)
    }
    
    private func setupFBButton() {
        addSubview(facebookButton)
        facebookButton.anchor(top: nil, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 0, left: 12, bottom: 0, right: 12), size: .init(width: 0, height: 50))
        facebookButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        facebookButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        facebookButton.setupUI(bordered: false, textColor: .white, secondaryColor: .lightGray)
    }
    
    private func setupGIDButton() {
        addSubview(googleButton)
        googleButton.anchor(top: nil, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 0, left: 12, bottom: 0, right: 12), size: .init(width: 0, height: 50))
        googleButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -60).isActive = true
        googleButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        googleButton.setupUI(bordered: false, textColor: .white, secondaryColor: .lightGray)
    }
}
