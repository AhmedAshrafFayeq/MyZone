//
//  ZonesViewController.swift
//  MyZone
//
//  Created by Ahmed Fayek on 21/05/2024.
//

import UIKit
import Firebase


class ZonesViewController: UIViewController {

    @IBOutlet weak var zonesTableView: UITableView!
    
    var listOfZones = [Zone]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchZonesFromFirebase()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func fetchZonesFromFirebase() {
        let db = Firestore.firestore()
        let collectionRef = db.collection("zones")
        collectionRef.getDocuments { [weak self] (querySnapshot, error) in
            guard let self else { return }
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if let name = data["name"] as? String, let code = data["code"] as? Int {
                        listOfZones.append(Zone(name: name, code: code))
                    }
                }
                // If no match found
                print("Invalid username or password.")
            }
        }
    }
}

class 
