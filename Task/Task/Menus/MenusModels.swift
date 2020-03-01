//
//  MenusModels.swift
//  Task
//
//  Created by Alberto Martínez Fernández on 29/02/2020.
//  Copyright (c) 2020 Alberto Martínez Fernández. All rights reserved.
//

import UIKit

struct Menu: Codable {
    let date: String
    let turn: String
    let salad: String
    let first: String
    let second: String
    let others1: String
    let others2: String
    let dessert: String
    let dairy: String
}

struct MenuTableViewModel {
    var month: String
    var dayMonth: String
    var dayWeek: String
    var colorLineSeparator: UIColor
    var turn: String
    var first: String
    var second: String
    var dessert: String
}
