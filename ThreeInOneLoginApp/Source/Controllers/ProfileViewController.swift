//
//  ProfileViewController.swift
//  ThreeInOneLoginApp
//
//  Created by Иван Барабанщиков on 10/29/19.
//  Copyright © 2019 Ivan Barabanshchykov. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    var profile: Profile? {
        didSet {
            configureView()
        }
    }
    var reloadAction: (()->Void)?
    
    private let profileView = ProfileView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.Titles.Profile
        
        setupViews()
    }
    
    // MARK: - Setup UI
    private func setupViews() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: Constants.ButtonTitles.Logout, style: .plain, target: self, action: #selector(logoutTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(updateTapped))
        
        view.addSubview(profileView)
        profileView.fillSuperview()
    }
    
    private func configureView() {
        if let profile = profile {
            profileView.configure(profile: profile)
        }
    }
    
    // MARK: - Actions
    @objc private func logoutTapped() {
        AuthHelper.instance.logout()
        self.close()
    }
    
    @objc private func updateTapped() {
        let datastore = ProfileDatastore()
        profile = datastore.fetchProfile()
    }
}
