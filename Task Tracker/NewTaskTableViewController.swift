//
//  NewTaskTableViewController.swift
//  Task Tracker
//
//  Created by Tatiana Podlesnykh on 8.12.2020.
//

import UIKit

protocol NewTaskTableViewControllerDelegate: class {
    func newTaskViewControllerDidCancel(_ controller: NewTaskTableViewController)
    func newTaskViewController(_ controller: NewTaskTableViewController, didFinishAdding item: TaskListItem)
}

class NewTaskTableViewController: UITableViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    weak var delegate: NewTaskTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        navigationItem.largeTitleDisplayMode = .always

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textField.becomeFirstResponder()
        
    }
    
    @IBAction func done() {
        let item = TaskListItem()
        item.text = textField.text!
        item.checked = false
        delegate?.newTaskViewController(self, didFinishAdding: item)
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

extension NewTaskTableViewController: UITextFieldDelegate {
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
