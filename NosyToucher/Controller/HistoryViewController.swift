//
//  HistoryViewController.swift
//  NosyToucher
//
//  Created by Roland Tolnay on 16/03/2018.
//  Copyright © 2018 Roland Tolnay. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
  
  @IBOutlet weak var historyTableView: UITableView!
  @IBOutlet weak var noHistoryLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    historyTableView.dataSource = self
    historyTableView.delegate = self
    historyTableView.rowHeight = UITableViewAutomaticDimension
    historyTableView.estimatedRowHeight = 93
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    historyTableView.reloadData()
  }
}

extension HistoryViewController: UITableViewDataSource {
  
  private func toggleTableView() {
    if HistoryService.shared.historyItems.isEmpty && !historyTableView.isHidden {
      historyTableView.isHidden = true
    } else if historyTableView.isHidden && !HistoryService.shared.historyItems.isEmpty {
      historyTableView.isHidden = false
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    toggleTableView()
    return HistoryService.shared.historyItems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: HistoryItemCell.reuseIdentifier, for: indexPath) as! HistoryItemCell
    let historyItem = HistoryService.shared.historyItems[indexPath.row]
    
    cell.setupWith(historyItem: historyItem)
    
    return cell
  }
}

extension HistoryViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let historyItem = HistoryService.shared.historyItems[indexPath.row]
      HistoryService.shared.deleteHistoryItem(historyItem)
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
  }
}
