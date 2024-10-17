//
//  Date.swift
//  test
//
//  Created by Billie H on 23/10/24.
//

import Foundation

extension Date{
    var month: Int{
        Calendar.current.component(.month, from: self)
    }
    var year: Int{
        Calendar.current.component(.year, from: self)
    }
    var time : MyTime{
        get{
            MyTime(date: self)
        }
    }
    static func create(day : String?, time : MyTime?)-> Date?{
        var component = DateComponents()
        guard let date = day?.date else{return nil}
        let time = time ?? MyTime()
        component.year = date.year
        component.month = date.month
        component.day = date.day
        component.hour = time.hour
        component.minute = time.minute
        return calendar.date(from: component)
    }
    func next(appear : Set<Int>)-> Date?{
        let num = dayNumberOfWeek()
        let arr = appear.sorted()
        var res : Int
        if let n = arr.first(where: {$0>num}){
            res = n - num
        } else if let n = arr.first{
            res = n + 7 - num
        } else {return nil}
        return add(day: res)
    }
}

extension String{
    static var currentDate : String{
        Date.now.string
    }
}
