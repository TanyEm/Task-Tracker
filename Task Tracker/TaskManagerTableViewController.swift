//
//  NewTaskTableViewController.swift
//  Task Tracker
//
//  Created by Tatiana Podlesnykh on 8.12.2020.
//

import UIKit

protocol TaskManagerViewControllerDelegate: class {
    func taskManagerViewController(_ controller: TaskManagerTableViewController, didFinishAdding item: TaskListItem)
    func taskManagerViewController(_ controller: TaskManagerTableViewController, didFinishEditing item: TaskListItem)
}

class TaskManagerTableViewController: UITableViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    var itemToEdit: TaskListItem?
    weak var delegate: TaskManagerViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
            title = "Edit your task 😉"
            textField.text = item.text
            doneBarButton.isEnabled = true
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textField.becomeFirstResponder()
        
    }
    
    @IBAction func done() {
        
        if let itemToEdit = itemToEdit {
            itemToEdit.text = textField.text!
            delegate?.taskManagerViewController(self,
                          didFinishEditing: itemToEdit)
          } else {
            let item = TaskListItem()
            item.text = textField.text!
            item.checked = false
            delegate?.taskManagerViewController(self, didFinishAdding: item)
        }
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TaskManagerTableViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in:oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)

        if newText.isEmpty {
            doneBarButton.isEnabled = false
        } else {
            doneBarButton.isEnabled = true
        }

        return true
    }
}
