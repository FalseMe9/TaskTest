//
//  Sync.swift
//  TaskManager2
//
//  Created by Billie H on 08/10/24.
//

import Foundation
import Firebase
protocol PSync:AnyObject, AvoidLoop, Codable{
    func sync(data : I)
    associatedtype I : PSync
    var id:String {get set}
    static var type : String{get}
    var path : DocumentReference {get}
}

extension PSync{
    func upload(){
        AvoidLoop{
            try? path.setData(from: self)
        }
    }
    func observe(completion : @escaping ()->() = {}){
        path.addSnapshotListener{ [self] snapshot,_  in
            guard let snapshot else{return}
            if let data = try? snapshot.data(as: I.self){
                AvoidLoop {
                    sync(data: data)
                }
                completion()
            }
        }
    }
}
