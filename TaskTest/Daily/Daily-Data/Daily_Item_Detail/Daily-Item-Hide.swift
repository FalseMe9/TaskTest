//
//  Daily-Misc.swift
//  TaskManager
//
//  Created by Billie H on 18/10/24.
//

import Foundation
extension DItem{
    func syncDay(date : String? = nil){
        for item in items(at: date){
            item.dayStarted = dayStarted
            item.syncDay(date: date)
        }
        upload()
    }
    func syncCategory(){
        for item in items{
            item.categoryName = categoryName
            item.syncCategory()
        }
    }
    var showingDate : String?{
        if daily.isEditing{
            let now = mData.currentDate
            let num = now.dayNumberOfWeek()
            if let dayStarted{
                if dayStarted == now.string{
                    return now.string
                }
                else if dayStarted < now.string,
                   appears.contains(num){
                    return now.string
                }
                else{return dayAppeared}
            }
            else{return dayAppeared}
                
        } else{return dayAppeared}
    }
    func show(at date : String? = nil,
              previous : Bool = false)->Bool{
        guard let date else{return true}
        guard let showingDate else{return false}
        if previous{return date >= showingDate}
        else{return date == showingDate}
    }
    func show(for category : Category? = nil)->Bool{
        guard let category else {return true}
        return category == self.category
    }
    func remainingMinute(at date : String? = nil)->Int{
        at(date).availableMinute -
        items(at: date).map{$0.at(date).availableMinute}.reduce(0, +)
    }
}
extension DGroup{
    func total(at date : String? = nil,
               for category : Category? = nil
    )->Int{
        items(at: date, for: category).map{$0.total(at: date) + 1}.reduce(0, +)
    }
    func items(at date : String? = nil,
               for category : Category? = nil,
               previous : Bool = false
    )->[DItem]{
        items.filter{$0.show(at: date, previous: previous)}.filter{$0.show(for: category)}
    }
    func totalTime(at date : String? = nil,
                   for category : Category? = nil,
                   previous : Bool = false
    )->Int{
        items(at: date,
              for: category,
              previous: previous)
            .map{$0.at(date).availableMinute}
            .reduce(0, +)
    }
    func empty(at date : String? = nil,
               for category : Category? = nil,
               previous: Bool = false
    )->Bool{
        items(at: date,
              for: category,
              previous: previous).isEmpty
    }
    var totalDate:Int{
        dateItem.map{$0.totalDate + 1}.reduce(0, +)
    }
    var dateItem:[DItem]{
        items.filter{$0.dayAppeared != nil}
    }
}

