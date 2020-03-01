//
//  MenuTableViewCell.swift
//  Task
//
//  Created by Alberto Martínez Fernández on 01/03/2020.
//  Copyright © 2020 Alberto Martínez Fernández. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    @IBOutlet var labelMonth: UILabel!
    @IBOutlet var labelDayMonth: UILabel!
    @IBOutlet var labelDayWeek: UILabel!
    @IBOutlet var viewLineSeparator: UIView!
    @IBOutlet var labelMenuTitle: UILabel!
    @IBOutlet var labelFirstTitle: UILabel!
    @IBOutlet var labelFirstValue: UILabel!
    @IBOutlet var labelSecondTitle: UILabel!
    @IBOutlet var labelSecondValue: UILabel!
    @IBOutlet var labelDessertTitle: UILabel!
    @IBOutlet var labelDessertValue: UILabel!
    
    static let cellHeight: CGFloat = 93
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static var cellIdentifier: String {
        return String(describing: MenuTableViewCell.self)
    }
    
    func updateUI(menuModel: MenuTableViewModel) {
        labelMonth.text = menuModel.month
        labelDayMonth.text = menuModel.dayMonth
        labelDayWeek.text = menuModel.dayWeek
        viewLineSeparator.backgroundColor = menuModel.colorLineSeparator
        labelMenuTitle.text = menuModel.turn
        labelFirstTitle.text = Language.localizedString(string: "menu_first_title")
        labelFirstValue.text = menuModel.first
        labelSecondTitle.text = Language.localizedString(string: "menu_second_titile")
        labelSecondValue.text = menuModel.second
        labelDessertTitle.text = Language.localizedString(string: "menu_dessert_title")
        labelDessertValue.text = menuModel.dessert
    }
}
