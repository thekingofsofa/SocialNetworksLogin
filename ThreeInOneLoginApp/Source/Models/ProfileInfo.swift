//
//  LoginView.swift
//  ThreeInOneLoginApp
//
//  Created by Иван Барабанщиков on 11/1/19.
//  Copyright © 2019 Ivan Barabanshchykov. All rights reserved.
//

import Foundation

struct FieldsHelper {
    enum FieldType: String {
        case id = "id"
        case name = "name"
        case firstName = "first_name"
        case lastName = "last_name"
        case picture = "picture.type(large)"
        case email = "email"
    }
    
    static func getParameters(for fields: [FieldType]) -> [String:Any] {
        return ["fields": fields.map { $0.rawValue }.joined(separator: ", ")]
    }
}

struct ProfileInfo {
    let firstName: String?
    let lastName: String?
    let fullName: String?
    let id: String?
    let email: String?
    let imageURL: String?
    
    init(dict: [String:Any]) {
        firstName = dict["first_name"] as? String
        lastName = dict["last_name"] as? String
        fullName = dict["name"] as? String
        id = dict["id"] as? String
        email = dict["email"] as? String
        imageURL = ((dict["picture"] as? [String:Any])?["data"] as? [String:Any])?["url"] as? String
    }
    
    init(firstName: String?, lastName: String?, fullName: String?, id: String?, email: String?, imageURL: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.fullName = fullName
        self.id = id
        self.email = email
        self.imageURL = imageURL
    }
}
