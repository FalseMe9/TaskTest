//
//  WidgetController.swift
//  TaskTest
//
//  Created by Billie H on 29/11/24.
//

#if os(iOS)
import SwiftUI
import ActivityKit

struct TimerAttribute:ActivityAttributes{
    public typealias TimerStatuss = ContentState
    public struct ContentState : Codable, Hashable{
        var endTime : Date
    }
    var timerName : String
}
@Observable class WidgetController {
    var activity: Activity<TimerAttribute>?
    
    func startActivity(name : String, date : Date){
        let attributes = TimerAttribute(timerName: name)
        let state = TimerAttribute.TimerStatuss(endTime: date)
        let activityContent = ActivityContent(state: state, staleDate: date)
        
        activity = try? Activity<TimerAttribute>.request(attributes: attributes, content: activityContent)
    }
    func stopLiveActivity(){
        let state = TimerAttribute.TimerStatuss(endTime: .now)
        Task {
            let content = ActivityContent(state: state, staleDate: .now)
            await activity?.end(content, dismissalPolicy: .immediate)
        }
    }
}

var widget = WidgetController()
#endif
