//
//  TimerService.swift
//  NosyToucher
//
//  Created by Roland Tolnay on 16/03/2018.
//  Copyright © 2018 Roland Tolnay. All rights reserved.
//

import Foundation

private let timerKey = "timerKey"

class TimerService {
  
  static let shared = TimerService()
  private init() { }
  
  var delegate: TimerServiceDelegate?
  
  private var timer: Timer? = Timer()
  
  private var isTimerRunning = false
  // TODO:  - Add bool to check if there is a saved timer in userDefaults
  
  private var remaining = 0.0
  
  func startFor(duration: TimeInterval) {
    remaining = duration
    resumeTimer()
  }
  
  func stopTimer() {
    pauseTimer()
    timer = nil
  }
  
  func pauseTimer() {
    timer?.invalidate()
    isTimerRunning = false
  }
  
  func resumeTimer() {
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: runTimer(_:))
    isTimerRunning = true
  }
  
  func changedAppState(_ appState: AppState) {
    switch appState {
      case .background:
        if isTimerRunning {
          runTimerInBackground()
        }
      case .foreground:
        // TODO:  - Check if there is timer saved before calling method
        resumeTimerToForeground()
    }
  }
}

extension TimerService {
  
  fileprivate func runTimer(_ timer: Timer) {
    remaining -= 1
    if remaining >= 0 {
      delegate?.timerService(self, remainingSeconds: remaining)
    } else {
      delegate?.timerService(self, elapsedSeconds: abs(remaining))
    }
  }
  
  fileprivate func runTimerInBackground() {
    NotificationService.shared.scheduleNotification(for: remaining)
    // TODO:  - Save remaining time in local dictionary
  }
  
  fileprivate func resumeTimerToForeground() {
    // TODO:  - Cancel local notification
    //        - Calculate elapsed time in background
    //        - Resume timer with setup
  }
}

protocol TimerServiceDelegate {
  
  func timerService(_ timerService: TimerService, remainingSeconds seconds: TimeInterval)
  
  func timerService(_ timerService: TimerService, elapsedSeconds seconds: TimeInterval)
}
