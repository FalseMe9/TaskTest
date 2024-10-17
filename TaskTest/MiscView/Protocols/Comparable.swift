//
//  Comparable.swift
//  TaskTest
//
//  Created by Billie H on 07/12/24.
//

import Foundation

extension String{
    static func < (lhs: String?, rhs: String) -> Bool {
        guard let lhs else{return true}
        return lhs < rhs
    }
    static func < (lhs: String, rhs: String?) -> Bool {
        guard let rhs else{return false}
        return lhs < rhs
    }
}
