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
                    if let name = data["name"] as? String, let code = data["code"] as? String {
                        listOfZones.append(Zone(name: name, code: code))
                    }
                }
                zonesTableView.reloadData()
            }
        }
    }
}


//MARK: - TableView delegate & data source methods
extension ZonesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "NMA Municipal Boundry"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listOfZones.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ZonesTableViewCell
        cell.zoneNameLabel.text = "Zone - \(indexPath.row) - \(listOfZones[indexPath.row].name)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}
