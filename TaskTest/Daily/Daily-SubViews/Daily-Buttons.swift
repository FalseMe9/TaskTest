//
//  DButtons.swift
//  TaskManager2
//
//  Created by Billie H on 02/10/24.
//

import SwiftUI
extension DailyView{
    struct InfoButton:View{
        var task : DItem
        var size : CGFloat = 20
        var body: some View{
            CustomButton(image: "info.circle", action: info)
            .padding(.leading)
        }
        func info(){
            daily.detail = task
        }
    }
    struct CircleButton:View {
        @State var timer : Timer?
        @Environment(\.date) var date
        var size : CGFloat = 20
        var task : DItem
        var subTask : DSubItem {task.at(date)}
        var bool : Bool {subTask.isFinished || task.isClicked }
        var image : String{bool ? "circle.circle.fill" : "circle"}
        var body: some View {
            CustomButton(image: image,size: size, action: finish)
        }
        func finish(){
            withAnimation(.linear(duration: 0.5)){
                task.isClicked = !subTask.isFinished
            } completion: {
                subTask.isFinished = task.isClicked
                task.isClicked = false
            }
        }
    }
    struct PlusButton:View {
        @Environment(\.date) var date
        @Environment(\.category) var category
        var task:DItem
        var body: some View {
            Image(systemName: "plus")
                .scale(size: 10)
                .opacity(0.5)
                .padding(10)
                .contentShape(Rectangle())
                .onTapGesture(perform: plus)
                .padding(.vertical, -10)
        }
        func plus(){
            withAnimation{
                let newTask = DItem(group: task, dayStarted: date)
                newTask.category = category ?? .home
                task.items.append(newTask)
                task.isVisible = true
            }
        }
    }
    
}
struct CustomButton : View{
    var image : String
    var size : CGFloat = 20
    var action : ()->()
    var body : some View{
        Button(action:action){
            Image(systemName: image)
                .scale(size: size)
        }
        .frame(width: size)
        .frame(maxHeight: .infinity)
    }
}


