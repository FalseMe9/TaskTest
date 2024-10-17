//
//  DDefault.swift
//  TaskManager2
//
//  Created by Billie H on 02/10/24.
//

import SwiftUI

extension DailyView{
    struct DefaultView: View {
        @Environment(\.date) var date
        @State var task : DItem
        @State var clicked = false
        @State private var showsheet = false
        @State private var minute = 0
        var image : String{clicked ? "circle.circle.fill" : "circle"}
        var remainingMinute : Int{task.remainingMinute(at: date)}
        var body: some View {
            HStack{
                Button(action: finish){
                    Image(systemName: image)
                        .scale(size: 20)
                }
                .buttonStyle(DefaultButton())
                Text(task.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(remainingMinute.string)
                    .frame(width: 100, alignment: .trailing)
            }
            .font(.headline)
            .padding(.vertical, 5)
            .padding(.leading, 30)
            .padding(.trailing, 70)
            .listRowInsets(EdgeInsets())
            .swipeActions(edge: .leading, allowsFullSwipe: true){
                Button("send", systemImage: "paperplane"){ sendDefaults(at: date)
                }
                .tint(.blue)
                Button("send time", systemImage: "clock.badge.questionmark"){
                    showsheet.toggle()
                }
                .tint(.orange)
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: true){
                Button("delete", systemImage: "trash", role: .destructive, action: remove)
            }
            .alert("", isPresented: $showsheet){
                TextField("Time", value: $minute, format: .number)
                Button("Ok", action: submit)
            }
        }
        func submit(){
            task.minus(minute)
            hourly.items.append(HTask(name: task.name, time: minute * 60))
            minute = 0
            showsheet = false
        }
        func finish(){
            withAnimation(.linear(duration: 0.5)){
                clicked.toggle()
            } completion: {
                if clicked{
                    task.minus(remainingMinute, at: date)
                    clicked = false
                }
            }
        }
        func remove(){
            task.minus(remainingMinute, at: date)
        }
        func sendDefaults(at date:String?){
            hourly.items.append(HTask(name: task.name, time: remainingMinute * 60))
            remove()
        }
    }
}
