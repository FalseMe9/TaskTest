//
//  MiscStr.swift
//  MultiTaskManager
//
//  Created by Billie H on 13/09/24.
//

import Foundation
extension String{
    func trim()-> String{
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    func simpleHash()->Int{
        self.trim().hashValue
    }
    func toInt()->Int{
        return Int(self.trim()) ?? 0
    }
    func split(div: String)->[String]{
        self.split(separator: div).map({String($0)})
    }
    static func random(length: Int = 20) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
extension Int{
    var string : String{
        return String(self)
    }
}
