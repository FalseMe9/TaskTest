//
//  DList.swift
//  TaskManager2
//
//  Created by Billie H on 02/10/24.
//

import SwiftUI

extension DailyView{
    struct ListView: View {
        @Environment(\.date) var date
        @Environment(\.category) var category
        @Environment(\.showPrevious) var showPrevious
        var task : any DGroup = daily
        var isMain = false
        var body: some View {
            if isMain, category == nil{
                let noGroup = Set(task.items(at: date, previous: showPrevious).map(\.category)).sorted{
                    $0.id < $1.id
                }
                ForEach(noGroup, id:\.id){category in
                    CategoryList()
                        .environment(\.category, category)
                }
            }
            else{
                ForEach(task.items, id: \.id){task in
                    if task.show(at: date, previous: showPrevious),
                       task.show(for: category) {
                        TaskView(task: task)
                    }
                }
                .onMove(perform: move)
                .padding(.leading, isMain ? 5: 30)
            }
            if let dTask = task as? DItem,
               let date,
               dTask.remainingMinute(at: date)>0,
               !dTask.items(at: date).isEmpty
            {DefaultView(task: dTask)}
        }
        func move(from source:IndexSet, to destination:Int){
            task.items.move(fromOffsets: source, toOffset: destination)
        }
    }
}
extension EnvironmentValues{
    @Entry var date : String? = nil
    @Entry var category : Category? = nil
    @Entry var showPrevious : Bool = false
}
