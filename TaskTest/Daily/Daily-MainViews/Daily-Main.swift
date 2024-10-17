//
//  Daily-Main.swift
//  TaskTest
//
//  Created by Billie H on 16/11/24.
//

import SwiftUI
extension DailyView{
    struct MainView: View {
        let columns = [
            GridItem(.flexible(minimum: 90)),
            GridItem(.flexible(minimum: 90))
        ]
        @Bindable var d = daily
        var body: some View {
            VStack{
                LazyVGrid(columns: columns, alignment: .leading, spacing: 4){
                    Button{d.content = 0}label: {
                        CustomLabel(name: "Today", num: d.total(at: mData.currentDate.string), image: "list.bullet.circle.fill")
                    }
                    Button{d.content = 1}label: {
                        CustomLabel(name: "Scheduled", num: d.totalDate, image: "calendar.circle")
                    }
                    Button{d.content = 2}label: {
                        CustomLabel(name: "All", num: d.total(), image: "tray.circle")
                    }
                }
                .buttonStyle(.plain)
                List{
                    Section("Category"){
                        ForEach(mData.categories, id: \.id){category in
                            CategoryView(item: category)
                        }
                    }
                }
                .listRowInsets(EdgeInsets())
                .scrollContentBackground(.hidden)
                Spacer()
            }
            .background(Image("back")
                .resizable().syncBackground()
                .ignoresSafeArea())
            .navigationTitle("Daily")
            .navigationSplitViewColumnWidth(min: 200, ideal: 200, max: 300)
        }
    }
    
}
