//
//  SwiftUIView.swift
//  TaskTest
//
//  Created by Billie H on 25/10/24.
//

import SwiftUI
extension View{
    func customBackground(_ image : Image, isInverted:Bool=false) -> some View{
        self.background(image
            .resizable()
            .ignoresSafeArea()
            .syncBackground(isInverted: isInverted)
        )
    }
}
struct CustomBackground : ViewModifier {
    var image : String
    var isInverted:Bool
    func body(content: Content) -> some View {
        content.background(
            Image(image)
                .resizable()
                .ignoresSafeArea()
                .syncBackground(isInverted: isInverted)
        )
    }
}
