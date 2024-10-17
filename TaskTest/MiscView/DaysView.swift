//
//  DaysView.swift
//  TaskTest
//
//  Created by Billie H on 18/10/24.
//

import Foundation
import SwiftUI

struct DaysView:View {
    @Bindable var d = mData
    let rows = [
        GridItem(.adaptive(minimum: 150))
    ]
    var body: some View {
        VStack(spacing:0){
            Blackline(height: 1)
            ScrollViewReader{read in
                ScrollView(.horizontal){
                    HStack(spacing: 0){
                        ForEach((mData.index-3)..<(mData.index+4), id:\.self){num in
                            ZStack(){
                                var index : Int{
                                    if num < 0 { num + 7}
                                    else if num > 6 {num - 7}
                                    else {num}
                                }
                                if mData.index == num{
                                    Color.gray
                                }
                                Button(mData.days[index]){
                                    mData.index = num
                                }
                                .padding(.horizontal)
                                .font(.title.bold())
                                .disabled(disableButton(num))
                                .frame(maxWidth: .infinity)
                            }
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 5)
                                .fill(.regularMaterial)
                                .opacity(0.5)
                            )
                            .border(Color.secondary)
                            .id(num)
                        }
                    }
                    .frame(height: 50)
                    .frame(maxWidth:.infinity)
                    #if os(macOS)
                    .containerRelativeFrame(.horizontal){size, axis in
                        return size
                    }
                    #endif
                }
                .scrollContentBackground(.hidden)
                .scrollBounceBehavior(.basedOnSize)
                .animation(.default, value: mData.index)
                .onAppear(){
                    read.scrollTo(mData.index, anchor: .center)
                }
                .onChange(of: mData.currentDate){
                    read.scrollTo(mData.index, anchor: .center)
                }
            }
                .buttonStyle(.plain)
            Blackline(height: 1)
            DatePicker("", selection: $d.currentDate, displayedComponents: .date)
                
            Blackline(height: 1)

        }
    }
    var disableArrow : Bool{
        diff2 < -1
    }
    func disableButton(_ num : Int) -> Bool{
        let d = num - mData.index
        return d + diff2 < -2
        
    }
    var minus : Bool{
        mData.currentDate - Date.now + 1 < diff
    }
    var equals : Bool{
        mData.currentDate - Date.now == diff
    }
    var diff : Int{
        mData.index - Date.now.dayNumberOfWeek()
    }
    var diff2 : Int{
        mData.currentDate - Date.now
    }
         
}
