//
//  File.swift
//  TaskTest
//
//  Created by Billie H on 03/12/24.
//

import Foundation
extension DItem {
    var dayStarted_Raw : Date?{
        get{dayStarted?.date}
        set{dayStarted = newValue?.string}
    }
    var timeStarted_Raw : Date?{
        get{timeStarted?.date}
        set{timeStarted = newValue?.time}
    }
    var dayAppeared : String? {
        var day = dayStarted_Raw
        while day != nil, at(day?.string).isFinished{
            day = day?.next(appear: appears)
        }
        return day?.string
    }
    func removeDate(_ num: Int) {
        appears.remove(num)
        for item in items{item.removeDate(num)}
    }
    func insertDate(_ num: Int) {
        appears.insert(num)
        for item in items{item.insertDate(num)}
    }
    func validDate(key : String)->Bool{
        if let date = key.date, mData.currentDate - date <= 3{
            true
        }
        else{
            false
        }
    }
    
    var availableTime : Int{
        get{at().availableTime}
        set{at().availableTime = newValue}
    }
    var availableMinute : Int{
        get{at().availableMinute}
        set{at().availableMinute = newValue}
    }
    var usedMinute : Int{
        get{at().usedMinute}
        set{at().usedMinute = newValue}
    }
    
    
}
