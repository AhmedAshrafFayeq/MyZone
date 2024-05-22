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
    }
    
    // MARK: - Actions
    
    @IBAction func didTapSubmit(_ sender: Any) {
        
        
    }
    
     // MARK: - Helper Methods
     
     func showError(message: String) {
         errorLabel.alpha = 1
         errorLabel.text = message
     }
}
