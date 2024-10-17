//
//  Branch.swift
//  TaskTest
//
//  Created by Billie H on 01/11/24.
//

import SwiftUI

extension View{
    func `if`<Content: View>(_ conditional : Bool,
                             correct: (Self)->Content,
                             wrong : ((Self)->Content)? = nil) -> some View{
        if conditional{
            AnyView(correct(self))
        }
        else if let wrong{
            AnyView(wrong(self))
        }
        else{
            AnyView(self)
        }
    }
}

