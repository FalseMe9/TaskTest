//
//  Date&Time.swift
//  test
//
//  Created by Billie H on 22/10/24.
//

import Foundation
struct MyTime : Equatable, Codable{
    var minute : Int{
        didSet{
            while minute<0{hour -= 1; minute += 60}
            while minute>=60{hour += 1; minute -= 60}
        }
    }
    var hour : Int
    init(date : Date) {
        let component = Calendar.current.dateComponents([.hour,.minute,.second], from: date)
        hour = component.hour ?? 0
        minute = component.minute ?? 0
    }
    init(minute: Int = 0, hour: Int = 0) {
        self.minute = minute % 60
        self.hour = hour + minute/60
    }
    var string : String{
        String(format : "%02d:%02d", hour, minute)
    }
    var date:Date{
        get{
            let component = DateComponents(hour: hour, minute: minute)
            return Calendar.current.date(from: component) ?? Date.now
        }
        set{
            let component = Calendar.current.dateComponents([.hour,.minute], from: newValue)
            hour = component.hour ?? 0
            minute = component.minute ?? 0
        }
    }
    var time : Int{
        get{hour*60 + minute}
        set{minute += (newValue - time)}
    }
    static var now:MyTime{
        MyTime(date: Date.now)
    }
    static func +(rhs:MyTime, lhs:MyTime)->MyTime{
        MyTime(
            minute: rhs.minute + lhs.minute,
            hour : rhs.hour + lhs.hour
        )
    }
    static func ==(lhs:MyTime,rhs:MyTime)->Bool{
        rhs.minute == rhs.minute &&
        rhs.hour == lhs.hour
    }
    static func < (lhs: MyTime, rhs: MyTime) -> Bool {
        lhs.time < rhs.time
    }
    static func > (lhs: MyTime, rhs: MyTime) -> Bool {
        lhs.time > rhs.time
    }
    
}

