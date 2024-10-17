//
//  Daily-Item-Misc.swift
//  TaskTest
//
//  Created by Billie H on 02/11/24.
//

import Foundation
extension DItem{
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    var index : Int{
        group.items.firstIndex(of: self) ?? -1
    }
    func uploadName(){
        AvoidLoop{
            if !name.isEmpty{
                path.setData(["name":name], merge: true)
            }
        }
    }
}
