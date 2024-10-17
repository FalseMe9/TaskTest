//
//  Daily-Warper.swift
//  TaskTest
//
//  Created by Billie H on 18/10/24.
//

import Foundation
import SwiftUI
extension DailyView{
    struct Warper<Content:View>:View{
        @Environment(\.dismiss) var dismiss
        @ViewBuilder let content : Content
        @Bindable var d = daily
        @State private var navigate : DItem?
        var body : some View{
            content
                .customBackground(Image(.back))
                .alert("", isPresented: $d.showAlert){
                    TextField("0", value: $d.input, format: .number)
                    Button("Ok", action: d.action)
                }
                .navigationDestination(item: $d.detail, destination: Setting.init)
                .navigationDestination(item: $d.category){category in
                    TextView(text: category.id)
                }
        }
    }
    struct Combine : Hashable{
        let num : Int
        let item : DItem
    }
}
