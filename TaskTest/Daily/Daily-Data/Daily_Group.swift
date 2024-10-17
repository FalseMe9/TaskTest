//
//  Daily_Group.swift
//  TaskTest
//
//  Created by Billie H on 02/11/24.
//

import Foundation
protocol DGroup : PSync{
    var idList : [String] {get set}
    var items : [DItem] {get set}
}
extension DGroup{
    var dicts:[[String:Any?]]{
        get{
            items.map{$0.dict}
        }
        set{
            items = newValue.convert(group: self)
        }
    }
    func get(id:String)->DItem{
        items.first(where: {$0.id == id}) ?? DItem(id: id, group: self)
    }
    
    
    func clearAll(){
        let path = path.collection(DItem.type)
        path.getDocuments { [self] snapshot, error in
            guard let snapshot, error == nil else{return}
            snapshot.documents.forEach { doc in
                let id = doc.documentID
                if !idList.contains(id){
                    path.document(id).delete()
                }
                for item in self.items {
                    item.clearAll()
                }
            }
        }
    }
}

extension Bool{
    static func >(lhs:Bool, rhs:Bool)-> Bool{
        lhs && !rhs
    }
}

