//
//  Hourly_Item_Insert.swift
//  TaskTest
//
//  Created by Billie H on 02/11/24.
//

import Foundation
extension HTask{
    var shortcut : String{
        hourly.shortcut.dictionary[name] ?? ""
    }
    func replaceAll(){
        replace(command: shortcut)
    }
    func replace(command : String ){
        let tasks = command.toTasks()
        let index = index
        time -= tasks.totalTime
        hourly.items.insert(contentsOf: tasks, at: index)
        if self == hourly.currentTask{
            hourly.currentTask = hourly.items[index]
        }
        if time <= 0{delete()}
    }
    func insert(with command : String){
        let index = index
        hourly.send(with: command, at: index)
    }
}
