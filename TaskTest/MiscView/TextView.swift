//
//  TextView.swift
//  MultiTaskManager
//
//  Created by Billie H on 14/09/24.
//

import SwiftUI

struct TextView: View {
    @State var text : String
    @State private var description : String
    var completion : (()->())?
    var body: some View {
        TextEditor(text: $description)
            .navigationTitle(text)
            .scrollContentBackground(.hidden)
            .background(Image(.light).resizable().ignoresSafeArea().syncBackground())
            .onDisappear(){
                hourly.detail.update(key: text, value: description)
                completion?()
            }
#if os(iOS)
            .if(isIPhone){view in
                view
                .onTapGesture {
                    self.endTextEditing()
                }
            }
        #endif
    }
    init(text: String, completion : (()->())? = nil) {
        self.text = text
        self.description = hourly.detail.get(key: text) ?? ""
        self.completion = completion
    }
}


