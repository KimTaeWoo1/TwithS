//
//  SelfCreateTourVC.swift
//  twiths_
//
//  Created by yeon suk choi on 2018. 6. 3..
//  Copyright © 2018년 yeon suk choi. All rights reserved.
//

import UIKit
import Firebase

class SelfCreateTourVC: UITableViewController {
    var tours:[Tour_] = []
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid as! String

    override func viewDidLoad() {
        super.viewDidLoad()
        let dGroup = DispatchGroup()
        
        self.db.collection("tours").whereField("creator", isEqualTo: self.uid).getDocuments { querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else if let documents = querySnapshot?.documents {
                for document in documents {
                    dGroup.enter()
                    let tour = Tour_()
                    tour.id = document.documentID
                    tour.name = document.data()["name"] as! String
                    tour.creator = self.uid
                    tour.timeLimit = document.data()["timeLimit"] as! Int
                    tour.detail = document.data()["detail"] as! String
                    tour.createDate = document.data()["createDate"] as! Date
                    tour.updateDate = document.data()["updateDate"] as! Date
                    self.tours.append(tour)
                    dGroup.leave()
                }
            } else {
                print("ERROR")
            }
            dGroup.notify(queue: .main) {   //// 4
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tours.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelfCreateTourCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = tours[indexPath.row].name

        return cell
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "TourInfoSegue2" {
            let dest = segue.destination as! TourInfoMainVC
            dest.ThisTour = tours[self.tableView.indexPathForSelectedRow!.row]
            
            // 랜드마크 데이터베이스에서 tour의 값이 ThisTour의 ID와 일치하는 것만 랜드마크 리스트에 추가
            let ref = db.collection("landmarks").whereField("tour", isEqualTo: dest.ThisTour.id).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let landmark = Landmark_()
                        landmark.id = document.documentID
                        landmark.detail = document.data()["detail"] as! String
                        landmark.image = document.data()["image"] as! String
                        landmark.name = document.data()["name"] as! String
                        landmark.tour.id = document.data()["tour"] as! String
                        dest.landmarkList.append(landmark)
                        dest.tableView.reloadData()
                    }
                }
            }
        }
    }
    

}
