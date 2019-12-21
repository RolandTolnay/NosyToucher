//
//  NotifcationService.swift
//  NosyToucher
//
//  Created by Roland Tolnay on 16/03/2018.
//  Copyright © 2018 Roland Tolnay. All rights reserved.
//

import Foundation
import UserNotifications

private let notificationKey = "notificationKey"

private let notificationId = "NTLN"
private let timerNotificationId = "\(notificationId)Timer"

class NotificationService {
  
  static let shared = NotificationService()
  
  static var hasPermissions = false
  
  private init() {
    center.getNotificationSettings { settings in
      if settings.authorizationStatus == .authorized {
        NotificationService.hasPermissions = true
      }
    }
    exercises = NotificationService.unarchive() ?? [Exercise]()
    
  }
  
  private let center = UNUserNotificationCenter.current()
  private var exercises: [Exercise] {
    didSet {
      NotificationService.shared.archive()
    }
  }
  
  func requestPermissions() {
    let options: UNAuthorizationOptions = [ .alert, .sound ]
    
    center.requestAuthorization(options: options) { granted, error in
      if granted {
        NotificationService.hasPermissions = true
      }
    }
  }
  
  func addExercise(_ exercise: Exercise) {
    if !exercises.contains(exercise) {
      exercises.append(exercise)
      scheduleNotification(for: exercise)
    }
  }
  
  func deleteExercise(_ exercise: Exercise) {
    for i in 0..<exercises.count {
      if exercises[i] == exercise {
        removeNotification(for: exercises[i])
        exercises.remove(at: i)
        break
      }
    }
  }
  
  func deleteExerciseNotification(for exercise: Exercise, at timestamp: TimeInterval) {
    let timeOfDayMinutes = timeInMinutes(from: timestamp)
    
    let hoursInDay = endOfDay - startOfDay
    let interval = hoursInDay / exercise.frequency
    for index in 0..<exercise.frequency {
      let part = startOfDay + (index + 1) * interval
      if timeOfDayMinutes <= part {
        let identifier = "\(notificationId)\(exercise.name.removingWhitespaces())-\(index)"
        removeNotification(for: identifier)
        break
      }
    }
  }
  
  func hasNotification(exercise: Exercise) -> Bool {
    return exercises.contains(exercise)
  }
  
  func scheduleNotification(for timerDuration: TimeInterval) {
    let content = UNMutableNotificationContent()
    content.title = Messages.timerNotificationTitle.rawValue
    content.body = Messages.timerNotificationBody.rawValue
    content.sound = UNNotificationSound.default()
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timerDuration, repeats: false)
    let request = UNNotificationRequest(identifier: timerNotificationId,
                                        content: content,
                                        trigger: trigger)
    center.add(request) { error in
      if let error = error {
        print("[ERROR] Couldn't add notification in \(#function): \(error.localizedDescription)")
      }
    }
  }
  
  func updateScheduledNotifications() {
    // TODO:  - Check all pending notifications
    //        - Synchronize with completed exercises
    //        - Create any new notification requests if needed
  }
}

// MARK: -
// MARK: Scheduling
// --------------------
extension NotificationService {
  
  fileprivate func scheduleNotification(for exercise: Exercise) {
    let content = UNMutableNotificationContent()
    content.title = Messages.exerciseNotificationTitle.rawValue
    content.body = Messages.exercisenotificationBody.rawValue + exercise.name
    content.sound = UNNotificationSound.default()
    
    let requests = notificationRequests(for: exercise, withContent: content)
    for request in requests {
      center.add(request) { error in
        if let error = error {
          print("[ERROR] Couldn't add notification in \(#function): \(error.localizedDescription)")
        }
      }
    }
  }
  
  fileprivate func removeNotification(for identifier: String) {
    print("\(#function) with identifier:\(identifier)")
    center.removePendingNotificationRequests(withIdentifiers: [identifier])
    center.removeDeliveredNotifications(withIdentifiers: [identifier])
  }
  
  fileprivate func removeNotification(for exercise: Exercise) {
    var identifiers = [String]()
    for index in 0..<exercise.frequency {
      identifiers.append("\(notificationId)\(exercise.name.removingWhitespaces())-\(index)")
    }
    
    center.removePendingNotificationRequests(withIdentifiers: identifiers)
  }
  
  private func notificationRequests(for exercise: Exercise,
                                    withContent content: UNMutableNotificationContent) -> [UNNotificationRequest] {
    var requests = [UNNotificationRequest]()
    
    let hoursInDay = endOfDay - startOfDay
    let interval = hoursInDay / exercise.frequency
    for index in 0..<exercise.frequency {
      let triggerInMinutes = startOfDay + (index * interval) + interval * 3 / 4
      if let triggerDate = dateTimeOfDay(from: triggerInMinutes) {
        let triggerComponents = Calendar.current.dateComponents([.hour, .minute], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)
        
        let identifier = "\(notificationId)\(exercise.name.removingWhitespaces())-\(index)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        requests.append(request)
      }
    }
    
    return requests
  }
}

// MARK: -
// MARK: Coding
// --------------------
extension NotificationService {
  
  fileprivate func archive() {
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(exercises) {
      UserDefaults.standard.set(encoded, forKey: notificationKey)
      UserDefaults.standard.synchronize()
    }
  }
  
  fileprivate static func unarchive() -> [Exercise]? {
    let decoder = JSONDecoder()
    guard let exerciseData = UserDefaults.standard.data(forKey: notificationKey),
      let savedExercises = try? decoder.decode([Exercise].self, from: exerciseData) else {
        return nil
    }
    
    return savedExercises
  }
}
