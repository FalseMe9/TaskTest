//
//  HourlyString.swift
//  TaskTest
//
//  Created by Billie H on 25/10/24.
//

import SwiftUI

extension String{
    func toTask()->HTask?{
        var arr = self.split(div: ":")
        if arr.count == 2{
            let name = arr[0].trim()
            let minute = arr[1].toInt()
            let task = HTask(name: name, minute: minute)
            return task
        }
        arr = self.split(div: "=")
        if arr.count == 2{
            let name = arr[0].trim()
            let time = arr[1].toInt()
            let task = HTask(name: name, time: time)
            return task
        }
        else{
            return nil
        }
    }
    func toTasks()->[HTask]{
        let str = self.trim()
        var retArr = [HTask]()
        var arr = str.split(div: "\n")
        if arr.count >= 2 {
            return arr.map({$0.toTasks()}).reduce([], +)
        }
        arr = str.split(div: " X ")
        if arr.count == 2{
            for _ in 0..<arr[1].toInt(){
                retArr += arr[0].toTasks()
            }
            return retArr
        }
        if str.first == "#"{
            var temp = self; temp.removeFirst()
            return hourly.shortcut.dictionary[temp]?.toTasks() ?? []
        }
        arr = str.split(div: ";")
        if arr.count >= 2 {
            return arr.map({$0.toTasks()}).reduce([], +)
        }
        
        if let task = toTask(){retArr.append(task)}
        return retArr
    }
    
}
