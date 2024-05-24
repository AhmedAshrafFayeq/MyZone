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
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var code = ""
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
    }
    
    // MARK: - Setup
    
    func setupElements() {
        errorLabel.alpha = 0
        codeTextField.keyboardType = .numberPad
        Utilities.styleTextField(codeTextField)
        Utilities.styleFilledButton(submitButton)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        loadingIndicator.isHidden = true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Actions
    
    @IBAction func didTapSubmit(_ sender: Any) {
        dismissKeyboard()
        showLoading()
        checkCodeValdiation()
    }
    
    
    func checkCodeValdiation() {
        if code == codeTextField.text {
            transitionToZoneDetailsVC()
        } else {
            showError(message: "code error")
        }
        codeCheckingCompleted()
    }
    
    // MARK: - Helper Methods
    
    func showError(message: String) {
        errorLabel.alpha = 1
        errorLabel.text = message
    }
    
    
    func showLoading() {
        submitButton.isEnabled = false
        
        // Show loading indicator
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    func codeCheckingCompleted() {
         // Re-enable the login button
        submitButton.isEnabled = true
         
         // Hide loading indicator
         loadingIndicator.isHidden = true
         loadingIndicator.stopAnimating()
     }
    
    
    func transitionToZoneDetailsVC() {
        if let newViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.zonesDetailsViewController) as? ZoneDetailsViewController {
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
}
