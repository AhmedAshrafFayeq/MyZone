//
//  ZoneDetailsViewController.swift
//  MyZone
//
//  Created by Ahmed Fayek on 22/05/2024.
//

import UIKit

class ZoneDetailsViewController: UIViewController {
    
    @IBOutlet weak var manPowerTextField: UITextField!
    @IBOutlet weak var equipmentTextField: UITextField!
    @IBOutlet weak var supervisorTextField: UITextField!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
    }
    
    // MARK: - Setup
    
    func setupElements() {
        errorLabel.alpha = 0
        Utilities.styleTextField(manPowerTextField)
        Utilities.styleTextField(equipmentTextField)
        Utilities.styleTextField(supervisorTextField)
        Utilities.styleTextField(commentTextField)
        Utilities.styleFilledButton(loginButton)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showError(message: String) {
        errorLabel.alpha = 1
        errorLabel.text = message
    }

}
