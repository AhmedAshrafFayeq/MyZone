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
        title = "Areas"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchZonesFromFirebase()
    }
    
    func fetchZonesFromFirebase() {
        let db = Firestore.firestore()
        let collectionRef = db.collection("zones")
        collectionRef.order(by: "code").getDocuments { [weak self] (querySnapshot, error) in
            guard let self else { return }
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if let name = data["name"] as? String, let code = data["code"] as? Int {
                        listOfZones.append(Zone(name: name, code: "\(code)"))
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
        cell.zoneNameLabel.text = "Zone - \(indexPath.row + 1) - \(listOfZones[indexPath.row].name)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let zoneCodeVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.zonesCodeViewController) as? ZoneCodeBottomSheetViewController {
            zoneCodeVC.code = listOfZones[indexPath.row].code
            print(zoneCodeVC.code)
            UserDefaults.standard.set(listOfZones[
                indexPath.row].name, forKey: "zoneName")
            self.navigationController?.pushViewController(zoneCodeVC, animated: true)
        }
    }
}
