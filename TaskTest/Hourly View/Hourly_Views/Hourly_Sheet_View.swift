//
//  Hourly_Sheet_View.swift
//  TaskManager
//
//  Created by Billie H on 23/10/24.
//

import SwiftUI

extension HourlyView {
    var sheetView: some View {
        NavigationStack{
            VStack{
                if let now = cItem.now{
                    Text("\(now.name) : \(now.timeStarted.string) - \(now.timeFinished.string)")
                    Text(now.description)
                        .font(.caption)
                    if let item = cItem.now{
                        HStack{
                            let title = item.completed ? "Refresh" : "Complete"
                            Button(title){
                                item.completed.toggle()
                                showSheet.toggle()
                            }
                            .tint(.yellow)
                            if !item.completed{
                                Button("Get"){
                                    item.send()
                                    showSheet.toggle()
                                }
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                else{
                    Text("Free")
                    if let next = cItem.next{
                        let name = next.name
                        let time = next.timeStarted.string
                        Text("\(name) at \(time)")
                    }
                    else{Text("Finished")}
                    
                }
                Text(unfinishedCount.string)
                Toggle("Show Time", isOn: $h.showTime)
                Toggle("Show Incomplete", isOn: $h.showIncomplete)
                Toggle("Filter", isOn: $h.filter)
                Toggle("Add To Next Item", isOn: $h.addNext)
                List(daily.lateItem){item in
                    HStack(alignment: .center){
                        Text(item.name)
                            .font(.headline)
                        Spacer()
                        Button("Get"){item.send(at: mData.dateString)}
                    }
                    .buttonStyle(.borderedProminent)
                    .swipeActions{
                        Button("", systemImage: "checkmark"){
                            item.at().isFinished = true
                        }
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                    }
                }
            }
            .toggleStyle(.switch)
            .font(.title2.bold())
            .padding()
            .toolbar{
                Button("Done", role: .cancel){
                    showSheet.toggle()
                    sync()
                }
            }
        }
        .macResize()
    }
}
extension DGroup{
    var lateItem : [DItem]{
        var ret = [DItem]()
        for item in items{
            ret += item.late ? [item] : item.lateItem
        }
        return ret
    }
}
