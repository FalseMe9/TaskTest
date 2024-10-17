//
//  SettingView.swift
//  TaskManager
//
//  Created by Billie H on 11/10/24.
//

import Foundation
import SwiftUI

struct SettingView: View {
    @Bindable var m = mData
    @Bindable var h = hourly
    var body: some View {
        List{
            Section("Shortcut"){
                NavigationLink("Shortcut", destination: ShortcutView())
            }
            Section("Misc"){
                Toggle("Get From Daily :", isOn: $h.allowNextDate)
                    .toggleStyle(.switch)
            }
            Section{
                ForEach(0..<h.source.count, id: \.self){ num in
                    TextField("", text: $h.source[num])
                        .textFieldStyle(.plain)
                }
                .onDelete(perform: remove)
            } header: {
                HStack{
                    Text("Memo")
                    Spacer()
                    Button("", systemImage: "plus"){h.source.append("")}
                        .buttonStyle(.plain)
                }
            }
            Section("Date"){
                DatePicker("Date", selection: $m.currentDate, displayedComponents: .date)
            }
            Section("Background"){
                NavigationLink("Images", destination: Text("ImagesView"))
            }
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("Shortcut")
        .background(Image(.nature).resizable().ignoresSafeArea().colorInvert().syncBackground())
    }
    func remove(offset : IndexSet){
        if let index = offset.first{
            h.source.remove(at: index)
        }
    }
}

