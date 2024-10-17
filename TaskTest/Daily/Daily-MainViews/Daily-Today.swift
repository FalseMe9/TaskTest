//
//  DHomeView.swift
//  TaskTest
//
//  Created by Billie H on 18/10/24.
//

import SwiftUI
extension DailyView{
    struct TodayView: View {
        @Bindable var d = daily
        var body: some View {
            List{
                ListView(task: daily, isMain: true)
                    .navigationTitle(mData.today)
                    .environment(\.date, mData.currentDate.string)
                    .environment(\.showPrevious, true)
            }
            .listStyle(.sidebar)
            .scrollContentBackground(.hidden)
            .navigationTitle("Today")
            .toolbar{
                Button("Home", systemImage: "house.circle", action: home)
                Button("Plus", systemImage: "plus", action: plus)
                Button(d.isEditing ? "Done" : "Edit"){
                    d.isEditing.toggle()
                }
            }
            .onDisappear{d.isEditing = false}
        }
        func plus(){
            let newTask = DItem(group: daily, dayStarted: .currentDate)
            d.items.append(newTask)
            daily.detail = newTask
        }
        func home(){
            mData.currentDate = Date.now
        }
    }
}
