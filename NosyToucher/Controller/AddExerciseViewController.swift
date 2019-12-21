//
//  AddExerciseViewController.swift
//  NosyToucher
//
//  Created by Roland Tolnay on 16/03/2018.
//  Copyright © 2018 Roland Tolnay. All rights reserved.
//

import UIKit

class AddExerciseViewController: UIViewController {
  
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var frequencyLabel: UILabel!
  @IBOutlet weak var durationLabel: UILabel!
  @IBOutlet weak var durationSlider: UISlider!
  
  var exercise: Exercise!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  @IBAction func onFrequencyChanged(_ sender: UIStepper) {
    frequencyLabel.text = String(Int(sender.value))
  }
  
  @IBAction func onDurationChanged(_ sender: UISlider) {
    let fixed = roundf(sender.value / 0.5) * 0.5
    durationSlider.setValue(fixed, animated: false)
    
    durationLabel.text = "\(fixed) minutes"
  }
  
  @IBAction func createExercise(_ sender: UIButton) {
    exercise = Exercise(name: nameTextField.text ?? "N/A",
                        frequency: Int(frequencyLabel.text!) ?? 1,
                        duration: TimeInterval(durationSlider.value * 60))
  }
}
