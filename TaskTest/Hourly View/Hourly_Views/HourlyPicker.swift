//
//  HourlyList.swift
//  TaskTest
//
//  Created by Billie H on 25/10/24.
//

import SwiftUI

extension HourlyView{
    var startLabel : String{
        h.isPlaying ? "pause.fill" : "play.fill"
    }
    var picker: some View{
        ScrollView{
            VStack(spacing: 0){
                HStack{
                    Picker("", selection: $h.currentTask) {
                        ForEach(filteredItems, id: \.id){item in
                            Text(item.name)
                                .tag(item)
                        }
                    }
                    .frame(height: 150)
#if os(iOS)
                    .pickerStyle(.wheel)
#else
                    .pickerStyle(.menu)
#endif
                    .contextMenu{
                        Button("Shortcut", action: showShortcut)
                        Button("Alternative", action: showAlternative)
                    }
                    VStack(spacing: 0){
                        HStack(spacing: 0){
                            Button("", systemImage: "arrow.left.arrow.right", action: h.currentTask?.replaceAll ?? {})
                                .buttonStyle(NormalButton(width: 75, color: .orange))
                            Button("", systemImage: "dock.arrow.down.rectangle"){
                                hourly.selectedItem = h.currentTask
                                hourly.showAlert = true
                            }
                            .buttonStyle(NormalButton(width: 75, color: .yellow))
                        }
                        HStack(spacing: 0){
                            Button("", systemImage: startLabel, action: play)
                                .keyboardShortcut("s", modifiers: .command)
                                .accessibilityLabel(startLabel)
                                .buttonStyle(NormalButton(width: 75, color: .green))
                            Button("Finish", action: h.currentTask?.delete ?? {})
                                .buttonStyle(NormalButton(width: 75, color: .blue))
                        }
                    }
                    .frame(width: 150)
                    .buttonStyle(NormalButton())
                    .padding(.horizontal)
                }
                HStack{
                    Text(h.switchName)
                        .font(.system(size: 10))
                        .opacity(0.5)
                        .frame(width: 80, alignment: .leading)
                        .padding(10)
                        .contentShape(.rect)
                        .onTapGesture(perform: detail)
                    Spacer()
                    Image(systemName: "point.bottomleft.forward.to.arrow.triangle.scurvepath.fill")
                        .scale(size: 10)
                        .foregroundStyle(.blue)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(10)
                        .contentShape(.rect)
                        .onTapGesture(perform: next)
                }
                .padding(.bottom, -10)
                TextEditor(text: $h.description)
                    .frame(maxWidth: .infinity)
                    .scrollContentBackground(.hidden)
                    .background(.regularMaterial).opacity(0.8)
                    .focused($focus, equals: 2)
            }
            .scrollBounceBehavior(.basedOnSize)
            .onChange(of: h.currentTask, refreshIndex)
        }
    }
    func play(){
        h.isPlaying.toggle()
        h.currentTask?.upload()
    }
    func next(){
        let bool = h.currentTask?.alternative.isEmpty ?? true ? 2 : 3
        h.switchIndex = (h.switchIndex + 1) % bool
    }
    func showShortcut(){
        h.shortcutItem = h.currentTask
    }
    func showAlternative(){
        alternative = h.currentTask?.alternative ?? ""
        h.alternativeItem = h.currentTask
        h.alert2 = true
    }
    func refreshIndex(){
        h.switchIndex = 0
    }
    func detail(){
        h.nPath.append(h.switchName)
    }
}

