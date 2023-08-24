//
//  ViewController.swift
//  ToDoList_2.0
//
//  Created by мария баженова on 18.07.2023.
//

import UIKit
import SnapKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    var delegate: UpdateDataDelegate?

    var text = ""
    var selectedSegmentInd = 0
    var deadlineDate = ""
    var calendarAlpha = 0
    var sentIndex = 0
    var selectedButtonTap = 0
    var changeInd = 0
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let segmentedControl = UISegmentedControl(items: ["💤", "⏳", "⌛️"])
        cell.selectionStyle = .none
        cell.textLabel?.text = indexPath.row == 0 ? "Importance" : "Deadline"
        segmentedControl.selectedSegmentIndex = selectedSegmentInd
        cell.accessoryView = indexPath.row == 0 ? segmentedControl : deadlineSwitch
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
            return cell
        }

        @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
            selectedSegmentInd = sender.selectedSegmentIndex
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    let taskTextField = TaskTextField(placeholder: "What should be done?")
    let whiteView = UIView()
    let tableView = TableView()
    let cellIdentifier = "TableCell"
    let label = UILabel()
    let cancelButton = UIButton()
    let saveButton = UIButton()
    let deadlineSwitch = UISwitch()
    let calendarView = UIDatePicker()
    let dateLabel = UILabel()
    let calendar = Calendar(identifier: .gregorian)
    let currentDate = Date()
    var components = DateComponents()
    let deleteButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        view.addSubview(cancelButton)
        view.addSubview(saveButton)
        tableView.dataSource = self
        tableView.delegate = self
        taskTextField.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        view.addSubview(tableView)
        view.addSubview(taskTextField)
        taskTextField.text = text
        view.addSubview(calendarView)
        view.addSubview(dateLabel)
        dateLabel.text = deadlineDate
        view.addSubview(deleteButton)
        calendarView.alpha = CGFloat(calendarAlpha)
        view.backgroundColor = .secondarySystemBackground
        setupView()
        calendarView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        deadlineSwitch.addTarget(self, action: #selector(switchAction(sender:)), for: .valueChanged)
        cancelButton.addTarget(self, action: #selector(closeWindow), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteAct), for: .touchUpInside)
    }
    @objc func switchAction(sender: UISwitch){
        let decelerationDistance: CGFloat = 331
        if sender.isOn {
            calendarView.alpha = 1
            deleteButton.transform = CGAffineTransform(translationX: 0, y: decelerationDistance)
        } else {
            deleteButton.transform = CGAffineTransform(translationX: 0, y: decelerationDistance)
            calendarView.alpha = 0
            deleteButton.transform = .identity
        }
    }
    @objc func datePickerValueChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let selectedDate = calendarView.date
        let dateString = dateFormatter.string(from: selectedDate)
        dateLabel.text = dateString
    }
    @objc func closeWindow() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func saveAction() {
        guard let task = taskTextField.text, !task.isEmpty else {
            self.taskTextField.shake()
               return
           }
            var imp: Importance
            var date: String? = nil
            if deadlineSwitch.isOn {
            if let dateString = dateLabel.text, !dateString.isEmpty {
                date = dateString
                }
            }

            if selectedSegmentInd == 0 {
                imp = .low
            } else if selectedSegmentInd == 1 {
                imp = .medium
            } else {
                imp = .high
            }
        if selectedButtonTap == 0 {
            addTodoItem(text: task, importance: imp, deadline: date, isCompleted: false)
            delegate?.updateData()
            delegate?.updateLabelInc()
        } else if selectedButtonTap == 1 {
            changeItem(at: changeInd, text: task, importance: imp, deadline: date)
            delegate?.updateData()
        }
        dismiss(animated: true, completion: tableView.reloadData)
        }

    @objc func deleteAct() {
        if fileCache.toDoList[sentIndex].isCompleted == false {
            delegate?.updateLabelDec()
        }
        removeItem(at: sentIndex)
        delegate?.updateData()
        dismiss(animated: true, completion: tableView.reloadData)
    }
}
private extension ViewController {

        func setupView() {
            setupLayout()
        }
        func setupLayout() {
            taskTextField.translatesAutoresizingMaskIntoConstraints=false
            NSLayoutConstraint.activate([
                taskTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                    constant: 72),
                taskTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                taskTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                       constant: 16)
            ])
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.layer.cornerRadius = 5
            tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            NSLayoutConstraint.activate([
                tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                tableView.topAnchor.constraint(equalTo: taskTextField.bottomAnchor, constant: 16),
                tableView.heightAnchor.constraint(equalToConstant: 120),
                tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                   constant: 16)
            ])
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Task"
            label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: 1),
                label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
            cancelButton.translatesAutoresizingMaskIntoConstraints = false
            cancelButton.setTitle("Cancel", for: .normal)
            let myColor = UIColor(red: 181/255, green: 204/255, blue: 240/255, alpha: 1.0)
            cancelButton.setTitleColor(myColor, for: .normal)
            
            NSLayoutConstraint.activate([
                cancelButton.topAnchor.constraint (equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                   constant: 1),
                cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                   constant: 16),
            ])
            
            saveButton.translatesAutoresizingMaskIntoConstraints = false
            saveButton.setTitle("Save", for: .normal)
            saveButton.setTitleColor(myColor, for: .normal)
            NSLayoutConstraint.activate([
                saveButton.topAnchor.constraint (equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                 constant: 1),
                saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                   constant: -16),
            ])
            
            components.calendar = calendar
            components.year = 0
            components.month = 0
            components.year = 0
            components.day = 0
            let minDate = calendar.date(byAdding: components, to: currentDate)!

            calendarView.minimumDate = minDate
            calendarView.calendar = .current
            calendarView.locale = .current
            calendarView.datePickerMode = .date
            calendarView.preferredDatePickerStyle = .inline
            calendarView.backgroundColor = .white
            calendarView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint (equalTo: tableView.bottomAnchor, constant: -5),
            calendarView.centerXAnchor.constraint(equalTo:view.centerXAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                               constant: 16)
            ])
            dateLabel.textColor = .systemBlue
            dateLabel.font = UIFont(name: dateLabel.font.familyName, size: 10)
            dateLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                dateLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: -37),
                dateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                   constant: 36),
                dateLabel.widthAnchor.constraint(equalToConstant: 200),
                dateLabel.heightAnchor.constraint(equalToConstant: 50)
            ])
            deleteButton.setTitle("Delete", for: .normal)
            deleteButton.setTitleColor(.systemRed, for: .normal)
            deleteButton.backgroundColor = .white
            deleteButton.layer.cornerRadius = 5

            deleteButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                deleteButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 16),
                deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                deleteButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                   constant: 16),
                deleteButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
}

extension UIImage {
    func image(alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension NSTextAttachment {
    func setImageHeight(height: CGFloat) {
        guard let image = image else { return }
        let ratio = image.size.width / image.size.height

        bounds = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: ratio * height, height: height)
    }
}
