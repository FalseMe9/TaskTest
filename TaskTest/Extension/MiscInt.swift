//
//  MiscInt.swift
//  MultiTaskManager
//
//  Created by Billie H on 14/09/24.
//

import Foundation
extension Int{
    func toTime()->String{
        let hour = self/3600
        let minute = (self/60)%60
        let seconds = self % 60
        return String(format : "%02d:%02d:%02d", hour, minute, seconds)
    }
}
