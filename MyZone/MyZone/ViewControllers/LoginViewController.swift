//
//  LoginViewController.swift
//  MyZone
//
//  Created by Ahmed Fayek on 21/05/2024.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var usernamTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
    }
    
    func setupElements() {
        // Set the delegate for text fields
        usernamTextField.delegate = self
        passwordTextField.delegate = self
        errorLabel.alpha = 0
        Utilities.styleTextField(usernamTextField)
        Utilities.styleTextField(passwordTextField)
        passwordTextField.isSecureTextEntry = true
        Utilities.styleFilledButton(loginButton)
        // Add a tap gesture recognizer to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        loadingIndicator.isHidden = true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func validateFields() -> String? {
        if usernamTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        return nil
    }
    
    func checkCredentials(username: String, password: String) {
        let db = Firestore.firestore()
        let collectionRef = db.collection("users")
        
        collectionRef.getDocuments { [weak self] (querySnapshot, error) in
            guard let self else { return }
            if let error = error {
                print("Error getting documents: \(error)")
                showError(message: "Error getting documents: \(error)")
                loginCompleted()
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if let usernameFromDB = data["username"] as? String,
                       let passwordFromDB = data["password"] as? String,
                       let isAdmin = data["isAdmin"] as? Bool {
                        if usernameFromDB == username && passwordFromDB == password {
                            // Username and password match, do something
                            print("Username and password match!")
                            if !isAdmin {
                                clearData()
                                transitionToZonesVC()
                                UserDefaults.standard.set(usernameFromDB, forKey: "username")
                            } else {
                                clearData()
                                transitionToDashboardVC()
                            }
                            loginCompleted()
                            return
                        }
                    }
                }
                // If no match found
                print("Invalid username or password.")
                showError(message:"Invalid username or password.")
                loginCompleted()
            }
        }
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        dismissKeyboard()
        showLoading()
        if let validationError = validateFields() {
            showError(message: validationError)
            loginCompleted()
        } else {
            let username = usernamTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            checkCredentials(username: username, password: password)
        }
    }
    
    func transitionToZonesVC() {
        if let newViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.zonesViewController) as? ZonesViewController {
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    func clearData() {
        usernamTextField.text = ""
        passwordTextField.text = ""
        errorLabel.alpha = 0
    }
    
    func transitionToDashboardVC() {
        //TODO: - Add Admin dashboard VC
        
        if let dashboardVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.dashboardViewController) as? DashboardViewController {
            self.navigationController?.pushViewController(dashboardVC, animated: true)
        }
    }
    
    // MARK: - Helper Methods
    func showError(message: String) {
        errorLabel.alpha = 1
        errorLabel.text = message
    }
    
    func showLoading() {
        loginButton.isEnabled = false
        
        // Show loading indicator
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    func loginCompleted() {
         // Re-enable the login button
         loginButton.isEnabled = true
         
         // Hide loading indicator
         loadingIndicator.isHidden = true
         loadingIndicator.stopAnimating()
     }
}


extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernamTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
