//
//  Hourly_Section_View.swift
//  TaskTest
//
//  Created by Billie H on 01/11/24.
//

import SwiftUI

extension HourlyView{
    func color(item : Calendar_Item?) -> Color{
        if let item{
            item.category.color
        }
        else{
            .primary
        }
    }
    var sectionView: some View {
        VStack(spacing: 0){
            Blackline()
            Button(action: showDetail){
                HStack(alignment: .top){
                    VStack(alignment: .center){
                        var string : String{
                            if let now = cItem.now{
                                "\(now.name) : \(now.timeStarted.string) - \(now.timeFinished.string)"
                            }
                            else{
                                "Free until \(timeEnded.string)"
                            }
                        }
                        Text(string)
                        if h.showTime{Text(timeRemaining.string)}
                    }
                    .font(.title2.bold())
                    .onAppear(perform: sync)
                    .onChange(of: h.items, sync)
                    if unfinishedCount > 0, h.showIncomplete{
                        Image(systemName: "\(unfinishedCount).circle.fill")
                            .foregroundStyle(.red)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 5)
                .background(sectionColor.opacity(0.5))
            }
            .buttonStyle(.plain)
            Blackline()
        }
    }
}
