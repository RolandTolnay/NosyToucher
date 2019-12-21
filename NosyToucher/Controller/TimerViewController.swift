//
//  TimerViewController.swift
//  NosyToucher
//
//  Created by Roland Tolnay on 16/03/2018.
//  Copyright © 2018 Roland Tolnay. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
  
  static var storyboardId: String {
    return String(describing: self)
  }

  @IBOutlet weak var timerLabel: UILabel!
  @IBOutlet weak var startButton: UIButton!
  @IBOutlet weak var finishButton: UIButton!
  
  var exercise: Exercise!
  
  fileprivate var remainingSeconds: TimeInterval = 0.0 {
    didSet {
      let components = componentsFrom(timeInterval: remainingSeconds)
      DispatchQueue.main.async {
        self.timerLabel.text = String(format: "%02i : %02i", components.minutes, components.seconds)
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = exercise.name
    TimerService.shared.delegate = self
    remainingSeconds = exercise.duration
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    TimerService.shared.stopTimer()
    toggleTimerButtons(isRunning: false)
  }
  
  @IBAction func onStartTapped(_ sender: Any) {
    TimerService.shared.startFor(duration: exercise.duration)
    toggleTimerButtons(isRunning: true)
  }
  
  
  @IBAction func onFinishTapped(_ sender: Any) {
    finishTimer()
  }
  
  @IBAction func onCloseTapped(_ sender: UIBarButtonItem) {
    self.dismiss(animated: true, completion: nil)
  }
  
  private func toggleTimerButtons(isRunning: Bool) {
    startButton.isEnabled = !isRunning
    finishButton.isEnabled = isRunning
  }
  
  private func finishTimer() {
    print("\(#function) called")
    
    TimerService.shared.stopTimer()
    toggleTimerButtons(isRunning: false)
    
    // TODO:  - Add elapsed seconds to duration with overflow implementation
    let duration = exercise.duration - remainingSeconds
    HistoryService.shared.logExercise(exercise, duration: duration)
    remainingSeconds = exercise.duration
  }
}

extension TimerViewController: TimerServiceDelegate {
  
  func timerService(_ timerService: TimerService, elapsedSeconds seconds: TimeInterval) {
    // TODO: - Implement overflow after expired
  }
  
  func timerService(_ timerService: TimerService, remainingSeconds seconds: TimeInterval) {
    remainingSeconds = seconds
    speakRemaining(seconds: seconds)
    
    if seconds <= 0 {
      DispatchQueue.main.async {
        self.finishTimer()
        SoundService.playAlarm()
      }
    }
  }
  
  private func speakRemaining(seconds: TimeInterval) {
    guard seconds >= 60 else { return }
    
    if seconds == exercise.duration / 2 && exercise.duration >= 150.0 {
      SoundService.speak(string: Messages.halfwayThrough.rawValue)
    }
    if seconds == 60.0 {
      SoundService.speak(string: Messages.oneMinuteLeft.rawValue)
    }
  }
}
