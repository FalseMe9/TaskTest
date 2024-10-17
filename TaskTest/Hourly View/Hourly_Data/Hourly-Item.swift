//
//  HTask.swift
//  MultiTaskManager
//
//  Created by Billie H on 13/09/24.
//

import Foundation
import Firebase
@Observable
class HTask : Hashable, PItem, Categorized{
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    var path : DocumentReference{
        hourly.path.collection(HTask.type).document(id)
    }
    var id = UUID().uuidString
    var name : String = "" {didSet{upload()}}
    var group : HourlyData = hourly
    static var type = "HTask"
    var time : Int = 0 {
        didSet{if(time % 60 == 0) || (oldValue - time >= 60) {upload()}}
    }
    var description : String{
        get{hourly.detail.dictionary[name.trim()] ?? ""}
        set{
            hourly.detail.update(key: name, value: newValue)
        }
    }
    var isPlaying : Bool{
        get{self == hourly.currentTask && hourly.isPlaying}
        set{
            if newValue{
                hourly.currentTask = self
            }
            hourly.isPlaying = newValue
        }
    }
    var alternative :String{
        get{
            hourly.alternative.dictionary[name.trim()] ?? ""
        }
        set{hourly.alternative.update(key: name, value: newValue)}
    }
    init(name: String = "", time: Int? = nil, minute:Int? = nil) {
        AvoidLoop {
            self.name = name
            self.time = time ?? (minute ?? 0)*60
        }
        upload()
        observe()
    }
    required init(id:String?, group : HourlyData = hourly){
        self.id = id ?? self.id
        observe()
    }
    enum CodingKeys:String, CodingKey{
        case _name = "name"
        case _time = "time"
    }
    func delete(){
        let index = self.index
        remove()
        if self == hourly.currentTask{
            if index < hourly.items.count{
                hourly.currentTask = hourly.items[index]
            }
            else{hourly.currentTask = hourly.items.first}
            
            let time = hourly.addNext ? time : 0
            hourly.currentTask?.time += time
            
            if hourly.isPlaying{
                if hourly.isShuffling{
                    talk(str: hourly.currentTask?.name ?? "Finished")
                }
                else{
                    isPlaying = false
                    talk(str: "Finished")
                }
            }
        }
    }
    func sync(data:HTask){
        name = data.name
        time = data.time
    }
    var avoidLoop = true
}



extension [HTask]{
    var totalTime:Int{self.map({$0.time}).reduce(0, +)}
}

func AvoidLoop2(f : ()->()){
    if avoidLoop2{
        avoidLoop2 = false
        f()
        avoidLoop2 = true
    }
}
var avoidLoop2 = true
