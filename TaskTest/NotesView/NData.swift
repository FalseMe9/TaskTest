
import SwiftUI
import FirebaseDatabaseInternal

var notes = NData()

@Observable
class NData{
    var descriptions = [String:String]()
    var names = [String:String]()
    var notes = [String:[String]]()
    var folders = [String:[String]]()
    var startFolder = Folder(id: "Notes")
    var nPath = NavigationPath()
    init(){
        load()
        observe()
    }
    let ref2 = ref.child("Notes")
    func save(){
        defaults.setValue(descriptions, forKey: "Notes/Descriptions")
        defaults.setValue(names, forKey: "Notes/Names")
        defaults.setValue(notes, forKey: "Notes/Notes")
        defaults.setValue(folders, forKey: "Notes/Folders")
    }
    func load(){
        descriptions = defaults.dictionary(forKey: "Notes/Descriptions") as? [String:String] ?? descriptions
        names = defaults.dictionary(forKey: "Notes/Names") as? [String:String] ?? names
        notes = defaults.dictionary(forKey: "Notes/Notes") as? [String:[String]] ?? notes
        folders = defaults.dictionary(forKey: "Notes/Folders") as? [String:[String]] ?? folders
    }
    
    func observe(){
        ref2.child("Descriptions").observeSingleEvent(of: .value){ [self]snapshot in
            if let data = try? snapshot.data(as: [String:String].self){
                descriptions = data
            }
        }
        ref2.child("Descriptions").observe(.childAdded){snapshot in
            sync(snapshot: snapshot)
        }
        ref2.child("Descriptions").observe(.childChanged){snapshot in
            sync(snapshot: snapshot)
        }
        ref2.child("Descriptions").observe(.childRemoved){snapshot in
            self.descriptions[snapshot.key] = nil
        }
        func sync(snapshot:DataSnapshot){
            if let data = try? snapshot.data(as: String.self){
                AvoidLoop2{
                    descriptions[snapshot.key] = data
                }
            }
        }
        
        // Names
        ref2.child("Names").observeSingleEvent(of: .value){ [self]snapshot in
            if let data = try? snapshot.data(as: [String:String].self){
                names = data
            }
        }
        ref2.child("Names").observe(.childAdded){snapshot in
            sync2(snapshot: snapshot)
        }
        ref2.child("Names").observe(.childChanged){snapshot in
            sync2(snapshot: snapshot)
        }
        ref2.child("Names").observe(.childRemoved){snapshot in
            self.names[snapshot.key] = nil
        }
        func sync2(snapshot:DataSnapshot){
            if let data = try? snapshot.data(as: String.self){
                AvoidLoop2{
                    names[snapshot.key] = data
                }
            }
        }
        // Notes
        ref2.child("Notes").observeSingleEvent(of: .value){ [self]snapshot in
            if let data = try? snapshot.data(as: [String:[String]].self){
                notes = data
            }
        }
        ref2.child("Notes").observe(.childAdded){snapshot in
            sync3(snapshot: snapshot)
        }
        ref2.child("Notes").observe(.childChanged){snapshot in
            sync3(snapshot: snapshot)
        }
        ref2.child("Notes").observe(.childRemoved){snapshot in
            self.notes[snapshot.key] = nil
        }
        func sync3(snapshot:DataSnapshot){
            if let data = try? snapshot.data(as: [String].self){
                AvoidLoop2{
                    notes[snapshot.key] = data
                }
            }
        }
        // Folders
        ref2.child("Folders").observeSingleEvent(of: .value){ [self]snapshot in
            if let data = try? snapshot.data(as: [String:[String]].self){
                folders = data
            }
        }
        ref2.child("Folders").observe(.childAdded){snapshot in
            sync4(snapshot: snapshot)
        }
        ref2.child("Folders").observe(.childChanged){snapshot in
            sync4(snapshot: snapshot)
        }
        ref2.child("Folders").observe(.childRemoved){snapshot in
            self.folders[snapshot.key] = nil
        }
        func sync4(snapshot:DataSnapshot){
            if let data = try? snapshot.data(as: [String].self){
                AvoidLoop2{
                    folders[snapshot.key] = data
                }
            }
        }
    }
}
