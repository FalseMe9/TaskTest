//
//  MiscView.swift
//  TaskManager2
//
//  Created by Billie H on 30/09/24.
//

import SwiftUI

struct Blackline: View {
    var color = Color.black
    var height :CGFloat = 2
    var body: some View {
        Color(color)
            .frame(height: height).frame(maxWidth: .infinity)
            .opacity(0.5)
            .syncBackground()
    }
}

#Preview {
    Blackline()
}
