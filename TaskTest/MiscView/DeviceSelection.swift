//
//  DeviceSelection.swift
//  TaskTest
//
//  Created by Billie H on 28/11/24.
//

import Foundation
enum MyDevice{
    case iPhone
    case iPad
    case Mac
}
var myDevice : MyDevice{
    #if os(macOS)
    .Mac
#elseif os(iOS)
    isIPad ? .iPad : .iPhone
#endif
}
