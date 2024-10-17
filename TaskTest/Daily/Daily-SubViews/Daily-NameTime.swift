//
//  DNameTime.swift
//  TaskManager2
//
//  Created by Billie H on 02/10/24.
//

import SwiftUI
extension DailyView{
    struct DNameTime: View {
        @Environment(\.category) var category
        let item : DItem
        let date : String?
        @Bindable var sub : DSubItem
        @State var name : String
        @FocusState var focus : Int?
        var body: some View {
            HStack{
                TextField("Name", text: $name)
                    .contentShape(Rectangle())
                    .focused($focus, equals: 1)
                    .onSubmit(submitName)
                
                TextField("0", value: $sub.availableMinute, format: .number)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 60)
                    .contentShape(Rectangle())
                    .focused($focus, equals: 2)
                    .onSubmit(submitTime)
#if os(iOS)
                    .keyboardType(.numberPad)
                    .toolbar{
                        if focus != nil{
                            ToolbarItemGroup(placement:.keyboard){
                                Button("Done"){
                                    focus = nil
                                    if name.isEmpty{item.remove()}
                                }
                                .buttonStyle(.plain)
                                .foregroundStyle(.blue)
                                .frame(minWidth: 100, maxWidth: .infinity, alignment: .leading)
                                .font(.headline)
                                Button("Next", action: focus == 1 ? submitName : submitTime)
                                    .frame(minWidth: 100,alignment: .trailing)
                                    .font(.headline)
                                    .foregroundStyle(.blue)
                                    .buttonStyle(.plain)
                            }
                        }
                    }
#endif
            }
            .onAppear(){
                if item.name != name{name = item.name}
                if name.isEmpty{focus = 1}
            }
            .onChange(of: focus){
                if focus != 1 {
                    syncName()
                }
            }
        }
        // Functions
        func submit(){
            withAnimation{
                let newItem = DItem(group: item.group, dayStarted: date)
                newItem.categoryName = category?.id ?? "Home"
                print(newItem.category.id)
                item.group.items.insert(newItem, at: item.index + 1)
            }
        }
        func syncName(){
            if name.isEmpty{item.remove()}
            else{
                mData.categoryDict.update(key: name, value: item.categoryName)
                item.name = name
            }
        }
        func submitName(){
            syncName()
            if !name.isEmpty{focus = 2}
        }
        func submitTime(){
            if name.isEmpty{item.remove()}
            else{submit()}
        }
        init(task: DItem, date: String?) {
            self.item = task
            self.date = date
            _name = State(initialValue: task.name)
            _sub = Bindable(wrappedValue: task.at(date))
        }
    }
}


