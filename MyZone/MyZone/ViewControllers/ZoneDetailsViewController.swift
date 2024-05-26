//
//  ZoneDetailsViewController.swift
//  MyZone
//
//  Created by Ahmed Fayek on 22/05/2024.
//

import UIKit
import Firebase

class ZoneDetailsViewController: UIViewController {
    
    @IBOutlet weak var manPowerTextField: UITextField!
    @IBOutlet weak var equipmentTextField: UITextField!
    @IBOutlet weak var supervisorTextField: UITextField!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
    }
    
    // MARK: - Setup
    
    func setupElements() {
        errorLabel.alpha = 0
        manPowerTextField.keyboardType = .numberPad
        Utilities.styleTextField(manPowerTextField)
        Utilities.styleTextField(equipmentTextField)
        Utilities.styleTextField(supervisorTextField)
        Utilities.styleTextField(commentTextField)
        Utilities.styleFilledButton(loginButton)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        loadingIndicator.isHidden = true

    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    func validateFields() -> String? {
        if manPowerTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            equipmentTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            supervisorTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all the mandatory fields"
        }
        return nil
    }
    
    @IBAction func didTapSubmit(_ sender: Any) {
        dismissKeyboard()
        showLoading()
        if let validationError = validateFields() {
            showError(message: validationError)
            submitCompleted()
        } else {
            if let username = UserDefaults.standard.string(forKey: "username"), let zoneName = UserDefaults.standard.string(forKey: "zoneName"),
                let manPowerText = manPowerTextField.text , let manPower = Int(manPowerText){
                let equipment = equipmentTextField.text ?? ""
                let supervisor = supervisorTextField.text ?? ""
                let comment = commentTextField.text ?? ""
                let myZoneDetails = UserZoneDetails(username: username, selectedZone: zoneName, manPower: manPower, equipment: equipment, supervisorName: supervisor, comment: comment, date: "\(Date())")
                sendMyZoneDetails(zoneDetails: myZoneDetails)
            } else {
                showError(message: "error")
                submitCompleted()
            }
        }
    }
    
    
    func showLoading() {
        loginButton.isEnabled = false
        
        // Show loading indicator
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    func submitCompleted() {
         // Re-enable the login button
        loginButton.isEnabled = true
         
         // Hide loading indicator
         loadingIndicator.isHidden = true
         loadingIndicator.stopAnimating()
     }
    
    
    func showError(message: String) {
        errorLabel.alpha = 1
        errorLabel.text = message
    }
    
    func sendMyZoneDetails(zoneDetails: UserZoneDetails) {
        let data = Utilities.convertObjectToDictionary(object: zoneDetails)
        // Insert the data into the Firestore database under "userSelectedZones" collection
        db.collection("userSelectedZones").addDocument(data: data) { [weak self] error in
            guard let self else { return }
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added")
                showAlert(withMessage: "Data added successfully")
            }
            submitCompleted()
        }
    }
    
    
    func showAlert(withMessage message: String) {
        let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            // Navigate back to the first view controller
            guard let self else { return }
            if let navigationController = navigationController {
                navigationController.popToRootViewController(animated: true)
            }
        })
        
        // Present the alert
        present(alertController, animated: true, completion: nil)
    }
}
