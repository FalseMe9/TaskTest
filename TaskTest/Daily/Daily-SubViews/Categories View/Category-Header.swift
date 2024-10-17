//
//  Category-Header.swift
//  TaskTest
//
//  Created by Billie H on 07/12/24.
//

import SwiftUI
extension DailyView{
    struct CategoryHeader: View {
        @Environment(\.date) var date
        @Environment(\.category) var category
        @Environment(\.showPrevious) var showPrevious
        var body: some View{
            VStack{
                HStack{
                    Text(category?.id ?? "Home")
                        .opacity(0.5)
                    Spacer()
                    Text(daily.totalTime(at: date,
                                         for: category,
                                         previous: showPrevious).string)
                    .frame(width: 60, alignment: .trailing)
                    .padding(.trailing)
                    CustomButton(image: "info.circle", action: info)
                }
                .font(.headline)
            }
            .buttonStyle(.plain)
            .listRowInsets(EdgeInsets())
        }
        func info(){
            daily.category = category
        }
    }
}
