//
//  FolderView.swift
//  TaskManager2
//
//  Created by Billie H on 19/09/24.
//

import SwiftUI

struct FolderView: View {
    @State var folder = Folder()
    var body: some View {
        VStack(spacing: 0){
            List{
                Section("Folder"){
                    ForEach(folder.folderArr, id: \.self){
                        FolderCell(folder: Folder(id: $0), previous: folder)
                            .listRowBackground(Color.yellow.opacity(0.7))
                    }
                    .onDelete(perform: removeF)
                }
                Section("Notes"){
                    ForEach(folder.noteArr, id:\.self){
                        NoteCell(note: Notes(id: $0), previous: folder)
                            .listRowBackground(Color.blue.opacity(0.8))
                    }
                    .onDelete(perform: removeN)
                }
            }
            .scrollBounceBehavior(.basedOnSize)
            .scrollContentBackground(.hidden)
        }
        .customBackground(Image(.light))
        .toolbar(){
            Button("", systemImage: "folder.badge.plus"){
                folder.folderArr.append(UUID().uuidString)
            }
            Button("", systemImage: "book.closed.fill"){
                folder.noteArr.append(UUID().uuidString)
            }
            Button("Home"){
                path.path = NavigationPath()
            }
        }
        .navigationTitle(folder.id == "Notes" ? folder.id : folder.name)
        .navigationDestination(for: Folder.self){selected in
            FolderView(folder: selected)
        }
        .navigationDestination(for: Notes.self){selected in
            TextView(text: selected.name, completion: selected.uploadD)
        }
    }
    func removeF(index : IndexSet){
        let id = folder.folderArr[index.first ?? 0]
        Folder(id: id).clear()
        folder.folderArr.remove(atOffsets: index)
    }
    func removeN(index : IndexSet){
        let id = folder.noteArr[index.first ?? 0]
        Notes(id: id).clear()
        folder.noteArr.remove(atOffsets: index)
    }
}
struct FolderCell:View {
    @State var folder = Folder()
    var previous : Folder
    var body: some View {
        HStack{
            Button("", systemImage: "folder"){
                notes.nPath.append(folder)
            }
            .buttonStyle(DefaultButton())
            TextField("", text: $folder.name)
        }
    }
}
struct NoteCell:View {
    @State var note = Notes()
    var previous:Folder
    var body: some View {
        HStack{
            Button("", systemImage: "book.pages.fill"){
                notes.nPath.append(note)
            }
            .buttonStyle(DefaultButton())
            TextField("", text: $note.name)
        }
    }
}
#Preview {
    FolderView()
}
