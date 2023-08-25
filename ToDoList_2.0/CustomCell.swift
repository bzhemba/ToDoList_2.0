//
//  SegmentedImportanceControl.swift
//  ToDoList_2.0
//
//  Created by мария баженова on 22.07.2023.
//

import Foundation
import UIKit

class TableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    let cellIdentifier = "TableCell"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableView = UITableView()
        let cellIdentifier = "TableCell"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = indexPath.row == 0 ? "Importance" : "Deadline"
        let deadlineSwitch = UISwitch()
        let segmentedControl = UISegmentedControl(items: ["💤", "⏳", "⌛️"])
        segmentedControl.selectedSegmentIndex = 0
        cell.accessoryView = indexPath.row == 0 ? segmentedControl : deadlineSwitch
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61
    }
}
