//
//  DataView.swift
//  test
//
//  Created by Billie H on 23/10/24.
//

import SwiftUI
extension CalendarView{
    struct DataView: View {
        @Environment(\.date) var date
        var body: some View {
            ZStack(alignment:.topLeading){
                ForEach(cData.items, id: \.id){item in
                    if item.appear(at: date){
                        ItemView(item: item)
                            .offset(y:CGFloat(item.timeStarted.time))
                            .contextMenu{
                                Button("Delete", role: .destructive){
                                    item.remove(from: date)
                                    print(item.disappear(at: date))
                                    print(item.appear(at: date))
                                }
                            }
                    }
                }
            }
        }
    }
}
