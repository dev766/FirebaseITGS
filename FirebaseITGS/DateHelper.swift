//
//  DateExtension.swift
//
//  Created by S.S Bhati on 06/30/22.

import Foundation
class DateHelper
{

    lazy var formatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, d MMM yyyy"
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    lazy var dateComponents:DateComponents = {
        var dateComp = DateComponents()
        dateComp.day = 1
        return dateComp
    }()
    
    lazy var prevDateComponents:DateComponents = {
        var dateComp = DateComponents()
        dateComp.day = -1
        return dateComp
    }()
    
    
    
    func getNext(dateString:String) -> String?
    {
        if let date =  self.formatter.date(from: dateString),
            let nextDate = Calendar.current.date(byAdding: self.dateComponents, to: date)
        {
            return self.formatter.string(from: nextDate)
        }
        return nil
    }
    
    func getPrevious(dateString:String) -> String?
    {
        if let date =  self.formatter.date(from: dateString),
            let preViousDate = Calendar.current.date(byAdding: self.prevDateComponents, to: date)
        {
            return self.formatter.string(from: preViousDate)
        }
        return nil
    }
    func changeTimeFormat(date : String, fromFormate : String, toFormate: String)-> String
    {
        if date == ""
        {return ""}
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = fromFormate//"hh:mm a"
        var fullDate = dateFormatter.date(from: date)
        if fullDate == nil
        {
            dateFormatter.dateFormat = "HH:mm"
            fullDate = dateFormatter.date(from: date)
        }
        dateFormatter.dateFormat = toFormate//"HH:mm"
        let time2 = dateFormatter.string(from: fullDate!)
        return time2
    }
    
    func getCurrentTime(format: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let time = dateFormatter.string(from: Date())
        return time
    }
    
    func changeTimeFormatForSetting(date : String, fromFormate : String, toFormate: String)-> String
    {
        if date == ""
        {return ""}
        let dateFormatter = DateFormatter()
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"
        dateFormatter.dateFormat = fromFormate//"hh:mm a"
        var fullDate = dateFormatter.date(from: date)
        if fullDate == nil
        {
            dateFormatter.dateFormat = "hh:mm a"
            fullDate = dateFormatter.date(from: date)
        }
        dateFormatter.dateFormat = toFormate//"HH:mm"
        let time2 = dateFormatter.string(from: fullDate!)
        return time2
    }
    
    func convertDateFormatter(date: Date,formatterString:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = formatterString
        dateFormatter.timeZone = TimeZone.current
        let timeStamp = dateFormatter.string(from: date)
        return timeStamp
    }
    func convertUTCDateFormatter(date: Date,formatterString:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        dateFormatter.dateFormat = formatterString
        let timeStamp = dateFormatter.string(from: date)
        return timeStamp
    }
    
    func convertStringToDate(stringDate: String, stringDateFormat: String) -> Date{
        
        let dateFormatterTest = DateFormatter()
        dateFormatterTest.dateFormat = "MM/dd/yyyy"
        dateFormatterTest.timeZone = TimeZone.current
        dateFormatterTest.locale = Locale(identifier: "en_US_POSIX")
        
        let dateFormatterTest2 = DateFormatter()
        dateFormatterTest2.dateFormat = "dd/MM/yyyy"
        dateFormatterTest2.timeZone = TimeZone.current
        dateFormatterTest2.locale = Locale(identifier: "en_US_POSIX")
        
        let dateFormatterTest3 = DateFormatter()
        dateFormatterTest3.dateFormat = "yyyy/MM/dd"
        dateFormatterTest3.timeZone = TimeZone.current
        dateFormatterTest3.locale = Locale(identifier: "en_US_POSIX")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = stringDateFormat
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: stringDate) ?? dateFormatterTest.date(from: stringDate) ?? dateFormatterTest2.date(from: stringDate) ?? dateFormatterTest3.date(from: stringDate) ?? Date()
    }
    
    func convertStringToDateUTCDateFormatter(stringDate: String, stringDateFormat: String) -> Date{
        
        let dateFormatterTest = DateFormatter()
        dateFormatterTest.dateFormat = "MM/dd/yyyy"
        dateFormatterTest.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        dateFormatterTest.locale = Locale(identifier: "en_US_POSIX")
        
        let dateFormatterTest2 = DateFormatter()
        dateFormatterTest2.dateFormat = "dd/MM/yyyy"
        dateFormatterTest2.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        dateFormatterTest2.locale = Locale(identifier: "en_US_POSIX")
        
        let dateFormatterTest3 = DateFormatter()
        dateFormatterTest3.dateFormat = "yyyy/MM/dd"
        dateFormatterTest3.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        dateFormatterTest3.locale = Locale(identifier: "en_US_POSIX")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = stringDateFormat
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: stringDate) ?? dateFormatterTest.date(from: stringDate) ?? dateFormatterTest2.date(from: stringDate) ?? dateFormatterTest3.date(from: stringDate) ?? Date()
    }
    
    func convertDateFormatterString(date: String,toFormatterString:String,fromFromattedString:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFromattedString //"yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateString = dateFormatter.date(from: date)
        dateFormatter.dateFormat = toFormatterString
        let timeStamp = dateFormatter.string(from: dateString ?? Date())
        return timeStamp
    }
    func aPIDateFormat() -> String? {
        return "yyyy-MM-dd"
    }
    func datesRange(from: Date, to: Date) -> [Date] {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        if from > to { return [Date]() }
        
        var tempCalendar = Calendar(identifier: .gregorian)
        //tempCalendar.timeZone = TimeZone(secondsFromGMT: 0)!
        tempCalendar.timeZone = TimeZone.current
        var startDate = tempCalendar.startOfDay(for: from)
        let toDate = tempCalendar.startOfDay(for: to)
        
        
        var dates: [Date] = []
        while startDate <= toDate {
            dates.append(startDate)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate) else { break }
            startDate = newDate
        }
        return dates
    }
    
    func getDisplayDateFormat(dateFormat: String) -> String {
        if dateFormat == "dd/MM/yyyy" {
            return "dd MMM, yyyy"
        } else if dateFormat == "MM/dd/yyyy" {
            return "MMM dd, yyyy"
        } else if dateFormat == "yyyy/MM/dd" {
            return "yyyy, MMM dd"
        } else {
            return "dd MMM, yyyy"
        }
    }
    
    func getPreviousDateForTask(dateString:String, formatterString: String) -> String?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = formatterString
        dateFormatter.timeZone = TimeZone.current
        
        if let date =  dateFormatter.date(from: dateString),
            let preViousDate = Calendar.current.date(byAdding: self.prevDateComponents, to: date)
        {
            return dateFormatter.string(from: preViousDate)
        }
        return nil
    }
}

extension Date {
    func isInSameDay(as date: Date) -> Bool { isEqual(to: date, toGranularity: .day) }
    func isInSameMonth(as date: Date) -> Bool { isEqual(to: date, toGranularity: .month) }
    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }
    
  
    func totalDistance(from date: Date, resultIn component: Calendar.Component) -> Int? {
        return Calendar.current.dateComponents([component], from: self, to: date).value(for: component)
    }
    
    func hasSame(_ component: Calendar.Component, as date: Date) -> Bool {
        return (Calendar.current.component(.day, from: self)-Calendar.current.component(.day, from: date)) == 0 && (Calendar.current.component(.month, from: self)-Calendar.current.component(.month, from: date)) == 0 && (Calendar.current.component(.year, from: self)-Calendar.current.component(.year, from: date)) == 0
    }
    
    func startDateOfWeek(defaultCalendar: Calendar) -> Date{
        let sunday = defaultCalendar.date(from: defaultCalendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        return sunday
    }
    
    func endDateOfWeek(defaultCalendar: Calendar) -> Date{
        return defaultCalendar.date(byAdding: .day, value: 6, to: self.startDateOfWeek(defaultCalendar: defaultCalendar))!
    }
    
    var startOfWeek: Date? {
//        print("startOfWeek \()")
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    
    func startDateOfMonth(defaultCalendar: Calendar, byAddingMonth: Int = 0) -> Date {
        
        let startDateOfMonth = defaultCalendar.date(from: defaultCalendar.dateComponents([.year, .month], from: defaultCalendar.startOfDay(for: self)))!
        
        return defaultCalendar.date(byAdding: .month, value: byAddingMonth, to: startDateOfMonth)!
        
    }
    
    func endDateOfMonth(defaultCalendar: Calendar, byAddingMonth: Int = 0) -> Date {
        
        let endDateOfMonth = defaultCalendar.date(byAdding: DateComponents(month: 1, day: -1), to: self.startDateOfMonth(defaultCalendar: defaultCalendar, byAddingMonth: byAddingMonth))!
        
        return endDateOfMonth
    }
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
        
    }
    
    func startOfYear() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year], from: Calendar.current.startOfDay(for: self)))!
        
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    func getDateValue() -> String? {
        let userDateFormatArray = UserDefaults.standard.value(forKey: "DateFormat") as? [String]
        if let loggedInUserDateFormat = userDateFormatArray?.first {
            let days = Date().daysBetweenDates(startDate: self.toLocalTime(), endDate: Date().toLocalTime())
            var timeDifference = Date().secondsBetweenDates(startDate: self.toLocalTime(), endDate: Date().toLocalTime())
            timeDifference = abs(timeDifference)

            switch(days){
            case 0:
                if timeDifference < 60{
                    return "just Now"
                }
//                else if (timeDifference / 60) < 60 {
//                    return "\((timeDifference / 60)) mins ago"
               // }
            else if ((timeDifference / 60) / 60) < 24 {
                    let messageTime = DateHelper().convertDateFormatter(date: self, formatterString: "hh:mm a")
                    return messageTime
                }
            case 1:
                return "Yesterday"
            default:
                let dateString = DateHelper().convertDateFormatter(date: self, formatterString: loggedInUserDateFormat)
                return dateString
            }
        }
       
        return nil
    }
    
    func getDateValueForChat() -> String? {
        
  
        let userDateFormatArray = UserDefaults.standard.value(forKey: "DateFormat") as? [String]
        if let loggedInUserDateFormat = userDateFormatArray?.first {
            let days = Date().daysBetweenDates(startDate: self, endDate: Date().toLocalTime())
            
            switch(days){
            case 0:
                return "Today"
            case 1:
                return "Yesterday"
            default:
                let dateString = DateHelper().convertDateFormatter(date: self.toGlobalTime(), formatterString: loggedInUserDateFormat)
                return dateString
            }
        }
        
        return nil
    }
    
    // For pulse module
    func getDateFormatForPulseList(format: String?) -> String
    {
        let loggedInUserDateFormat = "dd MMM, yyyy"
        let days = Date().daysBetweenDates(startDate: self.toLocalTime(), endDate: Date().toLocalTime())
        var timeDifference = Date().secondsBetweenDates(startDate: self.toLocalTime(), endDate: Date().toLocalTime())
        timeDifference = abs(timeDifference)
        let dateString = DateHelper().convertDateFormatter(date: self, formatterString: loggedInUserDateFormat)
        return dateString
    }
    // For pulse module
    
    func daysBetweenDates(startDate: Date, endDate: Date) -> Int
    {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        if calendar.isDateInYesterday(startDate.toGlobalTime()) {
            return 1
        }
        if calendar.isDateInToday(startDate.toGlobalTime()) {
            return 0
        }
        let diffInDays = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day

        return 2 // for default date
    }
    
    func daysDifferenceBetweenDates(startDate: Date, endDate: Date) -> Int
    {
        
        let diffInDays = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 122222

        return diffInDays
    }
    
    func hourssBetweenDates(endDate: Date) -> Int {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.hour], from: self, to: endDate)
        return components.hour!
    }
    
    func minutessBetweenDates(endDate: Date) -> Int {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.minute], from: self, to: endDate)
        return components.minute!
    }
    
    func secondsBetweenDates(startDate: Date, endDate: Date) -> Int {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.second], from: startDate, to: endDate)
        return components.second ?? 0
    }
    
    
    func getLastDates(forLastNDays: Int) -> [String] {
            let cal = NSCalendar.current
            // start with today
            var date = cal.startOfDay(for: Date())

            var arrDates = [String]()

            for _ in 1 ... forLastNDays {
                // move back in time by one day:
                date = cal.date(byAdding: Calendar.Component.day, value: -1, to: date)!

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let dateString = dateFormatter.string(from: date)
                arrDates.append(dateString)
            }
            print(arrDates)
            return arrDates
    }
    
    func getNextDates(forNextNDays: Int) -> [String] {
            let cal = NSCalendar.current
            // start with today
            var date = cal.startOfDay(for: Date())

            var arrDates = [String]()

            for _ in 1 ... forNextNDays {
                // move back in time by one day:
                date = cal.date(byAdding: Calendar.Component.day, value: +1, to: date)!

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let dateString = dateFormatter.string(from: date)
                arrDates.append(dateString)
            }
            print(arrDates)
            return arrDates
    }
    
    func getNextMonth(dateString:String, formatterString: String) -> [String]? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = formatterString
        dateFormatter.timeZone = TimeZone.current
        
        var nextDateArr:[String] = []
        if let date =  dateFormatter.date(from: dateString){
            var comp: DateComponents = Calendar.current.dateComponents([.year, .month], from: date)
            comp.month = comp.month! + 1;
            comp.day = 1;
            let startOfMonth = Calendar.current.date(from: comp)!
            nextDateArr.append(dateFormatter.string(from: startOfMonth))
            
            var comps2 = DateComponents()
            comps2.month = 1
            comps2.day = -1
            let endOfMonth = Calendar.current.date(byAdding: comps2, to: startOfMonth)
            nextDateArr.append(dateFormatter.string(from: endOfMonth!))
            
            return nextDateArr
        }
        return nil
    }

    func getPreviousMonth(dateString:String, formatterString: String) -> [String]? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = formatterString
        dateFormatter.timeZone = TimeZone.current
        
        var previousDateArr:[String] = []
        if let date =  dateFormatter.date(from: dateString){
//            guard let preViousDate = Calendar.current.date(byAdding: .month, value: -1, to: date) else { return }

            var comp: DateComponents = Calendar.current.dateComponents([.year, .month], from: date)
//            let startOfMonth = Calendar.current.date(from: comp)!
//            previousDateArr.append(dateFormatter.string(from: startOfMonth))
            comp.month = comp.month! - 1;
            comp.day = 1;
            let startOfMonth = Calendar.current.date(from: comp)!
            previousDateArr.append(dateFormatter.string(from: startOfMonth))
            
            var comps2 = DateComponents()
            comps2.month = 1
            comps2.day = -1
            let endOfMonth = Calendar.current.date(byAdding: comps2, to: startOfMonth)
            previousDateArr.append(dateFormatter.string(from: endOfMonth!))
            
            return previousDateArr
        }
        return nil
    }
}
