//
//  FBProfileInfo.swift
//  PharosTestApp
//
//  Created by Andriy Roshchin on 10/22/19.
//  Copyright © 2019 Andriy Roshchin. All rights reserved.
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

struct FBProfileInfo {
    let first_name: String?
    let last_name: String?
    let name: String?
    let id: String?
    let email: String?
    let imageURL: String?
    
    init(dict: [String:Any]) {
        first_name = dict["first_name"] as? String
        last_name = dict["last_name"] as? String
        name = dict["name"] as? String
        id = dict["id"] as? String
        email = dict["email"] as? String
        imageURL = ((dict["picture"] as? [String:Any])?["data"] as? [String:Any])?["url"] as? String
    }
}
