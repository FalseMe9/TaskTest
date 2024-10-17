//
//  CustomDictionary.swift
//  TaskTest
//
//  Created by Billie H on 16/11/24.
//

import SwiftUI
import Firebase

@Observable
class CustomDictionary: AvoidLoop{
    var avoidLoop: Bool = true
    var name : String
    var dictionary : [String:String]
    let reference : DatabaseReference
    let url : URL
    init(name: String) {
        self.name = name
        self.reference = ref.child(name)
        self.url = URL.documentsDirectory.appending(path: name)
        if let data = try? Data(contentsOf: url),
           let dictionary = try? JSONDecoder().decode([String:String].self, from: data)
        {self.dictionary = dictionary}
        else{
            self.dictionary = [:]
        }
        observe()
    }
    func save(){
        if let data = try? JSONEncoder().encode(dictionary){
            try? data.write(to: url)
        }
    }
    func observe(){
        reference.observeSingleEvent(of: .value){ [self]snapshot in
            guard let data = try? snapshot.data(as: [String:String].self) else{return}
            dictionary = data
        }
        reference.observe(.childChanged){snapshot in
            sync(snapshot: snapshot)
        }
        reference.observe(.childAdded){snapshot in
            sync(snapshot: snapshot)
        }
        reference.observe(.childRemoved){ [self]snapshot in
            dictionary[snapshot.key] = nil
        }
        func sync(snapshot:DataSnapshot){
            guard let data = try? snapshot.data(as: String.self) else{return}
            AvoidLoop{
                dictionary[snapshot.key] = data
            }
        }
    }
    func update(key : String, value : String){
        let key = key.isEmpty ? "nil" : key
        dictionary[key] = value
        AvoidLoop2{
            ref.child(name).child(key.trim()).setValue(value)
        }
    }
    func get(key:String)->String?{
        let key = key.isEmpty ? "nil" : key
        return dictionary[key]
    }
}

