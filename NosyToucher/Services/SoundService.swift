//
//  SoundService.swift
//  NosyToucher
//
//  Created by Roland Tolnay on 22/03/2018.
//  Copyright © 2018 Roland Tolnay. All rights reserved.
//

import Foundation
import AVFoundation
import AudioToolbox

class SoundService {
  
  static func playAlarm() {
    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(1005), nil)
  }
  
  static func speak(string: String) {
    DispatchQueue.main.async {
      let speechSynthesizer = AVSpeechSynthesizer()
      let speechUtterance = AVSpeechUtterance(string: string)
      speechSynthesizer.speak(speechUtterance)
    }
  }
}
