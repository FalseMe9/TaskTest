//
//  DescriptionView.swift
//  TaskManager
//
//  Created by Billie H on 11/10/24.
//

import Foundation
import SwiftUI
struct DescriptionView:View {
    @State var filter = ""
    @FocusState var isSearching : Bool
    var body: some View {
        VStack{
            List{
                ForEach(hourly.source, id:\.self){key in
                    if filtered(item: key){
                        DescriptionCell(key: key)
                    }
                }
                .onMove(perform: move)
                ForEach(filteredArr, id: \.self){key in
                    if filtered(item: key){
                        DescriptionCell(key: key)
                    }
                }
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Rectangle().fill(.primary).colorInvert().opacity(0.8))
            .scrollContentBackground(.hidden)
            .searchable(text: $filter, prompt: "Looking For...")
            #if os(macOS)
            .searchFocused($isSearching)
#endif
#if os(macOS)
            Button("", action: focus)
                .keyboardShortcut("f", modifiers: .command)
#endif
        }
        .customBackground(Image(.nature), isInverted: true)
        .navigationTitle("Descriptions")
    }
    func focus(){
        isSearching = true
    }
    func filtered (item : String)->Bool{
        filter.isEmpty ||
        item.localizedStandardContains(filter)
    }
    var keys : Set<String> {Set(hourly.detail.dictionary.keys)}
    var filteredArr : [String]{
        keys.filter{!hourly.source.contains($0)}.sorted()
    }
    func move(from source : IndexSet, to destination: Int){
        hourly.source.move(fromOffsets: source, toOffset: destination)
    }
}

struct DescriptionCell:View{
    @FocusState var focus : Bool
    let key : String
    var isPinned : Bool{ hourly.source.contains(key)}
//    var description : Binding<String>{
//        .init{
//            hourly.taskDescription[key] ?? ""
//        } set: {_ in 
//            
//        }
//    }
    @State var description : String
    init(key : String){
        self.key = key
        _description = State(initialValue: hourly.detail.dictionary[key] ?? "")
    }
    

    var body: some View{
        Section(key){
            TextEditor(text: $description)
                .focused($focus)
                .multilineTextAlignment(.leading)
                .scrollDisabled(true)
                .fixedSize(horizontal: false, vertical: true)
                .scrollContentBackground(.hidden)
        }
        .swipeActions{
            Button("Delete", systemImage: "trash",role: .destructive, action: delete)
            Button(isPinned ? "Unpin" :"Pin",
                   systemImage: isPinned ? "pin.slash" : "pin",
                   action: pin)
                .tint(.blue)
        }
        .onChange(of: focus, uploadDescription)
        .onDisappear{
            if focus {
                uploadDescription()
            }
        }
    }
    
    func uploadDescription(){
        hourly.detail.update(key: key, value: description)
    }
    func delete(){
        withAnimation{
            hourly.detail.dictionary[key] = nil
            AvoidLoop2 {
                ref.child("Description").child(key).removeValue()
            }
        }
    }
    func pin(){
        if isPinned{
            hourly.source.removeAll{ $0 == key }
        }
        else{
            hourly.source.append(key)
        }
    }
}
