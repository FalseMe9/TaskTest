//
//  ContentView.swift
//  MultiTaskManager
//
//  Created by Billie H on 13/09/24.
//

import SwiftUI


struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @State var appDidEnterBackgroundDate : Date? = nil
    @State var isFirst = true
    @State var wasPlaying = false
    @State var selector = 0
    @State var offset : CGFloat = 0
    var body: some View {
        Group{
#if os(macOS)
            let gesture = DragGesture()
                .onChanged{offset = $0.translation.width}
                .onEnded{ _ in
                    if offset > 30, selector > 0 {selector -= 1}
                    else if offset < -30, selector < 3 {selector += 1}
                    offset = .zero
                }
            let arr = ["Daily", "Hourly", "Calendar", "Notes"]
            let img = ["list.bullet", "hourglass", "calendar.circle", "folder"]
            let keys : [KeyEquivalent] = ["1", "2", "3", "4"]
            switch selector{
            case 0 :
                DailyView()
            case 1 :
                HourlyView()
            case 2 :
                CalendarView()
            default:
                NotesView()
            }
            HStack{
                ForEach(0..<4){selected in
                    Button{
                        selector = selected
                    }label: {
                        HStack{
                            Image(systemName: img[selected])
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40, alignment: .center)
                            Text(arr[selected])
                                .font(.title2)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .frame(height:60)
                    }
                    .buttonStyle(.plain)
                    .keyboardShortcut(keys[selected], modifiers: .option)
                }
            }
            .frame(maxWidth: .infinity)
            .offset(x: offset, y: 0)
            .gesture(gesture)
#else
            TabView{
                DailyView()
                    .tabItem { Label("Daily", systemImage: "list.bullet") }
                HourlyView()
                    .tabItem { Label("Hourly", systemImage: "hourglass") }
                CalendarView()
                    .tabItem { Label("Calendar", systemImage: "calendar.circle") }
                NotesView()
                    .tabItem { Label("Notes", systemImage: "folder") }
            }
            
            
            
            
            
#endif
        }
        .onAppear(){
            if isFirst{
                notes.load()
                isFirst = false
            }
        }
        #if os(iOS)
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active{
                if wasPlaying{
                    guard let previousDate = appDidEnterBackgroundDate,
                          let task = hourly.currentTask else{return}
                    Notification.removeNotification()
                    let calendar = Calendar.current
                    let difference = calendar.dateComponents([.second], from: previousDate, to: Date())
                    let timerSeconds = difference.second!
                    task.time -= timerSeconds
                    if task.time < 0 {task.time  = 0}
                    hourly.isPlaying = true
                    wasPlaying = false
                    widget.stopLiveActivity()
                    appDidEnterBackgroundDate = nil
                }
            }
            else {
                saveAll()
                guard let task = hourly.currentTask,
                        task.isPlaying,
                      appDidEnterBackgroundDate == nil
                else{return}
                let index = task.index + 1
                
                hourly.isPlaying = false
                wasPlaying = true
                appDidEnterBackgroundDate = Date()
                
                let body = "\(task.name) is Finished"
                var title:String
                if index > 0 && index < hourly.items.count {
                    let nextTask = hourly.items[index]
                    title = nextTask.name
                }
                else{title = "Finished"}
                Notification.checkForPermission(title: title, body: body,interval: task.time)
                
                let finishDate = Date().addingTimeInterval(TimeInterval(task.time))
                widget.startActivity(name: task.name, date: finishDate)
            }
        }
        #else
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.willCloseNotification)) { newValue in
            saveAll()
        }
        #endif
    }
    func saveAll(){
        hourly.saveDescription()
        notes.save()
    }

}

#Preview {
    ContentView()
}

#if os(iOS)
extension View {
    func endTextEditing() {
        UIApplication.shared.sendAction(
            #selector
            (UIResponder.resignFirstResponder)
            , to: nil, from: nil, for: nil)
    }
}
#endif
var cData = Calendar_Data()
var hourly = HourlyData()
