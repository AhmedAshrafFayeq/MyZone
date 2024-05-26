//
//  DashboardViewController.swift
//  MyZone
//
//  Created by Ahmed Fayek on 26/05/2024.
//

import UIKit
import Firebase

class DashboardViewController: UIViewController {

    @IBOutlet weak var usersTableView: UITableView!
    
    var listOfUsers = [UserZoneDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsersFromFirebase()
    }
    
    func fetchUsersFromFirebase() {
        let db = Firestore.firestore()
        let collectionRef = db.collection("userSelectedZones")
        collectionRef.getDocuments { [weak self] (querySnapshot, error) in
            guard let self else { return }
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if let name = data["username"] as? String, let selectedZone = data["selectedZone"] as? String,
                       let manPower = data["manPower"] as? Int, let supervisorName = data["supervisorName"] as? String,
                       let equipment = data["equipment"] as? String, let comment = data["comment"] as? String,
                       let date = data["date"] as? String{
                        
                        listOfUsers.append(UserZoneDetails(username: name, selectedZone: selectedZone, manPower: manPower, equipment: equipment, supervisorName: supervisorName, comment: comment, date: date))
                    }
                }
                usersTableView.reloadData()
            }
        }
    }
}

//MARK: - TableView delegate & data source methods
extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Today Users Zone"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listOfUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserTableViewCell
        cell.usernameLabel.text = "username: \(listOfUsers[indexPath.row].username)"
        cell.zoneLabel.text = "zone: \(listOfUsers[indexPath.row].selectedZone)"
        cell.supervisorNameLabel.text = "supervisor: \(listOfUsers[indexPath.row].supervisorName)"
        cell.manPowerLabel.text = "man power: \(listOfUsers[indexPath.row].manPower)"
        cell.equipmentLabel.text = "equipment: \(listOfUsers[indexPath.row].equipment)"
        cell.commentLabel.text = "comment: \(listOfUsers[indexPath.row].comment)"
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
