//
//  Daily-Setting.swift
//  TaskTest
//
//  Created by Billie H on 18/10/24.
//

import SwiftUI

extension DailyView{
    struct Setting: View {
        @Bindable var d = daily
        @Bindable var item : DItem
        @State private var description : String
        @State private var category : String
        @State private var navigate = false
        var body: some View {
            Form{
                Section("Data"){
                    TextField("Name", text: $item.name)
                    TextField("Minute", value: $item.defaultMinute, format: .number)
                }
                Section("Category"){
                    let name = mData.categories.map{$0.id}
                    Picker("Category", selection: $category){
                        ForEach(name, id: \.self){category in
                            Text(category)
                                .tag(category)
                        }
                    }
                }
                Section("Date"){
                    Toggle("Date", isOn: $item.isDate)
                        .toggleStyle(.switch)
                    if item.isDate{
                        DatePicker("Date Started", selection: $item.dayStarted_Raw ?? mData.currentDate, displayedComponents: .date)
                        Toggle("Time", isOn: $item.showTime)
                            .toggleStyle(.switch)
                        if item.showTime{
                            DatePicker("Time Started", selection: $item.timeStarted_Raw ?? .now, displayedComponents: .hourAndMinute)
                        }
                    }
                    Toggle("Repeat", isOn: $item.isRepeat)
                        .toggleStyle(.switch)
                    if item.isRepeat{
                        DaysPicker(item: item)
                    }
                }
                .onChange(of: item.dayStarted){old, new in
                    item.syncDay(date: old)
                }
                Section("Custom Time"){
                    ForEach(item.appears.sorted(), id: \.self){num in
                        HStack{
                            Text(mData.days[num])
                            TextField("", value: $item.customMinute[num], format: .number)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                }
                Section("Used Times"){
                    let keys = item.usedMinutes.keys.sorted()
                    ForEach(keys, id: \.self)
                    {key in
                        HStack{
                            Text(key)
                            TextField("", value: $item.usedMinutes[key], format: .number)
                        }
                    }
                }
                Section{
                    TextEditor(text: $description)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .scrollContentBackground(.hidden)
                        .scrollDisabled(true)
                } header: {
                    HStack(alignment: .center){
                        Text("Description")
                        Spacer()
                        Button("Details", action: details)
                        .buttonStyle(.plain)
                        .foregroundStyle(.blue)
                        .font(.footnote)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .formStyle(.grouped)
            .padding()
            .customBackground(Image(.light))
            .onAppear(perform: appear)
            .onDisappear(perform: done)
            .toolbar{
                ToolbarItem{
                    Button("Done", action: close)
                }
            }
            .navigationDestination(isPresented: $navigate){
                TextView(text: item.name, completion: appear)
            }
        }
        init(item: DItem) {
            self.item = item
            self.description = item.description
            _category = State(initialValue: item.categoryName)
        }
        func details(){
            item.description = description
            navigate = true
        }
        func done(){
            item.description = description
            item.categoryName = category
            item.syncCategory()
            item.upload()
        }
        func appear(){
            description = item.description
        }
        func close(){
            daily.detail = nil
        }
    }
    struct DaysPicker:View {
        var item : DItem
        var body: some View {
            let arr = ["S", "M", "T", "W", "T", "F", "S"]
            HStack(spacing: 0){
                ForEach(0..<7, id: \.self){i in
                    let contain = item.appears.contains(i)
                    Button(arr[i]){
                        if contain{item.removeDate(i)}
                        else{item.insertDate(i)}
                    }
                    .font(.title.bold())
                    .buttonStyle(ColoredButton(color: contain ? .yellow : .gray, width: 40, height: 40))
                }
            }
        }
    }
}
struct ColoredButton : ButtonStyle {
    var color : Color = .blue
    var width : CGFloat = 50
    var height : CGFloat = 50
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: width, height: height)
            .background(RoundedRectangle(cornerRadius: 8).fill(color))
    }
}

extension DItem{
    var isDate : Bool{
        get{dayStarted != nil}
        set{dayStarted = newValue ? mData.dateString : nil}
    }
    var showTime : Bool {
        get{timeStarted != nil}
        set{timeStarted = newValue ? MyTime() : nil}
    }
    var isRepeat : Bool{
        get{!appears.isEmpty}
        set{
            if isRepeat != newValue{
                if newValue{appears.insert(mData.index)}
                else{appears.removeAll()}
            }
        }
    }
    var isEnding : Bool{
        get{dateFinished != nil}
        set{dateFinished = newValue ? mData.currentDate : nil}
    }
}
public func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}
#if os(iOS)

var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
var isIPhone: Bool {
    UIDevice.current.userInterfaceIdiom == .phone
}
#endif
