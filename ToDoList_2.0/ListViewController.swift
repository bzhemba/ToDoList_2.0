//
//  ListViewController.swift
//  ToDoList_2.0
//
//  Created by мария баженова on 29.07.2023.
//

import UIKit
import SnapKit

protocol UpdateDataDelegate {
    func updateData()
    func updateLabelInc()
    func updateLabelDec()
}

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UpdateDataDelegate {
    func updateLabelDec() {
        countItems -= 1
        doneTitle.text = "left to do - \(countItems)"
    }
    func updateLabelInc() {
        countItems += 1
        doneTitle.text = "left to do - \(countItems)"
    }
    func updateData() {
        tableView.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileCache.toDoList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let currentItem = fileCache.toDoList[indexPath.row]
        if (currentItem.deadline != nil) {
            let calendarImage = UIImage(systemName: "calendar")
            let transparentImage = calendarImage?.image(alpha: 0.3)
            let attachment = NSTextAttachment()
            attachment.image = transparentImage
            attachment.setImageHeight(height: 12)
            let calendarSymbolString = NSAttributedString(attachment: attachment)
            let attributedText = NSMutableAttributedString()
            attributedText.append(calendarSymbolString)
            attributedText.append(NSAttributedString(string: " " + currentItem.deadline!))
            let range1 = NSMakeRange(0, 1)
            let range2 = NSMakeRange(0, 1)
            attributedText.addAttribute(NSAttributedString.Key.baselineOffset, value: -11.0, range: range1)
            attributedText.addAttribute(NSAttributedString.Key.baselineOffset, value: -2.0, range: range2)
            cell.detailTextLabel?.attributedText = attributedText

            cell.detailTextLabel?.textColor = .systemGray4
        }
        if currentItem.importance == .high {
            cell.textLabel?.text =  "⌛️" + currentItem.text
        } else if currentItem.importance == .medium {
            cell.textLabel?.text = "⏳" + currentItem.text
        } else {
            cell.textLabel?.text = currentItem.text
        }
        cell.textLabel?.textAlignment = .center
        if (currentItem.isCompleted) == true {
            cell.imageView?.image = UIImage(named: "check.png")
            cell.textLabel?.textColor = .gray
        } else {
            cell.imageView?.image = UIImage(named: "cross.png")
            cell.textLabel?.textColor = .black
        }
        if tableView.isEditing {
            cell.textLabel?.alpha = 0.4
            cell.imageView?.alpha = 0.4
        } else {
            cell.textLabel?.alpha = 1
            cell.imageView?.alpha = 1
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (changeState(at: indexPath.row)) == true {
            tableView.cellForRow(at: indexPath)?.imageView?.image = UIImage(named: "check.png")
            tableView.cellForRow(at: indexPath)?.textLabel?.textColor = .gray
            fileCache.toDoList[indexPath.row].isCompleted = true
            countItems -= 1
            doneTitle.text = "left to do - \(countItems)"
        } else {
            tableView.cellForRow(at: indexPath)?.imageView?.image = UIImage(named: "cross.png")
            countItems += 1
            fileCache.toDoList[indexPath.row].isCompleted = false
            doneTitle.text = "left to do - \(countItems)"
            tableView.cellForRow(at: indexPath)?.textLabel?.textColor = .black
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeItem(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            countItems -= 1
            doneTitle.text = "left to do - \(countItems)"

        }
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt
                   indexPath: IndexPath)-> UISwipeActionsConfiguration?{
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (_, _, completionHandler) in
            completionHandler(true)
            let secondViewController = ViewController()
            secondViewController.delegate = self
            let selectedTodo = fileCache.toDoList[indexPath.row]
            secondViewController.text = selectedTodo.text
            secondViewController.sentIndex = indexPath.row
            if selectedTodo.importance == .low {
                secondViewController.selectedSegmentInd = 0
            } else if selectedTodo.importance == .medium {
                secondViewController.selectedSegmentInd = 1
            } else {
                secondViewController.selectedSegmentInd = 2
            }
            if selectedTodo.deadline != nil {
                secondViewController.deadlineDate = selectedTodo.deadline!
                secondViewController.deadlineSwitch.isOn = true
                secondViewController.calendarAlpha = 1
                secondViewController.switchAction(sender: secondViewController.deadlineSwitch)
            }
            secondViewController.selectedButtonTap = 1
            secondViewController.changeInd = indexPath.row
            self.present(secondViewController, animated: true, completion: nil)
            }
        editAction.backgroundColor = .gray
        editAction.image = UIImage(systemName: "info.circle.fill")

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete")
        { [self] (_, _, completionHandler) in
                completionHandler(true)
                removeItem(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            if fileCache.toDoList[indexPath.row].isCompleted == false {
                countItems -= 1
                self.doneTitle.text = "left to do - \(countItems)"
            }
                tableView.reloadData()
            }

            let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
            return configuration
    }

    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        moveItem(fromIndex: fromIndexPath.row, toIndex: to.row)
        tableView.reloadData()

    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            return .none
        } else {
            return .delete
        }
    }
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    let tableView = UITableView()
    let addButton: UIButton = UIButton(type: UIButton.ButtonType.custom)
    let tasksTitle = UILabel()
    let cleanButton: UIButton = UIButton(type: UIButton.ButtonType.custom)
    let toDoTitle = UILabel()
    let todoImage = UIImageView()
    let doneTitle = UILabel()
    let editButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        fileCache.loadFromFile(from: url) { [weak self] todoList in
                guard let todoList = todoList else { return }
                fileCache.toDoList = todoList
                for todo in todoList {
                    if !todo.isCompleted {
                        countItems += 1
                    }
                }
                self?.doneTitle.text = "left to do - \(countItems)"
                self?.tableView.reloadData()
            }

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.dataSource = self
        tableView.delegate = self
        setupView()
        addButton.addTarget(self, action: #selector(buttonTap(sender:)), for: .touchUpInside)
        cleanButton.addTarget(self, action: #selector(clearTable), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editTable(sender:)), for: .touchUpInside)
    }
    @objc func buttonTap(sender: UIButton) {
        let secondViewController = ViewController()
        secondViewController.delegate = self
        secondViewController.deleteButton.isHidden = true
        secondViewController.selectedButtonTap = 0
        present(secondViewController, animated: true, completion: nil)
    }
    @objc func clearTable() {
        let alertController = UIAlertController(title: "Do you want to clear to do list?",
                                                message: nil, preferredStyle: .alert)
        let alertAction1 = UIAlertAction(title: "Cancel", style: .destructive) {(alert) in
        }
        let alertAction2 = UIAlertAction(title: "Clear", style: .default) { (alert) in
            fileCache.toDoList.removeAll()
            fileCache.saveToFile(to: url)
            countItems = 0
            self.doneTitle.text = "left to do - \(countItems)"
            self.tableView.reloadData()
        }
        alertController.addAction(alertAction1)
        alertController.addAction(alertAction2)
        present(alertController, animated: true, completion: nil)
    }
    @objc func editTable(sender: UIButton) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        if sender.currentTitle == "edit" {
            sender.setTitle("cancel", for: .normal)
          } else {
            sender.setTitle("edit", for: .normal)
          }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        self.tableView.reloadData()
        }
    }
}
private extension ListViewController {
    func setupView() {
        view.addSubview(tableView)
        view.addSubview(addButton)
        view.addSubview(doneTitle)
        view.addSubview(toDoTitle)
        view.addSubview(cleanButton)
        view.addSubview(editButton)
        view.addSubview(todoImage)
        view.backgroundColor = .secondarySystemBackground
        setupLayout()
    }
    func setupLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 10
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        NSLayoutConstraint.activate([
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                               constant: 16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        addButton.translatesAutoresizingMaskIntoConstraints = false
        let imageAdd = UIImage(named: "plus.png", in: Bundle.main, compatibleWith: nil)
        addButton.setImage(imageAdd, for: .normal)
        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -150),
            addButton.widthAnchor.constraint(equalToConstant: 120),
            addButton.heightAnchor.constraint(equalToConstant: 150)
        ])
        todoImage.translatesAutoresizingMaskIntoConstraints = false
        todoImage.image = UIImage(named: "todo.png")
        NSLayoutConstraint.activate([
            todoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -5),
            todoImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: -15),
            todoImage.widthAnchor.constraint(equalToConstant: 150),
            todoImage.heightAnchor.constraint(equalToConstant: 150)
        ])
        cleanButton.translatesAutoresizingMaskIntoConstraints = false
        let imageTrash = UIImage(named: "trash.png", in: Bundle.main, compatibleWith: nil)
        cleanButton.setImage(imageTrash, for: .normal)
        NSLayoutConstraint.activate([
            cleanButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -4),
            cleanButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -12),
            cleanButton.widthAnchor.constraint(equalToConstant: 60),
            cleanButton.heightAnchor.constraint(equalToConstant: 75)
        ])
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.setTitle("edit", for: .normal)
        editButton.setTitle("cancel", for: .selected)
        let myColor2 = UIColor(red: 240/255, green: 156/255, blue: 180/255, alpha: 1.0)
        editButton.setTitleColor(myColor2, for: .normal)
        editButton.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .regular)
        NSLayoutConstraint.activate([
            editButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            editButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 90)
        ])
        doneTitle.translatesAutoresizingMaskIntoConstraints = false
        doneTitle.text = "left to do - \(countItems)"
        doneTitle.font = doneTitle.font.withSize(15)
        doneTitle.textColor = .systemGray
        NSLayoutConstraint.activate([
            doneTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 93),
            doneTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
}
