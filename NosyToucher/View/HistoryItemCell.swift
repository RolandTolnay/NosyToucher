//
//  HistoryItemCell.swift
//  NosyToucher
//
//  Created by Roland Tolnay on 22/03/2018.
//  Copyright © 2018 Roland Tolnay. All rights reserved.
//

import UIKit

class HistoryItemCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var timestampLabel: UILabel!
  @IBOutlet weak var durationLabel: UILabel!
  
  static var reuseIdentifier: String {
    return String(describing: self)
  }
  
  func setupWith(historyItem: HistoryItem) {
    nameLabel.text = historyItem.exercise.name
    timestampLabel.text = timeString(from: historyItem.timestamp)
    durationLabel.text = durationString(from: historyItem.duration ?? historyItem.exercise.duration)
  }
  
  private func timeString(from timeInterval: TimeInterval) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMM - HH:mm"
    let dateTimestamp = Date(timeIntervalSince1970: timeInterval)
    
    return dateFormatter.string(from: dateTimestamp)
  }
  
  private func durationString(from timeInterval: TimeInterval) -> String {
    let components = componentsFrom(timeInterval: timeInterval)

    return String(format: "%02i : %02i", components.minutes, components.seconds)
  }
}
