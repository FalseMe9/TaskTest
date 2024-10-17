//
//  DailyTask.swift
//  MultiTaskManager
//
//  Created by Billie H on 13/09/24.
//

import Foundation
import SwiftUI
import Firebase
let defaults = UserDefaults.standard

@Observable
class DItem: DGroup, Identifiable, Equatable, Hashable, PText, Categorized{
    
    typealias D = any DGroup
    var idList = [String]()
    var items = [DItem](){
        didSet{
            idList = items.map({$0.id})
            upload()
        }
    }
    var appears : Set<Int> = [] {didSet{upload()}}
    var group: D = daily
    var path : DocumentReference{
        group.path.collection(DItem.type).document(id)
    }
    
    var usedMinutes = [String: Int]()
    var customMinute = [Int:Int]()
    var defaultMinute = 0
    
    static var type: String = "DTask"
    var id = UUID().uuidString
    var avoidLoop = true
    var avoidLoop1 = true
    var name : String = "" {didSet{uploadName()}}
    
    // Boolean
    var isClicked = false
    var isVisible = false
    
    // Filter
    var timeStarted : MyTime?
    var dayStarted : String?
    var dateFinished : Date?
    var description : String{
        get{hourly.detail.dictionary[name.trim()] ?? ""}
        set{hourly.detail.update(key: name, value: newValue)}
    }
    required init(id: String? = nil, group: D) {
        self.group = group
        if let id {
            self.id = id
        }else{upload()}
        observe()
    }
    init(group: D,
         dayStarted : String?) {
        self.group = group
        self.dayStarted = dayStarted
        upload()
        observe()
        
    }
    enum CodingKeys: String, CodingKey {
        case _name = "name"
        case _idList = "idList"
        case _appears = "appears"
        case _customMinute = "customTime"
        case _defaultMinute = "time"
        case _dayStarted = "dayStarted"
        case _timeStarted = "timeStarted"
        case _dateFinished = "dateFinished"
        case _usedMinutes = "dateItem"
    }
    func sync(data:DItem){
        if !data.name.isEmpty{name = data.name}
        items = data.idList.map({get(id: $0)})
        appears = data.appears
        customMinute = data.customMinute
        defaultMinute = data.defaultMinute
        
        timeStarted = data.timeStarted
        dateFinished = data.dateFinished
        usedMinutes = data.usedMinutes.filter{validDate(key: $0.key)}
        while let temp = data.dayStarted,
                temp <= mData.currentDate.add(day: -3).string
        {
            data.dayStarted = temp.date?.next(appear: appears)?.string
        }
        dayStarted = data.dayStarted
    }
    var dict:[String:Any?]{
        get{
            ["name" : name,
             "tasks" : dicts,
             "appears" : Array(appears),
             "customTime" :customMinute,
             "time" : defaultMinute,
             "dayStarted" : dayAppeared,
             "timeStarted" : timeStarted?.time,
             "dateFinished" : dateFinished?.string,
             "dateItem" : usedMinutes,
            ]
        }
        set{
            name = newValue["name"] as? String ?? name
            dicts = newValue["tasks"] as? [[String : Any?]] ?? dicts
            if let temp = newValue["appears"] as? [Int]{
                appears = Set(temp)
            }
            
            customMinute = newValue["customTime"] as? [Int:Int] ?? customMinute
            defaultMinute = newValue["time"] as? Int ?? defaultMinute
            dayStarted = newValue["dayStarted"] as? String
            
            if let time = newValue["timeStarted"] as? Int{
                timeStarted = MyTime(minute: time)
            }
            dateFinished = (newValue["dateFinished"] as? String)?.date
            
            usedMinutes = newValue["dateItem"] as? [String:Int] ?? usedMinutes
            
        }
    }
    
    static func ==(lhs: DItem, rhs: DItem) -> Bool {
        return lhs.id == rhs.id
    }
    func at(_ date : String? = "nil")->DSubItem{
        if date == "nil"{
            DSubItem(item: self, date: dayAppeared)
        }
        else{DSubItem(item: self, date: date)}
    }
    
}

extension [[String:Any?]]{
    func convert(group: any DGroup)->[DItem]{
        var ret = [DItem]()
        for item in self{
            let task = DItem(group: group)
            task.AvoidLoop{
                task.dict = item
            }
            task.upload()
            ret.append(task)
        }
        return ret
    }
}

protocol Categorized:AnyObject{
    var name : String {get set}
}
extension Categorized{
    var categoryName : String{
        get{mData.categoryDict.get(key: name) ?? "Home"}
        set{mData.categoryDict.update(key: name, value: newValue)}
    }
    var category : Category{
        get{categoryName.toCategory}
        set{categoryName = newValue.id}
    }
}
