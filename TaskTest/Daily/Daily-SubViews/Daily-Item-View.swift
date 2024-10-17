//
//  TaskView.swift
//  MultiTaskManager
//
//  Created by Billie H on 13/09/24.
//

import SwiftUI

extension DailyView{
    struct TaskView: View {
        @Environment(\.date) var date
        @Environment(\.category) var category
        @Environment(\.showPrevious) var showPrevious
        @Bindable var task : DItem
        var body: some View {
            Group{
                if task.empty(at: date,
                              for: category,
                              previous: showPrevious){
                    Header(task: task)
                } else{
                    DisclosureGroup(isExpanded: $task.isVisible){
                        ListView(task: task)
                    } label: {
                        Header(task: task)
                    }
                    
                }
            }
            .opacity(task.isClicked ? 0.5 : 1)
        }
    }
}
