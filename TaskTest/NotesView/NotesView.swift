
import SwiftUI

var path = PathStore()
struct NotesView:View{
    @State var data = notes
    var body: some View{
        NavigationStack(path: $data.nPath){
            FolderView(folder: data.startFolder)
        }
        
    }
}
