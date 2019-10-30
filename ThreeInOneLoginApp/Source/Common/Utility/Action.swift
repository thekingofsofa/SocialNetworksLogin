//
//  Action.swift
//  ThreeInOneLoginApp
//
//  Created by Иван Барабанщиков on 10/29/19.
//  Copyright © 2019 Ivan Barabanshchykov. All rights reserved.
//

import Foundation

struct Action {
    let title: String?
    let iconName: String?
    let handler: () -> Void
}
