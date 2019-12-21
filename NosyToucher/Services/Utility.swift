//
//  Utility.swift
//  NosyToucher
//
//  Created by Roland Tolnay on 16/03/2018.
//  Copyright © 2018 Roland Tolnay. All rights reserved.
//

import Foundation

/// Converts seconds into minutes and seconds
func componentsFrom(timeInterval: TimeInterval) -> (minutes: Int, seconds: Int) {
  let minutes = Int(timeInterval) / 60 % 60
  let seconds = Int(timeInterval) % 60
  
  return (minutes: minutes, seconds: seconds)
}

let startOfDay = 420
let endOfDay = 1380

/// Converts minutes into hours and minutes, and creates a date object with the values
func dateTimeOfDay(from time: Int) -> Date? {
  let hour = time / 60
  let minute = time % 60
  let components = DateComponents(hour: hour, minute: minute)
  
  return Calendar.current.date(from: components)
}

/// Converts a date expressed in seconds (timeIntervalSince1970) into minutes passed that day
func timeInMinutes(from timestamp: TimeInterval) -> Int {
  let date = Date(timeIntervalSince1970: timestamp)
  let hours = Calendar.current.component(.hour, from: date)
  let minutes = Calendar.current.component(.minute, from: date)
  
  return hours * 60 + minutes
}
