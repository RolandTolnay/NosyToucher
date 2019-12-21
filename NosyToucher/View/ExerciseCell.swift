//
//  ExerciseCell.swift
//  NosyToucher
//
//  Created by Roland Tolnay on 16/03/2018.
//  Copyright © 2018 Roland Tolnay. All rights reserved.
//

import UIKit

class ExerciseCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var frequencyLabel: UILabel!
  @IBOutlet weak var durationLabel: UILabel!
  
  @IBOutlet weak var notificationButton: UIButton!
  
  var delegate: ExerciseCellDelegate?
  
  static var reuseIdentifier: String {
    return String(describing: self)
  }
  
  func setupWith(exercise: Exercise) {
    nameLabel.text = exercise.name
    frequencyLabel.text = "\(exercise.frequency) times a day"
    durationLabel.text = "\(exercise.duration / 60) minutes"
  }
  
  func setupWith(notificationToggle: Toggle) {
    switch notificationToggle {
      case .on:
        notificationButton.setImage(UIImage(named: "notification-on"), for: .normal)
      case .off:
        notificationButton.setImage(UIImage(named: "notification-off"), for: .normal)
    }
  }
  
  @IBAction func onNotificationToggleTapped(_ sender: UIButton) {
    delegate?.exerciseCellDidToggleNotification(self)
  }
  
}

protocol ExerciseCellDelegate {
  
  func exerciseCellDidToggleNotification(_ cell: ExerciseCell)
}
