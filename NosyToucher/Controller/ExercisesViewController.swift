//
//  ViewController.swift
//  NosyToucher
//
//  Created by Roland Tolnay on 16/03/2018.
//  Copyright © 2018 Roland Tolnay. All rights reserved.
//

import UIKit

class ExercisesViewController: UIViewController {
  
  @IBOutlet weak var exerciseTableView: UITableView!
  @IBOutlet weak var addExerciseButtonToTopConstraint: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    exerciseTableView.dataSource = self
    exerciseTableView.delegate = self
    exerciseTableView.rowHeight = UITableViewAutomaticDimension
    exerciseTableView.estimatedRowHeight = 127
  }
  
  @IBAction func unwindToExercises(_ sender: UIStoryboardSegue) {
    guard let addExerciseViewController = sender.source as? AddExerciseViewController,
      let exercise = addExerciseViewController.exercise else {
        return
    }
    
    ExerciseService.shared.addExercise(exercise)
    exerciseTableView.reloadData()
  }
}

extension ExercisesViewController: UITableViewDataSource {
  
  private func toggleTableView() {
    if ExerciseService.shared.exercises.isEmpty && !exerciseTableView.isHidden {
      exerciseTableView.isHidden = true
      addExerciseButtonToTopConstraint.constant = view.frame.height / 2 - 124
    } else if exerciseTableView.isHidden && !ExerciseService.shared.exercises.isEmpty {
      exerciseTableView.isHidden = false
      addExerciseButtonToTopConstraint.constant = 24
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    toggleTableView()
    return ExerciseService.shared.exercises.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseCell.reuseIdentifier, for: indexPath) as! ExerciseCell
    let exercise = ExerciseService.shared.exercises[indexPath.row]
    
    cell.delegate = self
    cell.setupWith(exercise: exercise)
    let toggle: Toggle = NotificationService.shared.hasNotification(exercise: exercise) ? .on : .off
    cell.setupWith(notificationToggle: toggle)
    
    return cell
  }
}

extension ExercisesViewController: ExerciseCellDelegate {
  
  func exerciseCellDidToggleNotification(_ cell: ExerciseCell) {
    if let indexPath = exerciseTableView.indexPath(for: cell) {
      let exercise = ExerciseService.shared.exercises[indexPath.row]
      
      if NotificationService.shared.hasNotification(exercise: exercise) {
        NotificationService.shared.deleteExercise(exercise)
        cell.setupWith(notificationToggle: .off)
      } else {
        NotificationService.shared.addExercise(exercise)
        cell.setupWith(notificationToggle: .on)
      }
      
      exerciseTableView.reloadRows(at: [indexPath], with: .none)
    }
  }
}

extension ExercisesViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let exercise = ExerciseService.shared.exercises[indexPath.row]
    
    let storyboard = UIStoryboard.main
    if let timerNavController =
      storyboard.instantiateViewController(withIdentifier: TimerViewController.storyboardId) as? UINavigationController,
      let timerViewController =
      timerNavController.topViewController as? TimerViewController {
      
      timerViewController.exercise = exercise
      present(timerNavController, animated: true, completion: nil)
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let exercise = ExerciseService.shared.exercises[indexPath.row]
      ExerciseService.shared.deleteExercise(exercise)
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
  }
}
