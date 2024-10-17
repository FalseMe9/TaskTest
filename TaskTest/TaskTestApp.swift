//
//  TaskManager2App.swift
//  TaskManager2
//
//  Created by Billie H on 14/09/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseDatabase

let db = Firestore.firestore()
let ref = Database.database().reference()
var avoidLoop = true
@main
struct TaskTestApp: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
