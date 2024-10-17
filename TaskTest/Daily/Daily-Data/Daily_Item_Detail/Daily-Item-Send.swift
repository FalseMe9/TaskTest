//
//  DTaskSend.swift
//  TaskManager2
//
//  Created by Billie H on 17/09/24.
//

import Foundation
import SwiftUI
extension DItem:Sendable{
    func remove(){
        withAnimation{
            group.items.remove(at: index)
            for item in self.items {
                item.remove()
            }
            path.delete()
        }
    }
    func minus(_ minute : Int, at day : String? = "nil"){
        guard let day = (day == "nil") ? dayAppeared : day
        else{return}
        at(day).availableMinute -= minute
        if let group = group as? DItem{
            group.minus(minute, at: day)
        }
    }
    
    func get(by minute:Int, at date:String?)->[HTask]{
        var minute = minute
        var retTasks = [HTask]()
        let item = at(date)
        for task in items(at: date){
            let temp = task.at(date).availableMinute
            retTasks += task.get(by: minute, at: date)
            minute -= temp
            if minute<=0{return retTasks}
        }
        if item.availableMinute > minute{
            retTasks.append(HTask(name: name, time: minute*60))
            minus(minute, at: date)
        }
        else{
            if item.availableTime>0{
                retTasks.append(HTask(name: name, time:item.availableTime))
            }
            minus(item.availableMinute, at: date)
        }
        return retTasks
    }
    func send(minute:Int? = nil, at date: String?){
        hourly.items += get(by: minute ?? availableMinute, at: date)
    }
}
extension Category:Sendable{
    func get(by minute:Int, at date:String?)->[HTask]{
        var minute = minute
        var retTasks = [HTask]()
        for task in daily.items(at: date, for: self){
            let temp = task.at(date).availableMinute
            retTasks += task.get(by: minute, at: date)
            minute -= temp
            if minute<=0{return retTasks}
        }
        return retTasks
    }
    var dayAppeared : String?{
        daily.items(for: self).compactMap(\.dayAppeared).min()
    }
}
protocol Sendable{
    func get(by minute:Int, at date: String?)->[HTask]
    var dayAppeared : String? {get}
}
