//
//  TaskWidgetBundle.swift
//  TaskWidget
//
//  Created by Billie H on 29/11/24.
//

import WidgetKit
import SwiftUI

@main
struct TaskWidgetBundle: WidgetBundle {
    var body: some Widget {
        TaskWidget()
        #if os(iOS)
        LiveWidget()
        #endif
    }
}
