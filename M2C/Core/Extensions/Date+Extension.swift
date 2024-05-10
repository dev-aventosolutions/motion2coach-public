//
//  DateExtension.swift
//  M2C
//
//  Created by Muhammad Bilal Hussain on 10/05/2022.
//

import Foundation

extension Date {
    
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    }
    var earlierThisWeek: Date {
        return Calendar.current.date(byAdding: .day, value: -7, to: Date())!
    }
    
    var thisMonth: Int {
        return Calendar.current.component(.month,  from: self)
    }
    
    var thisYear: Int {
        return Calendar.current.component(.year,  from: self)
    }
    
    func onlyDate() -> Date? {
        
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        let result = dateFormatter.string(from: self)
        
        return result.dateFromStringWithoutTime()
        
    }
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    func stringFromDateWithOnlyTime() -> String{
        let formate = DateFormatter()
        formate.dateFormat = "hh:mm a"
        formate.timeZone = TimeZone.autoupdatingCurrent
        return formate.string(from:self)
    }
    
    func stringFromDateWithTime() -> String{
        let formate = ISO8601DateFormatter()
        formate.timeZone = TimeZone.autoupdatingCurrent
        formate.formatOptions = [.withFullDate,.withFullTime,.withColonSeparatorInTime,.withTimeZone,.withColonSeparatorInTimeZone]
        return formate.string(from:self)
    }
    
    func toDateString(format: String = "MMMM dd, yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func toDateStringMonthShort(format: String = "MMM dd, yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func toDateMonthThreeCharString(format: String = "MMM dd, yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func DateToString() -> String
    {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "YYYY-MM-dd"
        dateFormater.timeZone = TimeZone.autoupdatingCurrent
        let dateString = dateFormater.string(from: self)
        
        return dateString
    }
    func DateAndTimeToString() -> String
    {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZ"
        dateFormater.timeZone = TimeZone.autoupdatingCurrent
        let dateString = dateFormater.string(from: self)
        
        return dateString
    }
    
    func toStringFromDate() -> String{
        let formate = DateFormatter()
        formate.dateFormat = "MMM dd, yyyy"
        formate.timeZone = .current
        return formate.string(from:self)
    }
    
    func toTimeStringWithZone() -> String{
        let dateformatter = DateFormatter()
        dateformatter.timeStyle = .medium
        dateformatter.dateStyle = .none
        let dateStr = dateformatter.string(from: Date())
        
        let formate = ISO8601DateFormatter()
        
        
        formate.formatOptions = [.withTime,.withTimeZone,.withColonSeparatorInTimeZone]
        print("String Date: \(formate.string(from:dateformatter.date(from: dateStr)!))")
        return formate.string(from:dateformatter.date(from: dateStr)!)
        
    }
    
    func stringFromDate() -> String{
        
        let dateformatter = DateFormatter()
        dateformatter.timeStyle = .none
        dateformatter.dateStyle = .medium
        let dateStr = dateformatter.string(from: self)
        
        let formate = ISO8601DateFormatter()
        formate.timeZone = TimeZone.autoupdatingCurrent
        formate.formatOptions = [.withFullDate,.withTime,.withTimeZone,.withColonSeparatorInTime,.withColonSeparatorInTimeZone]
        print("String Date: \(formate.string(from:dateformatter.date(from: dateStr)!))")
        return formate.string(from:dateformatter.date(from: dateStr)!)
    }
    
}


extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}
