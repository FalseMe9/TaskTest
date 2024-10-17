//
//  HourlyDataSource.swift
//  TaskManager2
//
//  Created by Billie H on 16/09/24.
//

import Foundation
import Firebase
import SwiftUI

@Observable
class HourlyData: PGroup{
    var path : DocumentReference{
        db.collection(HourlyData.type).document(id)
    }
    var allowNextDate = false
    var askDate = false
    var temp = ([HTask](), index : Int())
    var completion = [()->()]()
    var avoidLoop = true
    var timer = Timer()
    
    
    var isFirstView = false
    var showTime = false
    var showIncomplete = false
    var filter = false
    var addNext = false
    var shortcutItem : HTask?
    var alternativeItem : HTask?
    var alert2 = false
    
    var totalTime : Int{
        items.map{$0.time}.reduce(0, +)
    }
    var finishTime : Date{
        Date.now.addingTimeInterval(TimeInterval(totalTime))
    }
    var source = ["Memo!"] {didSet{upload()}}
    var currentTask : HTask?{
        willSet{currentTask?.upload()}
    }
    var nPath = NavigationPath()
    var showAlert = false
    var selectedItem : HTask?
    var items = [HTask](){
        didSet{
            idList = items.map({$0.id})
            refresh()
            upload()
        }
    }
    
    var idList = [String]()
    var isShuffling = true
    var isPlaying = false {
        didSet{
            timer.invalidate()
            if isPlaying{
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){[self] _ in
                    if let currentTask{
                        currentTask.time -= 1
                        if currentTask.time <= 0{
                            currentTask.delete()
                            if !isShuffling{
                                isPlaying = false
                            }
                        }
                    }
                    else{
                        isPlaying = false
                    }
                }
            }
        }
    }
    var detail = CustomDictionary(name: "Description")
    var shortcut = CustomDictionary(name: "Shortcut")
    var alternative = CustomDictionary(name: "Alternative")
    init(){
        observe()
    }
    func saveDescription(from filename:String = "Hourly"){
        detail.save()
        shortcut.save()
        alternative.save()
    }
    
    var switchIndex = 0
    var switchName : String{
        switch switchIndex{
        case 0:
            currentTask?.name ?? "Misc"
        case 1:
            source.first ?? "Misc"
        default:
            currentTask?.alternative ?? "Misc"
        }
    }
    var description : String{
        get{
            detail.dictionary[switchName] ?? ""
        }
        set{
            detail.update(key: switchName, value: newValue)
        }
    }
    
    static var type = "Data"
    var id = "Hourly"
    enum CodingKeys:String, CodingKey{
        case _idList = "idList"
        case _source = "source"
        case _showTime = "showTime"
        case _showIncomplete = "showIncomplete"
    }
    func sync(data:HourlyData){
        items = data.idList.map({get(id: $0)})
        showTime = data.showTime
        showIncomplete = data.showIncomplete
        source = data.source
        if currentTask?.index ?? -1 < 0{
            currentTask = items.first
        }
    }
    func send(with command:String, at index : Int? = nil){
        var command = command
        if command.first == "*" {
            command.removeFirst()
            if let currentTask{
                currentTask.replace(command: command)
                return
            }
        }
        if command.first == "@" {
            command.removeFirst()
            currentTask?.insert(with: command)
            return
        }
        let tasks = command.toTasks()
        var now = true
        for task in tasks{
            let tempTask = get(task: task)
            now = now && tempTask.1
            completion.append{ [self] in
                temp.0 += tempTask.0
            }
        }
        if now{
            for task in completion{task()}
            items.insert(contentsOf: temp.0, at: index ?? items.count)
            if let index{
                hourly.currentTask = hourly.items[index]}
            cancel()
        }
        else{
            temp.index = index ?? items.count
            askDate = true
        }
    }
    func get(task:HTask)->([HTask], now :Bool){
        let date = mData.dateString
        guard let group = daily.findAll(task.name),
              let groupDate = group.dayAppeared
        else{
            return ([task],true)
        }
        if date >= groupDate || allowNextDate{
            task.path.delete()
            return (group.get(by: task.minute, at: date), true)
        }
        func get() {
            temp.0 += group.get(by: task.minute, at: groupDate)
        }
        completion.append(get)
        return ([], false)
    }
    func allow(){
        for task in completion{task()}
        items.insert(contentsOf: temp.0, at: temp.index)
        hourly.currentTask = hourly.items[temp.index]
        cancel()
    }
    func cancel(){
        completion.removeAll()
        temp.0.removeAll()
    }
}
