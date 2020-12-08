//
//  TasksListTableViewController.swift
//  Task Tracker
//
//  Created by Tatiana Podlesnykh on 7.12.2020.
//

import UIKit

class TasksListTableViewController: UITableViewController {
    
    var items: [ChecklistItem]
    
    required init?(coder aDecoder: NSCoder) {
        
        items = [ChecklistItem]()
        
        let row0item = ChecklistItem()
      row0item.text = "Walk the dog"
      row0item.checked = false
        items.append(row0item)
      let row1item = ChecklistItem()
      row1item.text = "Brush my teeth"
      row1item.checked = true
        items.append(row1item)
      let row2item = ChecklistItem()
      row2item.text = "Learn iOS development"
      row2item.checked = true
        items.append(row2item)
        
      let row3item = ChecklistItem()
      row3item.text = "Soccer practice"
      row3item.checked = false
        items.append(row3item)
        
      let row4item = ChecklistItem()
      row4item.text = "Eat ice cream"
      row4item.checked = true
        items.append(row4item)
        
      super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let largeTitleFont = [NSAttributedString.Key.font:
                            UIFont(name: "SF Compact Rounded Bold",
                                   size: 35) ??
                            UIFont.boldSystemFont(ofSize: 35)]
        let titleFont = [NSAttributedString.Key.font:
                            UIFont(name: "SF Compact Rounded Semibold",
                                   size: 20) ??
                            UIFont.boldSystemFont(ofSize: 20)]
        let editButtonFont = [NSAttributedString.Key.font:
                                UIFont(name: "SF Compact Rounded Regular",
                                       size: 19) ??
                                UIFont.boldSystemFont(ofSize: 19)]
        
        navigationController?.navigationBar.largeTitleTextAttributes = largeTitleFont
        navigationController?.navigationBar.titleTextAttributes = titleFont
        editButtonItem.setTitleTextAttributes(editButtonFont, for: .normal)
        navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Cell configuration
    
    func configureCheckmark(for cell: UITableViewCell,
                           with item: ChecklistItem) {
      if item.checked {
        cell.accessoryType = .checkmark
    } else {
        cell.accessoryType = .none
      }
    }
    
    func configureText(for cell: UITableViewCell,
                      with item: ChecklistItem) {
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
