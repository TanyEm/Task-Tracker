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
        
        makeFlyingEmoji()
        
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
            let reason = "Please, identify yourself"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in

                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    } else {
                        self?.message.showMessage(on: self!, with: "Ooops! Authentication failed", message: "You could not be verified. Please try again")
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.message.showMessage(on: self, with: "Biometry unavailable", message: "Your device is not configured for biometric authentication. Enter your pincode")
            }
            performSegue(withIdentifier: "EnterPincode", sender: self)
        }
        
    }

    func unlockSecretMessage() {
        performSegue(withIdentifier: "OwnerAccess", sender: self)

    }
    
    // MARK: - Animation
    
    func makeFlyingEmoji() {
        let emitter = Emitter.get()
        emitter.emitterPosition = CGPoint(x: view.frame.width/2,
                                          y: view.frame.maxY)
        emitter.emitterSize = CGSize(width: view.frame.width,
                                     height: 100)
        view.layer.insertSublayer(emitter, at: 0)
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
