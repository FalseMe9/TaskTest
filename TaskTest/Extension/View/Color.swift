//
//  Color.swift
//  TaskTest
//
//  Created by Billie H on 01/11/24.
//

import SwiftUI

extension Color {
    static subscript(name: String) -> Color {
        switch name {
            case "green":
                return Color.green
        case "orange":
            return .orange
        case "blue":
            return .blue
            case "white":
                return Color.white
            case "black":
                return Color.black
            default:
                return Color.accentColor
        }
    }
}
