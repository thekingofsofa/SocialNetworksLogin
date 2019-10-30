//
//  DispatchQueueHelper.swift
//  ThreeInOneLoginApp
//
//  Created by Иван Барабанщиков on 10/29/19.
//  Copyright © 2019 Ivan Barabanshchykov. All rights reserved.
//


import Foundation

func onMainQueue(_ block: @escaping () -> Void) {
    DispatchQueue.main.async(execute: block)
}

func onGlobalUtilityQueue(_ block: @escaping () -> Void) {
    DispatchQueue.global(qos: .utility).async(execute: block)
}
