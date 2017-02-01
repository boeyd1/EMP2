//
//  TimeConverter.swift
//  EMP2
//
//  Created by Desmond Boey on 1/2/17.
//  Copyright © 2017 DominicBoey. All rights reserved.
//

import Foundation

class TimeConverter{
    private static let _instance = TimeConverter()
    static var Instance: TimeConverter {
        return _instance
    }
    
    func getTimeLabel(dt: Double) -> String {
        
        let date = Date(timeIntervalSince1970: dt)
        
        if daysBetween(end: date) == 1 {
            return "\(daysBetween(end: date)) day ago"
        }else if daysBetween(end: date) > 1 {
            return "\(daysBetween(end: date)) days ago"
        }else{
        
        return convertFrom1970(dt: dt)
        }
    }
    
    
    func convertFrom1970(dt: Double) -> String {
        
        let date = NSDate(timeIntervalSince1970: dt)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
        // dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        // dateFormatter.timeZone = NSTimeZone() as TimeZone!
        return dateFormatter.string(from: date as Date)
    }
    
    func daysBetween(end: Date) -> Int {
        
        
        
        let cal: Calendar = Calendar(identifier: .gregorian)
        
        let endDateMidnight:Date = cal.date(bySettingHour: 0, minute: 0, second: 0, of: end)!
        
        let midnightToday: Date = cal.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        
        return Calendar.current.dateComponents([.day], from: endDateMidnight, to: midnightToday).day!
    }

    
}
