//
//  Daily-SubItem.swift
//  TaskTest
//
//  Created by Billie H on 16/11/24.
//

import Foundation
import SwiftUI
@Observable
class DSubItem{
    let item : DItem
    var dateString : String?
    var date : Date?{
        get{dateString?.date}
        set{dateString = newValue?.string}
    }
    init(item: DItem, date: String? = nil) {
        self.item = item
        self.dateString = date
    }
    var minute : Int{
        get{
            guard let num = date?.dayNumberOfWeek() else{return item.defaultMinute}
            return item.customMinute[num] ?? item.defaultMinute
        }
        set{
            guard let num = date?.dayNumberOfWeek() else{
                item.defaultMinute = newValue;
                return
            }
            item.customMinute[num] = newValue
        }
    }
    var time : Int{
        get{minute * 60}
        set{minute = newValue/60}
    }
    var availableTime : Int {
        get{availableMinute * 60}
        set{availableMinute = newValue / 60}
    }
    var availableMinute : Int{
        get{
            if dateString == nil || item.dayStarted == nil {item.defaultMinute}
            else{minute - usedMinute}
        }
        set{
            item.AvoidLoop{
                if dateString == nil || item.dayStarted == nil{
                    item.defaultMinute = newValue
                }
                else{
                    usedMinute = minute - newValue
                }
            }
            item.upload()
        }
    }
    var usedMinute : Int{
        get{
            guard let str = dateString else{return 0}
            return item.usedMinutes[str] ?? 0
        }
        set{
            guard let str = dateString else{return}
            item.usedMinutes[str] = newValue
            item.upload()
        }
    }
    var isFinished : Bool{
        get{availableTime <= 0 && time > 0}
        set{
            let time = newValue ? availableMinute : -usedMinute
            item.minus(time, at: dateString)
        }
    }
}


