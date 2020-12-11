//
//  GesturesHendler.swift
//  Task Tracker
//
//  Created by Tatiana Podlesnykh on 12.12.2020.
//

import UIKit

class GesturesHendler {
    var view: UIView?
    var data = ""
    
    init(view: UIView) {
        self.view = view
    }
    
    func gestureRecognizer() {
        // hide keyboad when user taps on view
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view?.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view?.endEditing(true)
    }

}
