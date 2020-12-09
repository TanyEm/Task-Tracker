//
//  TasksListTableViewController.swift
//  Task Tracker
//
//  Created by Tatiana Podlesnykh on 7.12.2020.
//

import UIKit

class TasksListTableViewController: UITableViewController {
    
    var items: [TaskListItem]
    
    required init?(coder aDecoder: NSCoder) {
        
        items = [TaskListItem]()
        
        let row0item = TaskListItem()
      row0item.text = "Create an app"
      row0item.checked = false
        items.append(row0item)
      let row1item = TaskListItem()
      row1item.text = "Add a table"
      row1item.checked = true
        items.append(row1item)
      let row2item = TaskListItem()
      row2item.text = "Add a checkboks to each row"
      row2item.checked = true
        items.append(row2item)
        
      let row3item = TaskListItem()
      row3item.text = "Add model for a task"
      row3item.checked = false
        items.append(row3item)
        
      super.init(coder: aDecoder)
    }

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
        
    // MARK: - Cell configuration
    
    func configureCheckmark(for cell: UITableViewCell, with item: TaskListItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        if item.checked {
            label.text = "✔"
        } else {
            label.text = ""
        }
    }
    
    func configureText(for cell: UITableViewCell, with item: TaskListItem) {
      let label = cell.viewWithTag(1000) as! UILabel
      label.text = item.text
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListItem", for: indexPath)
                
          let item = items[indexPath.row]
          configureText(for: cell, with: item)
          configureCheckmark(for: cell, with: item)
          return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            
            let item = items[indexPath.row]
                item.toggleChecked()
                configureCheckmark(for: cell, with: item)
          }
          tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddTask" {
            let controller = segue.destination as! TaskManagerTableViewController
            controller.delegate = self
        } else if segue.identifier == "EditTask" {
            let controller = segue.destination as! TaskManagerTableViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                  controller.itemToEdit = items[indexPath.row]
                }
        }
    }

}

extension TasksListTableViewController: TaskManagerViewControllerDelegate {
    
    func taskManagerViewControllerDidCancel(_ controller: TaskManagerTableViewController) {
        navigationController?.popViewController(animated:true)
    }
    
    func taskManagerViewController(_ controller: TaskManagerTableViewController, didFinishAdding item: TaskListItem) {
        let newRowIndex = items.count
        items.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated:true)
    }
    func taskManagerViewController(_ controller: TaskManagerTableViewController, didFinishEditing item: TaskListItem) {
        if let index = items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
              configureText(for: cell, with: item)
            }
        }
          navigationController?.popViewController(animated:true)
    }

}
