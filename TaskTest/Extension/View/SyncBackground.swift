//
//  SyncBackground.swift
//  MultiTaskManager
//
//  Created by Billie H on 13/09/24.
//

import SwiftUI

struct SyncBackground : ViewModifier{
    @Environment(\.colorScheme) var colorScheme
    var defaultColor : ColorScheme
    func body(content: Content) -> some View {
        if colorScheme == defaultColor{
            content
        }
        else{content.colorInvert()}
    }
    init(isInverted: Bool){
        self.defaultColor = isInverted ? .dark : .light
    }
}
extension View{
    func syncBackground(isInverted : Bool = false)->some View{
        modifier(SyncBackground(isInverted: isInverted))
    }
}
