//
//  ItemView.swift
//  test
//
//  Created by Billie H on 22/10/24.
//

import SwiftUI

extension CalendarView{
    struct ItemView: View {
        @State var item = Calendar_Item()
        @State private var dragging = false
        var color : Color{
            item.category.color
        }
        var body: some View {
            let longTap = LongPressGesture(minimumDuration: 0.6)
                .onEnded{_ in
                    cData.isEditing = false
                    item.isEditing = true
                }
            let drag1 = DragGesture()
                .onChanged{offset in
                    dragging = true
                    item.minute += time(for: offset)
                }
                .onEnded{_ in
                    dragging = false
                }
            let drag2 = DragGesture()
                .onChanged{offset in
                    dragging = true
                    item.timeStarted.minute += time(for: offset)
                    item.minute -= time(for: offset)
                }
                .onEnded{_ in
                    dragging = false
                }
                
            let drag3 = DragGesture()
                .onChanged{offset in
                    if item.isEditing, !dragging{
                        item.timeStarted.minute += time(for: offset)}
                }
            let combined = longTap.simultaneously(with: drag3)
            ZStack(alignment: .topLeading){
                if item.isEditing{
                    VStack(spacing:0){
                        Circle().frame(width: 10).offset(x:-30,y:-5)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .gesture(drag2)
                        Spacer()
                        
                        Circle().frame(width: 10).offset(x:30,y:5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .gesture(drag1)
                        
                    }
                }
                
                HStack(alignment: .top){
                    color
                        .frame(maxWidth: 4)
                    VStack(alignment: .leading){
                        Text(item.name)
                            .font(.headline.bold())
                        if item.minute >= 45{
                            HStack{
                                Image(systemName: "clock")
                        
                                Text("\(item.timeStarted.string) - \(item.timeFinished.string)")
                            }
                        }
                    }
                    .font(.caption)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 5).fill(color.opacity(0.5)))
            .padding(.horizontal, 5)
            .frame(height: CGFloat(item.minute), alignment: .topLeading)
            .onTapGesture {cData.nPath.append(item)}
            .simultaneousGesture(combined)
            
        }
        func time(for offset : DragGesture.Value)->Int{
            (Int(offset.translation.height)/15)*15
        }
    }
}
