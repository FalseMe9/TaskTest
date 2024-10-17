//
//  HourlyView.swift
//  MultiTaskManager
//
//  Created by Billie H on 13/09/24.
//

import SwiftUI
struct HourlyView: View {
    @Bindable var h = hourly
    @FocusState var focus : Int?
    @State var command = ""
    @State var showSheet = false
    @State var timeRemaining : Int = 0
    @State var cItem = cData.currentItem(at: mData.currentDate)
    @State var unfinishedCount = daily.lateItem.count
    @State var sectionColor = Color.white
    @State var timeEnded = MyTime(hour: 24)
    @State var alternative = ""
    var body: some View {
        NavigationStack(path:$h.nPath){
            VStack{
                sectionView
                header
                if h.isFirstView{list}
                else{picker}
                Spacer()
            }
            .navigationTitle("Hourly")
            .toolbar{
                Button("", systemImage: "trash", action: clearAll)
                Button("Setting", systemImage: "gear", action: setting)
            }
            .toolbar{
                if focus == 1 || focus == 2{
                    ToolbarItem(placement: .keyboard){
                        Button("Done"){focus = nil}
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title2)
                    }
                }
            }
            .customBackground(Image(.back), isInverted: false)
            .navigationDestination(for: String.self){name in
                TextView(text: name)
            }
            .navigationDestination(item: $h.shortcutItem){item in
                ShortcutView(filter: item.name)
            }
            .navigationDestination(for: Int.self){num in
                switch num{
                case 1 :
                    SettingView()
                default:
                    DescriptionView()
                }
            }
            .alert("", isPresented: $h.showAlert){
                TextField("", text: $command)
                HStack{
                    Button("Insert", action: insert)
                    Button("Replace", action: replace)
                }
            }
            .alert("Insert Alternative", isPresented: $h.alert2){
                TextField(alternative, text: $alternative)
                Button("Ok", action: setAlternative)
            }
            .confirmationDialog("", isPresented: $h.askDate){
                Text("Allow get from next day?")
                Button("Allow", action: h.allow)
                Button("Cancel", role:.cancel, action: h.cancel)
            }
            .sheet(isPresented: $showSheet){
                sheetView
            }
            .animation(.default, value: h.items)
            .animation(.default, value: h.isFirstView)
            
        }
        .onAppear(perform: sync)
    }
    
    var filteredItems : [HTask]{
        if h.filter, let cat = cItem.now?.category{
            return h.items.filter{$0.category == cat}
        }
        return h.items
    }
    func getName(_ index : Int)-> String{
        if index >= 0, index < h.items.count{
            h.items[index].name
        }
        else{""}
    }
    func move(from source:IndexSet, to destination:Int){
        h.items.move(fromOffsets: source, toOffset: destination)
    }
    func showDetail(){
        sync()
        showSheet = true
    }
    func setting(){
        h.nPath.append(Int(1))
    }
    func sync(){
        cItem = cData.currentItem(at: mData.currentDate)
        unfinishedCount = daily.lateItem.count
        sectionColor = color(item: cItem.now)
        timeEnded = cItem.now?.timeFinished ??
            cItem.next?.timeStarted ?? MyTime(hour: 24)
        timeRemaining = timeEnded.time - hourly.finishTime.time.time
    }
    func insert(){
        let item = h.selectedItem ?? h.currentTask
        item?.insert(with: command)
    }
    func replace(){
        if let item = h.selectedItem ?? h.currentTask{
            item.replace(command: command)
        }
    }
    func clearAll(){
        h.removeItems()
        h.clearAll()
        daily.clearAll()
        cData.clearAll()
    }
    func setAlternative(){
        h.currentTask?.alternative = alternative
    }
}



#Preview {
    HourlyView()
}
