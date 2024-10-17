//
//  HourlyHeader.swift
//  TaskTest
//
//  Created by Billie H on 25/10/24.
//

import SwiftUI

extension HourlyView {
    var header: some View{
        VStack(alignment: .center){
            HStack{
                Button("", systemImage: "book.pages.fill", action: memo)
                    .foregroundStyle(.blue)
                    .keyboardShortcut("f", modifiers: .command)
                Spacer()
                Text(h.currentTask?.name ?? "No Task Selected")
                Spacer()
                Button("", systemImage: "arrow.triangle.swap", action: swap)
                    .foregroundStyle(.blue)
            }
            Text(h.currentTask?.time.toTime() ?? "0")
            Blackline()
            HStack{
                TextField("Enter Command Here", text: $command)
                    .font(.title2)
                    .padding(.leading)
                    .onSubmit(submit)
                    .frame(maxWidth: .infinity)
                    .focused($focus, equals: 1)
                
                Toggle("", isOn: $h.isShuffling)
                    .frame(width: 150, alignment: .trailing)
                    .toggleStyle(.switch)
            }
        }
        .buttonStyle(.plain)
        .font(.largeTitle.bold())
    }
    func memo(){
        h.nPath.append(2)
    }
    func submit(){
        h.send(with: command)
        command = ""
    }
    func swap(){
        h.isFirstView.toggle()
    }
}
