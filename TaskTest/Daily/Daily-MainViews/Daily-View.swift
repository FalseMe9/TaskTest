//
//  DFullView.swift
//  TaskTest
//
//  Created by Billie H on 18/10/24.
//

import SwiftUI
struct DailyView: View {
    @Bindable var d = daily
    var body: some View {
        if myDevice == .iPhone{
            NavigationStack{
                MainView()
                    .navigationDestination(item: $d.content, destination: ContentView.init)
            }
        }
        else{
            NavigationSplitView(sidebar: MainView.init){
                NavigationStack{ContentView()}
            }
        }
    }
    struct CustomLabel:View {
        var name : String
        var num : Int = 0
        var image : String
        var body: some View {
            VStack(alignment: .leading){
                HStack{
                    Image(systemName: image)
                        .scale(size: 20)
                    Spacer()
                    Text(num, format: .number)
                        .font(.system(size: 20).bold())
                }
                Text(name)
                    .font(.system(size:10).bold())
            }
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 5).fill(.regularMaterial.opacity(0.5)))
            
        }
    }
}
struct HSplit<Content: View> : View {
    @ViewBuilder let content: Content
    var body: some View {
        #if os(macOS)
        HSplitView{content}
#else
        HStack{content}
#endif
    }
}
