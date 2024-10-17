//
//  DailyCategory.swift
//  TaskTest
//
//  Created by Billie H on 19/11/24.
//

import SwiftUI
import SFSymbolsPicker

extension DailyView{
    struct CategoryView:View{
        @Bindable var item : Category
        @State var showSheet = false
        var body: some View{
            Button{daily.content = item}label: {
                HStack(alignment: .center){
                    Image(systemName: item.icon ?? "rectangle.stack")
                        .scale(size: 25)
                    Text(item.id)
                        .font(.headline)
                    Spacer()
                    Text(total(item), format: .number)
                        .font(.footnote)
                }
                .padding(.vertical, 10)
            }
            .contextMenu{
                Button("Change Icon"){showSheet = true}
            }
            .listRowBackground(RoundedRectangle(cornerRadius: 5).fill(.regularMaterial))
            .listRowInsets(EdgeInsets())
            .sheet(isPresented: $showSheet){
                SymbolsPicker(selection: $item.icon ?? "rectangle.stack", title: "Select Icon", autoDismiss: true)
                    .macResize()
            }
        }
        func changeIcon(){
            showSheet = true
        }
        func total(_ category : Category)->Int{
            daily.items.filter{$0.category == category}.count
        }
    }
}
extension View{
    func macResize()->some View{
        self
        #if os(macOS)
        .frame(idealWidth: NSApp.keyWindow?.contentView?.bounds.width ?? 500, idealHeight: NSApp.keyWindow?.contentView?.bounds.height ?? 500)
        #endif
    }
}
