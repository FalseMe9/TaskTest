//
//  Calendar_Functions.swift
//  TaskTest
//
//  Created by Billie H on 30/10/24.
//

import Foundation
extension Calendar_Item {
    func dateFilter(str : String)->Bool{
        if let date = str.date,
           mData.currentDate - date <= 3{
            true
        }
        else{false}
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    func send(){
        hourly.send(with: description)
        complete()
    }
    func complete(){
        completed = true
    }
    func uncomplete(){
        completed = false
    }
    func appear(at date : String?)->Bool{
        guard let date else {return true}
        var isStarted : Bool{
            date >= dateStarted.string
        }
        var isUnfinished : Bool{
            if let str = dateFinished?.string {date < str} else{true}
        }
        var onCorrectWeek : Bool{
            if let date = date.date, let week{
                (date - dateStarted)/7 % 2 == week
            } else{true}
        }
        var onCorrectDay : Bool{
            guard let date = date.date else {return true}
            return repeatAt.contains(date.dayNumberOfWeek())
        }
        var notRemoved : Bool{
            !disappear(at: date)
        }
        return isStarted && isUnfinished && onCorrectWeek && onCorrectDay && notRemoved
    }
}
