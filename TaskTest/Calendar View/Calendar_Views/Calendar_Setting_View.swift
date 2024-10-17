//
//  SettingView.swift
//  test
//
//  Created by Billie H on 23/10/24.
//

import SwiftUI

extension CalendarView{
    struct SettingView: View {
        @Environment(\.dismiss) var dismiss
        @Bindable var item : Calendar_Item
        @State var name : String
        @State var time : Int
        @State var timeStarted : MyTime
        @State var dateStarted : Date
        @State var description : String
        var body: some View {
            Form{
                Section{
                    TextField("Name", text: $name)
                    TextField("Time", value: $time, format: .number)
                }
                Section{
                    let name = mData.categories.map{$0.id}
                    Picker("Category", selection: $item.categoryName){
                        ForEach(name, id: \.self){category in
                            Text(category)
                                .tag(category)
                        }
                    }
                }
                Section{
                    DatePicker("Start Time", selection: $timeStarted.date,
                               displayedComponents :.hourAndMinute)
                    DatePicker("Start Date", selection: $dateStarted,
                               displayedComponents: .date)
                    Toggle("Finish on a date?", isOn: $item.isFinished)
                    
                    if item.isFinished{
                        DatePicker("Finish Date", selection: $item.dateFinished ?? dateStarted,
                                   displayedComponents: .date)
                    }
                    DaysPicker(item: item)
                }
                Section("Description"){
                    TextEditor(text: $description)
                }
                Spacer()
                Section{
                    Button(item.completed ? "Uncomplete" : "Complete", action: complete)
                    if !(item.disappearAt?.isEmpty ?? true){
                        Button("Clear", action: clear)
                    }
                    Button("Send", action: send)
                    Button("Delete", action: delete)
                        .buttonStyle(FillButton(color: .red))
                }
                .buttonStyle(FillButton())
                
            }
            .formStyle(.grouped)
            .scrollContentBackground(.hidden)
            .customBackground(Image(.back))
            .buttonStyle(.borderedProminent)
            .navigationBarBackButtonHidden()
            .toolbar{
#if os(iOS)
                ToolbarItem(placement: .topBarLeading){
                    Button("Cancel", action: cancel)
                }
#endif
            }
            .toolbar{
#if os(macOS)
                Button("Cancel", action: cancel)
#endif
                Button("Done", action: done)
                .disabled(name.isEmpty)
            }
        }
        init(item: Calendar_Item) {
            self.item = item
            self.name = item.name
            self.time = item.minute
            self.timeStarted = item.timeStarted
            self.dateStarted = item.dateStarted
            self.description = item.description
        }
        func clear(){
            item.disappearAt?.removeAll()
        }
        
        func cancel(){
            if name.isEmpty{
                item.remove()
            }
            dismiss()
        }
        func done(){
            save()
            dismiss()
        }
        func send(){
            item.send()
            save()
            dismiss()
        }
        func delete(){
            item.remove()
            dismiss()
        }
        func complete(){
            item.completed.toggle()
            save()
            dismiss()
        }
        func save(){
            item.name = name
            item.minute = time
            item.timeStarted = timeStarted
            item.dateStarted = dateStarted
            item.description = description
            item.upload()
        }
    }
    
    
    struct DaysPicker:View {
        var item : Calendar_Item
        var body: some View {
            let arr = ["S", "M", "T", "W", "T", "F", "S"]
            HStack(spacing: 0){
                ForEach(0..<7, id: \.self){i in
                    let contain = item.repeatAt.contains(i)
                    Button(arr[i]){
                        if contain{item.repeatAt.remove(i)}
                        else{item.repeatAt.insert(i)}
                    }
#if os(iOS)
.buttonStyle(.bordered)
#else
.padding()
.buttonStyle(.plain)
#endif
                    .font(.title.bold())
                    .background(contain ? .yellow : .gray)
                    
                }
            }
        }
    }
}

struct FillButton : ButtonStyle {
    var color = Color.blue
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 5).fill(color))
            .foregroundColor(.white)
    }
}
