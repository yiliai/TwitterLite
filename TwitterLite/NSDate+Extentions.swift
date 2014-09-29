//
//  NSDate+Extentions.swift
//  TwitterLite
//
//  Created by Yili Aiwazian on 9/28/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import Foundation

let MINUTE:Int = 60
let HOUR:Int = MINUTE * 60
let DAY:Int = HOUR * 24
let WEEK:Int = DAY * 7

extension NSDate {
    
    func prettyTimeElapsed() -> String {
        let diff = Int(self.timeIntervalSinceNow) * (-1)
        
        if (diff <= 0) {
            return "Now"
        }
        if (diff < MINUTE){
            return String("\(diff)s")
        }
        if (diff < HOUR) {
            let min = Int(diff/MINUTE)
            return String("\(min)m")
        }
        if (diff < DAY) {
            let hour = Int(diff/HOUR)
            return String("\(hour)h")
        }
        if (diff < WEEK) {
            let days = Int(diff/DAY)
            return String("\(days)d")
        }
        // More than 7 days ago
        let now = NSDate.date()
        let calendar = NSCalendar.currentCalendar()
        let componentFlags = NSCalendarUnit.YearCalendarUnit
        let nowComponents = calendar.components(componentFlags, fromDate: now)
        let selfComponents = calendar.components(componentFlags, fromDate: self)
        
        var formatter = NSDateFormatter()
        
        // If current year, return "7 Jun" format
        if (selfComponents.year == nowComponents.year) {
            formatter.dateFormat = "d MMM"
        } else { // Not the current year, return "7 Jun 2012" format
            formatter.dateFormat = "d MMM yyyy"
        }        
        return formatter.stringFromDate(self)
    }
}