//
//  ContentData.swift
//  TaskManager
//
//  Created by Billie H on 17/10/24.
//

import Firebase
import SwiftUI

@Observable
class ContentData{
    var currentDate = Date.now
    var dateString : String{currentDate.string}
    var days = ["Sunday",
                "Monday",
                "Tuesday",
                "Wednesday",
                "Thursday",
                "Friday",
                "Saturday"
    ]
    var index : Int{
        get {currentDate.dayNumberOfWeek()}
        set {
            currentDate.addDay(newValue-index)
        }
    }
    var today : String{days[index]}
    var categories : [Category] = [.school,
                                   .spiritual,
                                   .personal,
                                   .social,
                                   .home,]
    
    var colors = ["blue", "red", "green", "yellow", "orange", "white", "black"]
    var categoryDict = CustomDictionary(name: "Categories")
    var linkDict = CustomDictionary(name: "Links")
}
@Observable
class Category: PSync, Hashable{
    var avoidLoop = true
    static var type = "Category"
    var id = "Home"
    var path : DocumentReference{
        db.collection(Category.type).document(id)
    }
    
    
    var colorStr = "blue" {didSet{upload()}}
    var icon : String? {didSet{upload()}}
    init(name: String = "Home", color: String? = nil) {
        self.id = name
        observe(){
            guard let color else{return}
            self.colorStr = color
        }
    }
    var color : Color {Color[colorStr]}
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    enum CodingKeys: CodingKey {
        case _colorStr
        case _icon
    }
    func sync(data : Category){
        colorStr = data.colorStr
        icon = data.icon
    }
    static func == (lhs:Category, rhs:Category)->Bool{
        lhs.id == rhs.id
    }
    static let home  = Category(name: "Home", color: "yellow")
    static let school = Category(name: "School", color: "blue")
    static let spiritual = Category(name: "Spiritual", color: "greem")
    static let social = Category(name: "Social", color: "red")
    static let personal = Category(name: "To-Do", color: "white")
}
extension String{
    var toCategory : Category{
        mData.categories.first(where: {$0.id == self}) ?? .home
    }
}
var mData = ContentData()

