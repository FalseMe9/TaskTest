//
//  Calendar_Variables.swift
//  TaskTest
//
//  Created by Billie H on 30/10/24.
//

import Foundation
extension Calendar_Item{
    var isFinished : Bool{
        get{dateFinished != nil}
        set{
            if isFinished != newValue{
                dateFinished = newValue ? dateStarted : nil
            }
        }
    }
    var completed : Bool{
        get{
            completed(at: mData.dateString)
        }
        set{
            let date = mData.dateString
            newValue ? complete(for: date) : uncomplete(for: date)
        }
    }
}
