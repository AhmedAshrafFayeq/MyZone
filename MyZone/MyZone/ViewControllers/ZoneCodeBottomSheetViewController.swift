//
//  ZoneCodeBottomSheetViewController.swift
//  MyZone
//
//  Created by Ahmed Fayek on 22/05/2024.
//

import UIKit

class ZoneCodeBottomSheetViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    var code = ""
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
    }
    
    // MARK: - Setup
    
    func setupElements() {
        errorLabel.alpha = 0
        Utilities.styleTextField(codeTextField)
        Utilities.styleFilledButton(submitButton)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Actions
    
    @IBAction func didTapSubmit(_ sender: Any) {
        dismissKeyboard()
        checkCodeValdiation()
    }
    
    func checkCodeValdiation() {
        print(code)
        print(codeTextField.text)
        if code == codeTextField.text {
            transitionToZoneDetailsVC()
        }
    }
    
     // MARK: - Helper Methods
     
     func showError(message: String) {
         errorLabel.alpha = 1
         errorLabel.text = message
     }
    
    
    func transitionToZoneDetailsVC() {
        if let newViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.zonesDetailsViewController) as? ZoneDetailsViewController {
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
}
