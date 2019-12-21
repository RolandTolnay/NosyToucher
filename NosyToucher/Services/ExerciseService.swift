//
//  ExerciseService.swift
//  NosyToucher
//
//  Created by Roland Tolnay on 16/03/2018.
//  Copyright © 2018 Roland Tolnay. All rights reserved.
//

import Foundation

private let storageKey = "storageKey"

class ExerciseService {
  
  static let shared = ExerciseService()
  private init() {
    exercises = ExerciseService.unarchive() ?? [Exercise]()
  }
  
  var exercises: [Exercise] {
    didSet {
      ExerciseService.shared.archive()
    }
  }
  
  func addExercise(_ exercise: Exercise) {
    if !exercises.contains(exercise) {
      exercises.append(exercise)
    }
  }
  
  func deleteExercise(_ exercise: Exercise) {
    for i in 0..<exercises.count {
      if exercises[i] == exercise {
        exercises.remove(at: i)
        break
      }
    }
    NotificationService.shared.deleteExercise(exercise)
  }
}

// MARK: -
// MARK: Coding
// --------------------
extension ExerciseService {
  
  fileprivate func archive() {
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(exercises) {
      UserDefaults.standard.set(encoded, forKey: storageKey)
      UserDefaults.standard.synchronize()
    }
  }
  
  fileprivate static func unarchive() -> [Exercise]? {
    let decoder = JSONDecoder()
    guard let exerciseData = UserDefaults.standard.data(forKey: storageKey),
      let savedExercises = try? decoder.decode([Exercise].self, from: exerciseData) else {
        return nil
    }
    
    return savedExercises
  }
}
