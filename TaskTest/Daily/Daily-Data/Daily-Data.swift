//
//  DailyData.swift
//  TaskManager2
//
//  Created by Billie H on 16/09/24.
//

import Foundation
import SwiftUI
import Firebase

@Observable
class DailyData:DGroup, Identifiable{
    var idList = [String]()
    var items = [DItem](){
        didSet{
            idList = items.map({$0.id})
            upload()
        }
    }
    var path : DocumentReference{
        db.collection(DailyData.type).document(id)
    }
    var dateItem = [String(mData.index) : 0]
    var appears : Set = [mData.index]
    var avoidLoop = true
    var id = "Daily"
    static var type = "Data"
    var isEditing = false
    
    var showSheet = false
    var showAlert = false
    var input : Int?
    var action = {}
    var content : AnyHashable?
    var detail : DItem?
    var category : Category?
    
    enum CodingKeys:String, CodingKey{
        case _idList = "items"
    }
    init(){
        observe()
    }
    func set(){
        let path = "DailyDefaults"
        ref.child(path).setValue(dicts)
    }
    func load(){
        let path = "DailyDefaults"
        ref.child(path).observeSingleEvent(of: .value){ [self]snapshot in
            for item in items{item.remove()}
            dicts = snapshot.value as? Array<Dictionary<String, Any?>> ?? dicts
        }
    }
    
    func sync(data: DailyData) {
        items = data.idList.map{get(id: $0)}
    }    
}



let coder2 = JSONEncoder()
