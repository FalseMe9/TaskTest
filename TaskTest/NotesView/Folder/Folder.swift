//
//  Folder.swift
//  TaskManager2
//
//  Created by Billie H on 19/09/24.
//

import Foundation

@Observable
class Folder : Hashable{
    static func == (lhs: Folder, rhs: Folder) -> Bool {
        lhs.id == rhs.id
    }
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    var id = UUID().uuidString
    let ref2 = ref.child("Notes")
    var name : String{
        get{notes.names[id] ?? ""}
        set{
            notes.names[id] = newValue
            upName()
        }
    }
    var folderArr : [String]{
        get{notes.folders[id] ?? []}
        set{
            notes.folders[id] = newValue
            uploadF()
        }
    }
    var noteArr:[String]{
        get{notes.notes[id] ?? []}
        set{
            notes.notes[id] = newValue
            uploadN()
        }
    }
    init(id: String = UUID().uuidString){
        self.id = id
    }
    func upName(){
        AvoidLoop2{
            ref2.child("Names").child(id).setValue(name)
        }
    }
    func uploadF(){
        AvoidLoop2{
            ref2.child("Folders").child(id).setValue(folderArr)
        }
    }
    func uploadN(){
        AvoidLoop2{
            ref2.child("Notes").child(id).setValue(noteArr)
        }
    }
    func clear(){
        for folder in folderArr{Folder(id: folder).clear()}
        for note in noteArr{Notes(id: note).clear()}
        ref2.child("Names").child(id).removeValue()
        ref2.child("Folders").child(id).removeValue()
        ref2.child("Notes").child(id).removeValue()
    }
}
