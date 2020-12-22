//
//  TasksListTableViewController.swift
//  Task Tracker
//
//  Created by Tatiana Podlesnykh on 7.12.2020.
//

import UIKit

class TasksListTableViewController: UITableViewController {
    
    var itemsToShow = [TaskListItem]()
    
    var dataManager: DataManager?
    
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
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.rowHeight = UITableView.automaticDimension
        
        guard let data = dataManager else { return }
        itemsToShow = data.getTasks()
        tableView.reloadData()
    }
        
    // MARK: - Cell configuration
    
    func configureCheckmark(for cell: UITableViewCell, with item: TaskListItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            label.text = "✔"
            item.shouldRemind = false
            item.scheduleNotification()
        } else {
            label.text = ""
            item.shouldRemind = true
            item.scheduleNotification()
            
        }
    }
    
    func configureText(for cell: UITableViewCell, with item: TaskListItem) {
        let label = cell.viewWithTag(1000) as! UILabel
            label.text = item.text
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsToShow.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListItem", for: indexPath)
        let item = itemsToShow[indexPath.row]
    
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
            
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            
            let item = itemsToShow[indexPath.row]
            item.toggleChecked()
            do {
                guard let data = dataManager else { return }
                try data.editTask(id: (item.taskID?.uuidString)!, taskItem: item)
            } catch {
                print("Unexpected error: \(error.localizedDescription).")
            }
            
            configureCheckmark(for: cell, with: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let item = itemsToShow[indexPath.row]
        do {
            guard let itemID = item.taskID?.uuidString else {return}
            guard let data = dataManager else { return }
            try data.removeTask(id: itemID)
        } catch {
            print("Unexpected error: \(error.localizedDescription).")
        }
        
        itemsToShow.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! TaskManagerTableViewController
        guard let data = dataManager else { return }
        
        if segue.identifier == "AddTask" {
            controller.switchAccses = data.isPrivateAccess()
            controller.delegate = self
            return
        }
        
        if segue.identifier == "EditTask" {
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.switchAccses = data.isPrivateAccess()
                controller.taskToEdit = itemsToShow[indexPath.row]
            }
            
            controller.delegate = self
            return
        }
    }
}

extension TasksListTableViewController: TaskManagerViewControllerDelegate {
    
    func taskManagerViewController(_ controller: TaskManagerTableViewController, didFinishAdding item: TaskListItem) {
        guard let data = dataManager else { return }
        data.createTask(taskItem: item)
            
        navigationController?.popViewController(animated:true)
    }
    
    func taskManagerViewController(_ controller: TaskManagerTableViewController, didFinishEditing item: TaskListItem) {
        do {
            guard let itemID = item.taskID?.uuidString else {return}
            guard let data = dataManager else { return }
            try data.editTask(id: itemID, taskItem: item)
        } catch {
            print("Unexpected error: \(error.localizedDescription).")
        }
        
        navigationController?.popViewController(animated:true)
    }
    
}
