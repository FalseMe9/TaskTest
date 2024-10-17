//
//  NameTimeView.swift
//  TaskManager2
//
//  Created by Billie H on 02/10/24.
//

import SwiftUI

struct NameTimeView: View {
    @Binding var name : String
    @Binding var time : Int
    @FocusState var focus : Int?
    var width :CGFloat = 60
    var remove : ()->() = {}
    var submit : ()->() = {}
    var body: some View {
        HStack{
            TextField("Name", text: $name)
                .contentShape(Rectangle())
                .focused($focus, equals: 1)
                .onSubmit(submitName)
        
            TextField("0", value: $time, format: .number)
                .multilineTextAlignment(.trailing)
                .frame(width: width)
                .contentShape(Rectangle())
                .focused($focus, equals: 2)
                .onSubmit(submitTime)
            #if os(iOS)
                .keyboardType(.numberPad)
                .toolbar{
                    if focus != nil{
                        ToolbarItemGroup(placement:.keyboard){
                            Button("Done"){
                                focus = nil
                                if name.isEmpty{remove()}
                            }
                            .buttonStyle(.plain)
                            .foregroundStyle(.blue)
                            .frame(minWidth: 100, maxWidth: .infinity, alignment: .leading)
                                .font(.headline)
                            Button("Next", action: focus == 1 ? submitName : submitTime)
                                .frame(minWidth: 100,alignment: .trailing)
                            .font(.headline)
                            .foregroundStyle(.blue)
                            .buttonStyle(.plain)
                        }
                    }
                }
            #endif
            
        }
        .onAppear(){
            if name.isEmpty{focus = 1}
        }
    }
    func submitName(){
        if name.isEmpty{remove()}
        else{
            focus = 2
        }
    }
    func submitTime(){
        if name.isEmpty{remove()}
        else{submit()}
    }
}

#Preview {
    NameTimeView(name: .constant(""), time: .constant(0))
}
