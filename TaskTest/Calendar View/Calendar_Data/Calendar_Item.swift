//
//  Item.swift
//  test
//
//  Created by Billie H on 22/10/24.
//

import Foundation
import Firebase
@Observable
class Calendar_Item:Hashable, Identifiable, PItem, Categorized{
    var time: Int = 0
    required init(id: String? = nil, group: Calendar_Data) {
        if let id{
            self.id = id
        }
        observe()
    }
    
    var avoidLoop = true
    static var type = "Item"
    var path : DocumentReference{
        cData.path.collection(Calendar_Item.type).document(id)
    }
    var group : Calendar_Data = cData
    var id = UUID().uuidString
    var name = ""
    var minute = 60 {didSet{upload()}}
    var description = ""
    var completions : Set<String>?  = [] {didSet{upload()}}
    var disappearAt : Set<String>? = [] {didSet{upload()}}
    //time
    var timeStarted : MyTime = MyTime() {didSet{upload()}}
    var timeFinished : MyTime {get{timeStarted + MyTime(minute: minute)}}
    var dateStarted : Date = Date.now {didSet{upload()}}
    var dateFinished : Date?
    
    
    var isEditing = false
    var repeatAt : Set<Int> = [mData.index]
    
    var week : Int?
    init(dateStarted : Date = mData.currentDate){
        self.dateStarted = dateStarted
        observe()
    }
    enum CodingKeys: String, CodingKey {
        case _name = "name"
        case _minute = "minute"
        case _description = "description"
        case _completions = "completion"
        case _disappearAt = "disappearAt"
        case _timeStarted = "timeStarted"
        case _dateStarted = "dateStarted"
        case _dateFinished = "dateFinished"
        case _repeatAt = "repeatAt"
        case _week = "week"
    }
    func sync(data:Calendar_Item){
        name = data.name
        minute = data.minute
        description = data.description
        completions = data.completions?.filter(dateFilter)
        disappearAt = data.disappearAt?.filter(dateFilter)
        timeStarted = data.timeStarted
        dateStarted = data.dateStarted
        dateFinished = data.dateFinished
        repeatAt = data.repeatAt
        week = data.week
    }
    static func < (lhs: Calendar_Item, rhs: Calendar_Item) -> Bool {
        lhs.timeStarted < rhs.timeStarted
    }
    static func > (lhs: Calendar_Item, rhs: Calendar_Item) -> Bool {
        lhs.timeStarted > rhs.timeStarted
    }
    static var example :Calendar_Item{
        Calendar_Item()
    }
    func disappear(at date : String?)-> Bool{
        guard let date else{return false}
        return disappearAt?.contains(date) ?? false
    }
    func remove(from date : String?){
        guard let date else{return}
        disappearAt = disappearAt ?? []
        disappearAt?.insert(date)
    }
    func completed(at date: String?)->Bool{
        guard let date else{return false}
        return completions?.contains(date) ?? false
    }
    func complete(for date : String?){
        guard let date else{return}
        completions = completions ?? []
        completions?.insert(date)
    }
    func uncomplete(for date : String?){
        guard let date else{return}
        completions?.remove(date)
    }
}
