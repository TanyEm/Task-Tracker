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
        
//        makeFlyingEmoji()
        
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
                        self?.loginWithPincode()
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.message.showMessage(on: self, with: "Biometry unavailable", message: "Your device is not configured for biometric authentication. Enter your pincode")
            }
            loginWithPincode()
        }
        
    }

    func unlockSecretMessage() {
        performSegue(withIdentifier: "OwnerAccess", sender: self)

    }
    
    func loginWithPincode() {
        performSegue(withIdentifier: "EnterPincode", sender: self)
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
        guard let tab = segue.destination as? UITabBarController else { return }
        guard let nav = tab.viewControllers?[0] as? UINavigationController else { return }
        guard let controller = nav.viewControllers.first as? TasksListTableViewController else { return }
        
        if segue.identifier == "GuestAccess" {
            controller.dataManager = GuestTaskManager()
            return
        }
        
        if segue.identifier == "OwnerAccess"{
            controller.dataManager = PrivateTaskManager()
            return
        }
    }
}
