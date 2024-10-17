//
//  Category_List.swift
//  TaskTest
//
//  Created by Billie H on 07/12/24.
//

import SwiftUI

extension DailyView{
    struct CategoryList: View {
        @State private var expand = false
        var body : some View{
            DisclosureGroup(isExpanded: $expand){
                ListView(isMain: true)
            } label: {
                CategoryHeader()
            }
        }
    }
}
