//
//  EventTableViewCell.swift
//  Task
//
//  Created by Alberto Martínez Fernández on 01/03/2020.
//  Copyright © 2020 Alberto Martínez Fernández. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    @IBOutlet var labelMonth: UILabel!
    @IBOutlet var labelDayMonth: UILabel!
    @IBOutlet var labelHourStart: UILabel!
    @IBOutlet var labelHourEnd: UILabel!
    @IBOutlet var labelDayWeek: UILabel!
    @IBOutlet var viewLineSeparator: UIView!
    @IBOutlet var labelEventType: UILabel!
    @IBOutlet var labelEventTitle: UILabel!
    @IBOutlet var labelEventLocation: UILabel!
    
    static let cellHeight: CGFloat = 93
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static var cellIdentifier: String {
        return String(describing: EventTableViewCell.self)
    }
    
    func updateUI(eventTableViewModel: EventTableViewModel) {
        labelMonth.text = eventTableViewModel.month
        labelDayMonth.text = eventTableViewModel.dayMonth
        labelHourStart.text = eventTableViewModel.hourStart
        labelHourEnd.text = eventTableViewModel.hourEnd
        labelDayWeek.text = eventTableViewModel.dayWeek
        viewLineSeparator.backgroundColor = eventTableViewModel.colorLineSeparator
        labelEventType.text = eventTableViewModel.eventType
        labelEventTitle.text = eventTableViewModel.eventTitle
        labelEventLocation.text = eventTableViewModel.eventLocation
    }
}
