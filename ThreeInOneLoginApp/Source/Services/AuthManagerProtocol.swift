//
//  LoginManager.swift
//  ThreeInOneLoginApp
//
//  Created by Иван Барабанщиков on 10/30/19.
//  Copyright © 2019 Ivan Barabanshchykov. All rights reserved.
//

import UIKit

protocol AuthManager {
    func login(in viewController: UIViewController, onSuccess: @escaping ()-> Void, onFailure: @escaping (String)->Void)
    func logout()
}
