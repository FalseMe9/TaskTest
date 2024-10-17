//
//  ContentView.swift
//  test
//
//  Created by Billie H on 21/10/24.
//

import SwiftUI



struct CalendarView: View {
    @State var calData = cData
    var body: some View {
        NavigationStack(path:$calData.nPath){
            VStack{
                DaysView()
                ScrollView{
                    ZStack(alignment: .topLeading){
                        TimeBackground()
                            .onTapGesture(count:2) {location in
                                let item = Calendar_Item()
                                item.timeStarted.minute = Int(location.y/15)*15
                                calData.items.append(item)
                                calData.nPath.append(item)
                            }
                            .simultaneousGesture(
                                TapGesture().onEnded{
                                    calData.isEditing = false
                                }
                            )
                        
                        DataView()
                            .environment(\.date, mData.dateString)
                            .padding(.leading,60)
                        TimeForeground()
                    }
                    .toolbar{
                        Button("Home", systemImage: "house.circle", action: home)
                    }
                }
                .scrollContentBackground(.hidden)
                .scrollDisabled(calData.isEditing)
            }
            .customBackground(Image(.back))
            .navigationDestination(for:Calendar_Item.self){item in
                SettingView(item: item)
            }
            .navigationTitle("Calendar")
        }
    }
    func home(){
        mData.currentDate = Date.now
    }
}

struct TimeBackground:View {
    var body: some View {
        LazyVStack(alignment : .leading, spacing: 0){
            ForEach(0..<24, id: \.self){hour in
                Text(MyTime(hour: hour).string)
                    .frame(width:60, height: 60, alignment: .top)
            }
        }
        .contentShape(.rect)
    }
}
struct TimeForeground:View{
    @State var time = MyTime.now.string
    var body:some View{
        HStack(alignment:.center){
            Blackline(height: 2)
            Text(time)
                .frame(width:60)
            Blackline(height: 2)
        }
        .frame(height: 10)
        .offset(y:CGFloat(MyTime.now.time - 5))
        .onAppear{
            time = MyTime.now.string
        }
    }
}
