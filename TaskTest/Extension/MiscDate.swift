//
//  MiscDate.swift
//  MultiTaskManager
//
//  Created by Billie H on 14/09/24.
//

var calendar = Calendar.current
import Foundation
extension Date {
    var num:Int{
        let component = calendar.dateComponents([.hour, .minute], from: self)
        return (component.hour ?? 0)*60 + (component.minute ?? 0)
    }
    var day : Int{
        calendar.dateComponents([.day], from: self).day ?? -1
    }
    func dayNumberOfWeek() -> Int {
        (Calendar.current.dateComponents([.weekday], from: self).weekday ?? 0) - 1
    }
    func addTime(_ time:Int)->Date{
        self.addingTimeInterval(TimeInterval(time))
    }
    func add(day : Int)->Date{
        self.addingTimeInterval(TimeInterval(day * 86400))
    }
    mutating func addDay(_ day:Int){
        self.addTimeInterval(TimeInterval(day * 86400))
    }
    static func getTime(hour:Int = 0,
                 minute : Int = 0,
                 second:Int = 0)->Date?
    {
        var component = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        component.hour = hour
        component.minute = minute
        guard let retdate = calendar.date(from: component) else{return nil}
        return retdate
    }
    var string:String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    static func - (lhs: Date, rhs: Date) -> Int {
        Calendar.current.dateComponents([.day], from: rhs, to: lhs).day ?? 0
    }
    var hhmm : String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
    var tomorrow:Date{
        self.add(day: 1)
    }
    var yesterday:Date{
        self.add(day: -1)
    }
    var weekend:Date{
        let day = (7-dayNumberOfWeek())%7
        return self.add(day: day)
    }
}
extension String{
    var date:Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self)
    }
}
