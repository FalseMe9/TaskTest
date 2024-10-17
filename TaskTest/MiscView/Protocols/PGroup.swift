//
//  Group.swift
//  TaskManager2
//
//  Created by Billie H on 02/10/24.
//

import Foundation
import FirebaseFirestore
protocol PGroup : AnyObject, PSync{
    associatedtype T: PItem
    var items : [T] {get set}
    var idList : [String] {get set}
   
}
extension PGroup{
    func refresh(){
        for item in items{
            item.group = (self as? Self.T.V)!
        }
    }
    func removeItems(){
        for item in items{
            item.remove()
        }
    }
    func clearAll(){
        let path = path.collection(T.type)
        path.getDocuments { [self] snapshot, error in
            guard let snapshot, error == nil else{return}
            snapshot.documents.forEach { doc in
                if !idList.contains(doc.documentID){
                    path.document(doc.documentID).delete()
                }
            }
        }
    }
    func get(id:String)->T{
        items.first(where: {$0.id == id}) ?? T(id: id, group: (self as! Self.T.V))
    }
    
}
