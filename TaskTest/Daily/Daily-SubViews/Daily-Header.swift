//
//  DHeader.swift
//  TaskManager2
//
//  Created by Billie H on 02/10/24.
//

import SwiftUI
extension DailyView{
    struct Header: View {
        @Environment(\.date) var date
        @Environment(\.category) var category
        @Environment(\.showPrevious) var previous
        @Bindable var task : DItem
        var isTitle : Bool{
            !task.empty(at: date, for: category)
        }
        var body: some View {
            VStack(alignment: .leading){
                HStack{
                    if !showAll {CircleButton(task: task)}
                    DNameTime(task: task, date: date)
                    InfoButton(task: task)
                    if task.empty(at: date,
                                  for: category,
                                  previous: previous){
                        PlusButton(task: task)
                    }
                }
                .font(isTitle ? .headline.bold() : .headline)
                .padding(.top, 5)
                if task.late {
                    HStack{
                        if task.dayAppeared < mData.dateString {
                            Text(task.dayAppeared ?? "")
                        }
                        Text(task.timeStarted?.string ?? "")
                    }
                    .foregroundStyle(.red)
                    .font(.footnote)
                }
            }
            .listRowInsets(EdgeInsets())
            .buttonStyle(.plain)
            .swipeActions(edge: .leading, allowsFullSwipe: true){
                Button("send", systemImage: "paperplane"){
                    withAnimation{task.send(at: date)}
                }
                .tint(.blue)
                Button("send time", systemImage: "clock.badge.questionmark", action: sendTime)
                .tint(.orange)
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: true){
                Button("delete", systemImage: "trash", role: .destructive, action: task.remove)
            }
        }
        var showAll:Bool{
            date == nil
        }
        func sendTime(){
            daily.action = submit
            daily.showAlert.toggle()
        }
        func submit(){
            task.send(minute: daily.input, at: date)
            daily.input = 0
            daily.showAlert = false
        }
        
    }
}

extension DItem {
    var late : Bool {
        guard let dayAppeared else {return false}
        if dayAppeared < mData.dateString {return true}
        if let timeStarted {
            return showTime && timeStarted < .now && dayAppeared == mData.dateString
        }
        return false
    }
}

extension Comparable{
    static func < (lhs : Self?, rhs: Self)-> Bool{
        guard let lhs else {return true}
        return lhs < rhs
    }
}

