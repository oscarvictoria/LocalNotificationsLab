//
//  PendingNotification.swift
//  LocalNotificationsLab
//
//  Created by Oscar Victoria Gonzalez  on 2/20/20.
//  Copyright © 2020 Oscar Victoria Gonzalez . All rights reserved.
//

import Foundation
import UserNotifications

class PendingNotification {
    
    public func getPendingNotifications(completion: @escaping ([UNNotificationRequest])-> ()) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (request) in
            print("there are \(request.count) pending requests")
            completion(request)
        }
    }
    
}
