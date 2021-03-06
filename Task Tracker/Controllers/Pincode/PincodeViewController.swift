//
//  PincodeViewController.swift
//  Task Tracker
//
//  Created by Tatiana Podlesnykh on 13.12.2020.
//

import UIKit

class PincodeViewController: UIViewController {
    
    @IBOutlet weak var firstCell: UITextField!
    @IBOutlet weak var secondCell: UITextField!
    @IBOutlet weak var thirdCell: UITextField!
    @IBOutlet weak var fourthCell: UITextField!
    @IBOutlet weak var fifthCell: UITextField!
    @IBOutlet weak var sixthCell: UITextField!
    @IBOutlet weak var sentPin: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var buttonMover: ButtonMover?
    var gestureHendler: GesturesHendler?
    var pin = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        gestureHendler = GesturesHendler(view: self.view)
        gestureHendler?.gestureRecognizer()
        
        buttonMover = ButtonMover(view: self.view, constraint: self.bottomConstraint)
        guard let mover = buttonMover else {return}
        
        NotificationCenter.default.addObserver(mover,
                                               selector: #selector(mover.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(mover,
                                               selector: #selector(mover.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(mover,
                                               selector: #selector(mover.keyboardWillChangeFrame),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        firstCell.delegate = self
        secondCell.delegate = self
        thirdCell.delegate = self
        fourthCell.delegate = self
        fifthCell.delegate = self
        sixthCell.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstCell.layer.cornerRadius = 20
        secondCell.layer.cornerRadius = 20
        thirdCell.layer.cornerRadius = 20
        fourthCell.layer.cornerRadius = 20
        fifthCell.layer.cornerRadius = 20
        sixthCell.layer.cornerRadius = 20
        sentPin.layer.cornerRadius = 20
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard let mover = buttonMover else {return}
       
        NotificationCenter.default.removeObserver(mover, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(mover, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(mover, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

    }
    
    @IBAction func moveNext() {
        if pin.count == 5 {
            performSegue(withIdentifier: "PincodeConfirmed", sender: self)
        } else {
            let message = AlertMessage()
            message.showMessage(on: self, with: "Ooops!", message: "Password not correct")
        }
    }

}

extension PincodeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField.text?.count)! < 1 && string.count > 0 {
            switch textField {
            case firstCell:
                secondCell.becomeFirstResponder()
            case secondCell:
                thirdCell.becomeFirstResponder()
            case thirdCell:
                fourthCell.becomeFirstResponder()
            case fourthCell:
                fifthCell.becomeFirstResponder()
            case fifthCell:
                sixthCell.becomeFirstResponder()
            case sixthCell:
                sixthCell.resignFirstResponder()
                print("OTP - \(firstCell.text!)\(secondCell.text!)\(thirdCell.text!)\(fourthCell.text!)\(fifthCell.text!)\(sixthCell.text!)")
                pin = "\(firstCell.text!)\(secondCell.text!)\(thirdCell.text!)\(fourthCell.text!)\(fifthCell.text!)\(sixthCell.text!)"
                if pin.count == 5 {
                    performSegue(withIdentifier: "PincodeConfirmed", sender: self)
                }
            default:
                break
            }
            textField.text = string
            return false

        } else if (textField.text?.count)! >= 1 && string.isEmpty {
            switch textField {
            case sixthCell:
                fifthCell.becomeFirstResponder()
            case fifthCell:
                fourthCell.becomeFirstResponder()
            case fourthCell:
                thirdCell.becomeFirstResponder()
            case thirdCell:
                secondCell.becomeFirstResponder()
            case secondCell:
                firstCell.becomeFirstResponder()
            default:
                break
            }
            textField.text = ""
            return false
        } else if (textField.text?.count)! >= 1 {
            textField.text = string
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let tab = segue.destination as? UITabBarController else { return }
        guard let nav = tab.viewControllers?[0] as? UINavigationController else { return }
        guard let controller = nav.viewControllers.first as? TasksListTableViewController else { return }
        
        if segue.identifier == "PincodeConfirmed" {
            controller.dataManager = PrivateTaskManager()
            return
        }
    }


}
