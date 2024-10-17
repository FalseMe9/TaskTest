//
//  HTaskView.swift
//  MultiTaskManager
//
//  Created by Billie H on 13/09/24.
//

import SwiftUI

struct HTaskView: View {
    @State var task : HTask
    @State private var showAlert = false
    @FocusState var focus : Int?
    var body: some View {
        HStack{
            Button("", systemImage: task.isPlaying ? "pause.fill" :  "play.fill", action: play)
            NameTimeView(name: $task.name, time: $task.minute, remove: task.delete, submit: submit)
        }
        .buttonStyle(DefaultButton())
        .font(.title2)
        .padding()
        .swipeActions(edge: .trailing){
            Button("Insert", systemImage: "dock.arrow.down.rectangle"){
                hourly.showAlert = true
                hourly.selectedItem = task
            }
            .tint(.yellow)
            Button("Replace", systemImage: "arrow.left.arrow.right", action: task.replaceAll)
                .tint(.orange)
            Button("", systemImage: "info.circle", action: info)
                .tint(.blue)
        }
        .swipeActions(edge: .leading){
            Button("Finish", action: task.delete)
                .tint(.blue)
        }
        .contextMenu{
            Button("Shortcut")
            {hourly.shortcutItem = task}
        }
        .onAppear(){
            if task.name.isEmpty{
                focus = 1
            }
        }
    }
    func submit(){
        hourly.items.insert(HTask(), at: task.index+1)
    }
    func play(){
        task.isPlaying.toggle()
        task.upload()
    }
    func info(){
        hourly.nPath.append(task.name)
    }
    
}
