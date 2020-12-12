//
//  WelcomeViewController.swift
//  Task Tracker
//
//  Created by Tatiana Podlesnykh on 9.12.2020.
//

import UIKit
import LocalAuthentication

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var ownerButton: UIButton!
    @IBOutlet weak var guestButton: UIButton!
    
    let message = AlertMessage()
        
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
    
    @IBAction func moveByFaceID() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in

                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    } else {
                        self?.message.showMessage(on: self!, with: "Ooops! Authentication failed", message: "You could not be verified; please try again")
                    }
                }
            }
        } else {
            message.showMessage(on: self, with: "Biometry unavailable", message: "Your device is not configured for biometric authentication")
        }
        
    }

    func unlockSecretMessage() {
        performSegue(withIdentifier: "OwnerAccess", sender: self)

    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GuestAccess" {
            let tab = segue.destination as? UITabBarController
            let nav = tab!.viewControllers?[0] as? UINavigationController
            let controller = nav!.viewControllers.first as? TasksListTableViewController
                controller!.guestAccess = true
        } else if segue.identifier == "OwnerAccess"{
            if let tab = segue.destination as? UITabBarController,
                let nav = tab.viewControllers?[0] as? UINavigationController,
                let controller = nav.viewControllers.first as? TasksListTableViewController {
                controller.guestAccess = false
            }
        }
    }
}
