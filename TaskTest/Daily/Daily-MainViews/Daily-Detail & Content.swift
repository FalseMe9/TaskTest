//
//  Daily-Detail.swift
//  TaskTest
//
//  Created by Billie H on 28/11/24.
//

import Foundation
import SwiftUI
extension DailyView{
    struct CategoryDetail :View{
        let category : Category
        var body: some View{
            List{
                ListView(isMain : true)
                    .environment(\.category, category)
            }
            .listStyle(.sidebar)
            .scrollContentBackground(.hidden)
            .environment(\.category, category)
            .toolbar{
                Button("Plus", systemImage: "plus", action: plus)
            }
            .navigationTitle(category.id)
        }
        func plus(){
            let item = DItem(group: daily, dayStarted: nil)
            item.categoryName = category.id
            daily.items.append(item)
            daily.detail = item
        }
    }
    struct ContentView: View{
        var content : AnyHashable? = daily.content
        var body: some View{
            Warper{
                if let content = content as? Category{
                    CategoryDetail(category: content)
                }
                else if let content = content as? Int{
                    switch content{
                    case 0:
                        TodayView()
                    case 1:
                        Schedule()
                    default:
                        AllView()
                    }
                }
                else{TodayView()}
            }
            .navigationSplitViewColumnWidth(min: 400, ideal: 400)
        }
    }
}
