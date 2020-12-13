//
//  NewTaskTableViewController.swift
//  Task Tracker
//
//  Created by Tatiana Podlesnykh on 8.12.2020.
//

import UIKit
import UserNotifications

protocol TaskManagerViewControllerDelegate: class {
    // Should saves new task or updates data of task
    func taskManagerViewController(_ controller: TaskManagerTableViewController, didFinishAdding item: TaskListItem)
    func taskManagerViewController(_ controller: TaskManagerTableViewController, didFinishEditing item: TaskListItem)
}

class TaskManagerTableViewController: UITableViewController {
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var privacySwitch: UISwitch!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDateField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    weak var delegate: TaskManagerViewControllerDelegate?
    
    var taskToEdit: TaskListItem?
    var switchAccses = true
    var shouldRemind = false
    var dueDate = Date()
    let picker = UIDatePicker()
    var gestureHendler: GesturesHendler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self

        // When a guest comes a switcher must be forbidden
        if !switchAccses {
            privacySwitch.isEnabled = false
            privacySwitch.isOn = false
        }
        
        if !shouldRemind {
            shouldRemindSwitch.isOn = false
        }
        
        
        if let task = taskToEdit {
            title = "Edit your task 😉"
            textView.text = task.text
            doneBarButton.isEnabled = true
            privacySwitch.isOn = task.isPrivate
            shouldRemindSwitch.isOn = task.shouldRemind
            dueDateField.text = dateFormatter(strDate: task.dueDate)
        }
        
        let largeTitleFont = [NSAttributedString.Key.font:
                                UIFont(name: "SF Compact Rounded Bold",
                                       size: 35) ??
                                UIFont.boldSystemFont(ofSize: 35)]
        let titleFont = [NSAttributedString.Key.font:
                            UIFont(name: "SF Compact Rounded Semibold",
                                   size: 20) ??
                            UIFont.boldSystemFont(ofSize: 20)]
        
        navigationController?.navigationBar.largeTitleTextAttributes = largeTitleFont
        navigationController?.navigationBar.titleTextAttributes = titleFont
        
        createPicker()
        gestureHendler = GesturesHendler(view: self.view)
        gestureHendler?.gestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.rowHeight = UITableView.automaticDimension
        textView.becomeFirstResponder()
        
    }
    
    @IBAction func done() {
        
        // Send task new or edited data thru delegate
        if let task = taskToEdit {
            task.text = textView.text!
            task.isPrivate = privacySwitch.isOn
            task.shouldRemind = shouldRemindSwitch.isOn
            task.dueDate = dueDate
            task.scheduleNotification()
            delegate?.taskManagerViewController(self, didFinishEditing: task)
        } else {
            let task = TaskListItem()
            task.text = textView.text!
            task.checked = false
            task.isPrivate = privacySwitch.isOn
            task.shouldRemind = shouldRemindSwitch.isOn
            task.dueDate = dueDate
            task.scheduleNotification()
            delegate?.taskManagerViewController(self, didFinishAdding: task)
        }
    }
    
    @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
        dueDateField.becomeFirstResponder()

        if switchControl.isOn {
          let center = UNUserNotificationCenter.current()
          center.requestAuthorization(options: [.alert, .sound]) {
            granted, error in
            if !granted{
                DispatchQueue.main.async {
                    let message = AlertMessage()
                    message.showMessage(on: self, with: "Ooops!", message: "We have no permission to send reminders. Please, change permission on Settings to get reminders")
                    self.shouldRemindSwitch.isOn = false
                }
            }
          }
        } else {
            dueDateField.resignFirstResponder()
        }
    }
    
    // MARK: - DatePicker and Formatter
    
    func createPicker() {
        
        let currentDate = Date()
        
        dueDateField.inputView = picker
        picker.minimumDate = currentDate
        picker.datePickerMode = .dateAndTime
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        
        picker.addTarget(self, action: #selector(datePickerChanged(date:)), for: .valueChanged)
    }
    
    @objc func datePickerChanged(date: UIDatePicker) {
        if date.isEqual(self.picker) {
            dueDateField.text = dateFormatter(strDate: date.date)
            dueDate = date.date
        } else {
            print(Error.self)
        }
    }
    
    func dateFormatter(strDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let formattedString = dateFormatter.string(from: strDate)
        
        return formattedString
    }
}

extension TaskManagerTableViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {

        let startHeight = textView.frame.size.height
        let calculationHeight = textView.sizeThatFits(textView.frame.size).height

        if startHeight != calculationHeight {

            // The animation should be to prevent jumping while input
            // text but an update to true is needed in the end
            UIView.setAnimationsEnabled(false)
            tableView.beginUpdates()
            tableView.endUpdates()
            UIView.setAnimationsEnabled(true)  // Re-enable animation
        }
    }
}
