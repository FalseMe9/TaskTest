import Foundation

class Notes : Hashable, PText{
    static func == (lhs: Notes, rhs: Notes) -> Bool {
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
    var description:String{
        get{notes.descriptions[id] ?? ""}
        set{
            notes.descriptions[id] = newValue
//            uploadD()
        }
    }
    init(id: String = UUID().uuidString) {
        self.id = id
    }
    func upName(){
        AvoidLoop2{
            ref2.child("Names").child(id).setValue(name)
        }
    }
    func uploadD(){
        AvoidLoop2{
            ref2.child("Descriptions").child(id).setValue(description)
        }
    }
    func clear(){
        ref2.child("Names").child(id).removeValue()
        ref2.child("Descriptions").child(id).removeValue()
    }
}
