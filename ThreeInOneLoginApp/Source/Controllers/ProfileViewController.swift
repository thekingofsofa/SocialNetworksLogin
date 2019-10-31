//
//  ProfileViewController.swift
//  ThreeInOneLoginApp
//
//  Created by Иван Барабанщиков on 10/29/19.
//  Copyright © 2019 Ivan Barabanshchykov. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    private let profileView = ProfileView()
    var profile: Profile? {
        didSet {
            configureView()
        }
    }
    
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
    
    func configureView() {
        if let profile = profile {
            profileView.configure(profile: profile)
        }
    }
    
    // MARK: - Actions
    @objc func logoutTapped() {
        let authHelper = AuthHelper()
        authHelper.logoutFromAllAuthManagers()
        self.close()
    }
    
    @objc func updateTapped() {
        let datastore = ProfileDatastore()
        profile = datastore.fetchProfile()
    }
}
