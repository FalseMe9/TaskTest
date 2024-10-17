//
//  Notification.swift
//  MultiTaskManager
//
//  Created by Billie H on 14/09/24.
//
import Foundation
import UserNotifications

class Notification{
    static let notificationCenter = UNUserNotificationCenter.current()
    static func checkForPermission(title: String, body:String, interval : Int){
        notificationCenter.getNotificationSettings(completionHandler:{ settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.notificationCenter.requestAuthorization(options: [.alert, .sound], completionHandler: {didAllow, error in
                    if didAllow{
                        self.dispatchNotification(title: title, body: body, interval: interval)
                    }
                })
            case .denied:
                return
            case .authorized:
                self.dispatchNotification(title: title, body: body, interval: interval)
            default:
                return
            }
        })
    }
    static func dispatchNotification(title:String, body:String, interval:Int){
        let identifier = "identifier"
        let isDaily = true
        let notificationCenter = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        let interval = interval
        content.title = title
        content.body = body
        content.sound = .default
        
        let calendar = Calendar.current
        let date = Date.now.addingTimeInterval(TimeInterval(interval))
        
        var dateComponent = DateComponents(calendar: calendar, timeZone: TimeZone.current)
        
        dateComponent.hour = calendar.component(.hour, from: date)
        dateComponent.minute = calendar.component(.minute, from: date)
        dateComponent.second = calendar.component(.second, from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: isDaily)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        notificationCenter.add(request)
    }
    static func removeNotification(){
        let identifier = "identifier"
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
