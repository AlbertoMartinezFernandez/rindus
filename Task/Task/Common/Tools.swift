//
//  Tools.swift
//  Task
//
//  Created by Alberto Martínez Fernández on 29/02/2020.
//  Copyright © 2020 Alberto Martínez Fernández. All rights reserved.
//

import UIKit

class Tools {
    static let dateHourFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    static let dateFormatYearMonthDay = "yyyy-MM-dd"
    static let dateFormatHourMinute = "HH:mm"
    
    static func parseDateAndHour(fromString: String) -> (String, String) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateFormat = dateHourFormat
        let date = dateFormatter.date(from: fromString)
        
        var dateString = ""
        var hourString = ""
        if date != nil {
            dateFormatter.dateFormat = dateFormatYearMonthDay
            dateString = dateFormatter.string(from: date!)
            
            dateFormatter.dateFormat = dateFormatHourMinute
            hourString = dateFormatter.string(from: date!)
        }
        
        return (dateString, hourString)
    }
    
    static func getDateInfoFromStringDate(stringDate:String, options: NSCalendar.Unit) -> Dictionary<String, String> {
        
        let formatter  = DateFormatter()
        formatter.dateFormat = Tools.dateFormatYearMonthDay
        
        return Tools.getDateInfoFromDate(date: formatter.date(from: stringDate), options: options)
    }
    
    static func getDateInfoFromDate(date:Date?, options: NSCalendar.Unit) -> Dictionary<String, String> {
        var dateFormatDictionary = Dictionary<String, String>()
        
        if let date = date {
            let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            let myComponents = myCalendar.components(options, from: date)
            
            if myComponents.weekOfYear != nil {
                dateFormatDictionary["weekOfYear"] = String(describing: myComponents.weekOfYear!)
            }
            if myComponents.day != nil {
                dateFormatDictionary["day"] = String(format: "%02d", myComponents.day!)
            }
            if myComponents.month != nil {
                dateFormatDictionary["month"] = String(format: "%02d", myComponents.month!)
            }
            if myComponents.weekday != nil {
                dateFormatDictionary["weekday"] = parseDayOfWeekIntoString(dayNumber: myComponents.weekday!)
                dateFormatDictionary["weekdaynumber"] = parseDayOfWeekIntoStringNumber(originalDayNumber: myComponents.weekday!)
            }
            if myComponents.year != nil {
                dateFormatDictionary["year"] = String(describing: myComponents.year!)
            }
        }
        
        return dateFormatDictionary
    }
    
    private static func parseDayOfWeekIntoString(dayNumber:Int)->String {
        var dayString:String? = nil
        switch dayNumber {
        case 1: dayString = Language.localizedString( string: "day_of_week_sunday" )
        case 2: dayString = Language.localizedString( string: "day_of_week_monday" )
        case 3: dayString = Language.localizedString( string: "day_of_week_tuesday" )
        case 4: dayString = Language.localizedString( string: "day_of_week_wednesday" )
        case 5: dayString = Language.localizedString( string: "day_of_week_thursday" )
        case 6: dayString = Language.localizedString( string: "day_of_week_friday" )
        case 7: dayString = Language.localizedString( string: "day_of_week_saturday" )
        default: dayString = ""
        }
        
        return dayString!
    }
    
    private static func parseDayOfWeekIntoStringNumber(originalDayNumber:Int) -> String {
        var dayNumber:Int!
        
        if originalDayNumber == 1 {
            dayNumber = 7
        } else {
            dayNumber = originalDayNumber - 1
        }
        
        return String(dayNumber)
    }
    
    static func parseMonth(monthNumber:Int)->String {
        var monthString:String? = nil
        switch monthNumber {
        case 1: monthString = Language.localizedString( string: "month_january" )
        case 2: monthString = Language.localizedString( string: "month_february" )
        case 3: monthString = Language.localizedString( string: "month_march" )
        case 4: monthString = Language.localizedString( string: "month_april" )
        case 5: monthString = Language.localizedString( string: "month_may" )
        case 6: monthString = Language.localizedString( string: "month_june" )
        case 7: monthString = Language.localizedString( string: "month_july" )
        case 8: monthString = Language.localizedString( string: "month_august" )
        case 9: monthString = Language.localizedString( string: "month_september" )
        case 10: monthString = Language.localizedString( string: "month_october" )
        case 11: monthString = Language.localizedString( string: "month_november" )
        case 12: monthString = Language.localizedString( string: "month_december" )
        default: monthString = ""
        }
        
        return monthString!
    }
    
    static func createLabelForNavigationBar(frame: CGRect, font: UIFont, color: UIColor, text: String) -> UILabel {
        let label = UILabel(frame: frame)
        label.font = font
        label.textColor = color
        label.textAlignment = .center
        label.text = text
        
        return label
    }
    
    static func createButtonForNavigationBar(iconName: String) -> UIButton {
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: iconName), for: UIControl.State.normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        
        return button
    }
}
