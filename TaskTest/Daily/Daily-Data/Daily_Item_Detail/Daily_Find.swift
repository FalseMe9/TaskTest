//
//  Daily_Find.swift
//  TaskTest
//
//  Created by Billie H on 06/12/24.
//

import Foundation
extension DGroup{
    func find(_ name: String)-> DItem?{
        let date = mData.dateString
        if let item = self as? DItem,
            name.simpleHash() == item.name.simpleHash(){
            return item
        }
        else{
            let dates = Set(items.compactMap(\.dayAppeared)).sorted()
            for date in dates{
                for task in items(at: date){
                    if let temp = task.find(name){
                        return temp
                    }
                }
            }
        }
        return nil
    }
}
extension DailyData{
    func findAll(_ name : String)-> Sendable?{
        for category in mData.categories{
            if name.simpleHash() == category.id.simpleHash(){
                return category
            }
        }
        return find(name)
    }
    func get(by minute:Int, at date:String?, with category : Category)->[HTask]{
        var minute = minute
        var retTasks = [HTask]()
        for task in items(at: date, for: category){
            let temp = task.at(date).availableMinute
            retTasks += task.get(by: minute, at: date)
            minute -= temp
            if minute<=0{return retTasks}
        }
        return retTasks
    }
}
