//
//  Task.swift
//  TaskManager2
//
//  Created by Billie H on 02/10/24.
//
import Foundation
import SwiftUI
import FirebaseFirestore
protocol PItem:Identifiable, PSync,PText, Hashable, Equatable{
    associatedtype V : PGroup
    var time : Int{get set}
    var group : V {get set}
    init(id:String?, group:V)
}
extension PItem{
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    var index : Int{
        group.items.firstIndex(of: self as! Self.V.T ) ?? -1
    }
    var checkIndex : Bool{
        index > -1 && index < group.items.count
    }
    var minute : Int{
        get{time/60}
        set{if minute != newValue{time = newValue * 60}}
    }
    func uploadName(){
        AvoidLoop{
            if !name.isEmpty{
                path.setData(["name":name], merge: true)
            }
        }
    }
    func uploadTime(){
        upload()
    }
    func remove(){
        if checkIndex{
            withAnimation{
                group.items.remove(at: index)
                path.delete()
            }
        }
    }
}

