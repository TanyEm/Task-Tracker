//
//  WelcomeViewController.swift
//  Task Tracker
//
//  Created by Tatiana Podlesnykh on 9.12.2020.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var ownerButton: UIButton!
    @IBOutlet weak var guestButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        ownerButton.layer.cornerRadius = 15
        guestButton.layer.cornerRadius = 15
    }
    
    @IBAction func moveAsGuest() {
        performSegue(withIdentifier: "GuestAccess", sender: self)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddTask" {
            let controller = segue.destination as! TasksListTableViewController
            controller.guestAccess = true
        }
    }

}
