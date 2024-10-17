//
//  ShortcutView.swift
//  TaskTest
//
//  Created by Billie H on 26/11/24.
//

import SwiftUI
struct ShortcutView:View {
    @State var filter = ""
    @FocusState var isSearching : Bool
    var body: some View {
        VStack{
            List{
                Group{
                    ForEach(sortedArr, id: \.self){key in
                        if filtered(item: key){
                            ShortcutCell(key: key)
                        }
                        
                    }
                    if !sortedArr.contains(filter){
                        ShortcutCell(key: filter)
                    }
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Rectangle().fill(.primary).colorInvert().opacity(0.8))
            }
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
        .onAppear(perform: focus)
        .navigationTitle("Shortcut")
    }
    func focus(){
        isSearching = true
    }
    func filtered (item : String)->Bool{
        filter.isEmpty ||
        item.localizedStandardContains(filter)
    }
    var sortedArr : [String]{
        hourly.shortcut.dictionary.keys.sorted()
    }
}

struct ShortcutCell:View{
    @FocusState var focus : Bool
    let key : String
    @State var description : String
    init(key : String){
        self.key = key
        _description = State(initialValue: hourly.shortcut.dictionary[key] ?? "")
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
        }
        .onChange(of: focus, uploadDescription)
        .onDisappear{
            if focus {
                uploadDescription()
            }
        }
    }
    
    func uploadDescription(){
        hourly.shortcut.update(key: key, value: description)
    }
    func delete(){
        withAnimation{
            hourly.shortcut.dictionary[key] = nil
            AvoidLoop2 {
                ref.child("Shortcut").child(key).removeValue()
            }
        }
    }
}
