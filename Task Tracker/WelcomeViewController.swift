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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GuestAccess" {
            if let tab = self.presentingViewController as? UITabBarController,
               let nav = tab.viewControllers?[0] as? UINavigationController,
               let controller = nav.viewControllers.first as? TasksListTableViewController {
                controller.guestAccess = true
            }
        }
    }
}
