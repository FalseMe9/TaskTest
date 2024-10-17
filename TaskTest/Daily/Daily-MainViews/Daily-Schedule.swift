//
//  DailyVIew.swift
//  MultiTaskManager
//
//  Created by Billie H on 13/09/24.
//

import SwiftUI

var daily = DailyData()
extension DailyView{
    struct Schedule: View {
        @Bindable var d = daily
        var body: some View {
            List{
                ForEach(dates, id: \.self){date in
                    let current = mData.currentDate
                    var dateString : String{
                        switch date{
                        case current.string:
                            "Today"
                        case current.tomorrow.string:
                            "Tomorrow"
                        case current.yesterday.string:
                            "Yesterday"
                        case current.weekend.string:
                            "Sunday"
                        default:
                            date
                        }
                    }
                    DateView(dateString: dateString)
                        .environment(\.date, date)
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Daily")
        }
        var dates : [String] {
            Set(d.items.compactMap(\.dayAppeared)).sorted()
        }
    }
    struct DateView: View{
        @State private var isExpanding: Bool
        let dateString : String
        var body: some View{
            DisclosureGroup(isExpanded: $isExpanding){
                ListView(task: daily, isMain: true)
            } label: {
                Text(dateString)
                    .font(.headline)
                    .opacity(0.5)
            }
        }
        init(dateString: String) {
            self.dateString = dateString
            _isExpanding = State(initialValue: dateString == "Today")
        }
    }
}


