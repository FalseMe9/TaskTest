//
//  BlueButton.swift
//  MultiTaskManager
//
//  Created by Billie H on 13/09/24.
//

import SwiftUI
struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(red: 0, green: 0.5, blue: 1))
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
struct NormalButton:ButtonStyle{
    var width : CGFloat = 150
    var color = Color(.systemBlue)
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: width, height: 35, alignment: .center)
            .background(color)
            .foregroundStyle(.white)
            .buttonStyle(.bordered)
    }
}

struct DefaultButton:ButtonStyle {
    var image = ""
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 20, height: 20)
    }
}
