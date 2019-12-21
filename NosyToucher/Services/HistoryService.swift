//
//  HistoryService.swift
//  NosyToucher
//
//  Created by Roland Tolnay on 21/03/2018.
//  Copyright © 2018 Roland Tolnay. All rights reserved.
//

import Foundation

private let historyKey = "historyKey"

class HistoryService {
  
  static let shared = HistoryService()
  private init() {
    historyItems = HistoryService.unarchive() ?? [HistoryItem]()
  }
  
  var historyItems: [HistoryItem] {
    didSet {
      HistoryService.shared.archive()
      print("historyItems didSet with \(historyItems)")
    }
  }
  
  func logExercise(_ exercise: Exercise, duration: TimeInterval) {
    let timestamp = Date().timeIntervalSince1970
    let historyItem = HistoryItem(exercise: exercise,
                                  completed: duration >= exercise.duration,
                                  timestamp: timestamp,
                                  duration: duration)
    historyItems.append(historyItem)
    historyItems.sort {
      return $0.timestamp > $1.timestamp
    }
    
    if duration == exercise.duration {
      NotificationService.shared.deleteExerciseNotification(for: exercise, at: timestamp)
    }
  }
  
  func deleteHistoryItem(_ historyItem: HistoryItem) {
    for i in 0..<historyItems.count {
      if historyItems[i] == historyItem {
        historyItems.remove(at: i)
        break
      }
    }
  }
}

// MARK: -
// MARK: Coding
// --------------------
extension HistoryService {
  
  // TODO:  - Add coding functionality into general protocol
  
  fileprivate func archive() {
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(historyItems) {
      UserDefaults.standard.set(encoded, forKey: historyKey)
      UserDefaults.standard.synchronize()
    }
  }
  
  fileprivate static func unarchive() -> [HistoryItem]? {
    let decoder = JSONDecoder()
    guard let historyItemData = UserDefaults.standard.data(forKey: historyKey),
      let savedHistoryItems = try? decoder.decode([HistoryItem].self, from: historyItemData) else {
        return nil
    }
    
    return savedHistoryItems
  }
}
