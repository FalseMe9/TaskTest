//
//  AvoidLoop.swift
//  TaskManager2
//
//  Created by Billie H on 08/10/24.
//

import Foundation

protocol AvoidLoop:AnyObject{
    var avoidLoop : Bool {get set}
}
extension AvoidLoop{
    func AvoidLoop(_ f : ()->()){
        if avoidLoop{
            avoidLoop = false
            f()
            avoidLoop = true
        }
    }
}
