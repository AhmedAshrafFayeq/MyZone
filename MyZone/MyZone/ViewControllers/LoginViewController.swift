//
//  LoginViewController.swift
//  MyZone
//
//  Created by Ahmed Fayek on 21/05/2024.
//

import UIKit
import Firebase
import FirebaseFirestore

class LoginViewController: UIViewController {

    @IBOutlet weak var usernamTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupElements()
    }
    
    func setupElements() {
        errorLabel.alpha = 0
        Utilities.styleTextField(usernamTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
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
                                transitionToZonesVC()
                            } else {
                                
                            }
                            return
                        }
                    }
                }
                // If no match found
                print("Invalid username or password.")
            }
        }
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        let username = usernamTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        checkCredentials(username: username, password: password)
    }
    
    func transitionToZonesVC() {
        let zonesVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.zonesViewController) as? ZonesViewController
        
        view?.window?.rootViewController = zonesVC
        view.window?.makeKeyAndVisible()
    }
    
}
