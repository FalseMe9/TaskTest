//
//  Daily-Full.swift
//  TaskTest
//
//  Created by Billie H on 18/10/24.
//

import SwiftUI
extension DailyView{
    struct AllView: View {
        @Bindable var d = daily
        var body: some View {
            List{
                ListView(task: daily, isMain: true)
            }
            .listStyle(.sidebar)
            .scrollContentBackground(.hidden)
            .environment(\.date, nil)
            .navigationTitle("All Task")
            .toolbar{
                Button("Download", systemImage: "arrow.down.square", action: download)
                Button("Plus", systemImage: "plus", action: plus)
            }
            .confirmationDialog("Save & Load", isPresented: $d.showSheet){
                Button("Set", action: daily.set)
                Button("Load", action: daily.load)
                Button("Cancel", role: .cancel){}
            }
        }
        func download(){
            d.showSheet = true
        }
        func plus(){
            let newTask = DItem(group: daily)
            d.items.append(newTask)
            d.detail = newTask
        }
    }
}

