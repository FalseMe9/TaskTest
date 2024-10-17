//
//  HourlyList.swift
//  TaskTest
//
//  Created by Billie H on 25/10/24.
//

import SwiftUI

extension HourlyView{
    var list: some View{
        List{
            ForEach(filteredItems, id: \.id){
                HTaskView(task: $0)
                    .listRowInsets(EdgeInsets())
                
            }
            .onMove(perform: move)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(.regularMaterial.opacity(0.6))
    }
}
