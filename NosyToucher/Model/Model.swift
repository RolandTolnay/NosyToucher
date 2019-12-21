//
//  Model.swift
//  NosyToucher
//
//  Created by Roland Tolnay on 16/03/2018.
//  Copyright © 2018 Roland Tolnay. All rights reserved.
//

import Foundation

struct Exercise: Codable {
  
  var name: String
  var frequency: Int
  var duration: TimeInterval
}

extension Exercise: Equatable {
  
  static func ==(lhs: Exercise, rhs: Exercise) -> Bool {
    return lhs.name == rhs.name
  }
}

struct HistoryItem: Codable {
  
  var exercise: Exercise
  var completed: Bool
  var timestamp: TimeInterval
  
  /// Duration of exercise if not completed
  var duration: TimeInterval?
}

extension HistoryItem: Equatable, Comparable {
  
  static func ==(lhs: HistoryItem, rhs: HistoryItem) -> Bool {
    return lhs.exercise == rhs.exercise && lhs.timestamp == rhs.timestamp
  }
  
  static func <(lhs: HistoryItem, rhs: HistoryItem) -> Bool {
    return lhs.timestamp < rhs.timestamp
  }
}

enum Messages: String {
  
  case exerciseNotificationTitle = "Hey, here's a reminder!"
  case exercisenotificationBody = "Don't forget to perform your exercise "
  case timerNotificationTitle = "Time is up"
  case timerNotificationBody = "You are finished!"
  case oneMinuteLeft = "One minute left"
  case halfwayThrough = "You are halfway through"
}

enum AppState {
  
  case background
  case foreground
}

enum Toggle {
  
  case on
  case off
}
