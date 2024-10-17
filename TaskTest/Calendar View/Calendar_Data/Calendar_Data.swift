//
//  Data.swift
//  test
//
//  Created by Billie H on 22/10/24.
//

import Foundation
import SwiftUI
import Firebase
@Observable
class Calendar_Data: PGroup{
    var avoidLoop = true
    static var type = "Data"
    var id = "Calendar"
    var path : DocumentReference{
        db.collection(Calendar_Data.type).document(id)
    }
    var items = [Calendar_Item](){
        didSet{idList = items.map{$0.id}
            upload()}
    }
    var idList = [String]()
    var uncompletedItems : [Calendar_Item]{
        items.filter{
            $0.appear(at: mData.dateString) &&
            !$0.completed &&
            $0.timeFinished < MyTime.now
        }
    }
    var nPath = NavigationPath()
    var isEditing:Bool{
        get{items.contains{$0.isEditing}}
        set{if !newValue{for item in items{item.isEditing = false}}}
    }
    init() {
        observe()
    }
    
    enum CodingKeys: String,CodingKey {
        case _idList = "idList"
    }
    func sync(data: Calendar_Data){
        items = data.idList.map{get(id: $0)}
    }
    func currentItem(at date : Date)->(now :Calendar_Item?,next: Calendar_Item?){
        var now : Calendar_Item?
        var next : Calendar_Item?
        let temp = items.filter{
            $0.appear(at: date.string) &&
            $0.timeFinished > MyTime.now
        }.sorted(by: <)
        if !temp.isEmpty{
            let item = temp[0]
            if item.timeStarted > MyTime.now{
                next = temp[0]
            }
            else{
                now = item
                if 1 < temp.count{
                    next = temp[1]
                }
            }
        }
        return (now, next)
    }
}
