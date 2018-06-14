//
//  CompleteTourVC.swift
//  twiths_
//
//  Created by yeon suk choi on 2018. 6. 3..
//  Copyright © 2018년 yeon suk choi. All rights reserved.
//

import UIKit
import Firebase

class CompleteTourVC: UITableViewController {
    
    var userTourList:[UserTourRelation_] = []
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        let dGroup = DispatchGroup()
        guard let currentUser = Auth.auth().currentUser else { return }
        
        db.collection("userTourRelations").whereField("user", isEqualTo: currentUser.uid).whereField("state", isEqualTo: 3).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else if let documents = querySnapshot?.documents {
                for document in documents {
                    dGroup.enter()
                    let userTour = UserTourRelation_()
                    userTour.id = document.documentID
                    userTour.state = document.data()["state"] as! Int
                    userTour.startTime = document.data()["startTime"] as! Date
                    userTour.endTime = document.data()["endTime"] as! Date
                    userTour.user = currentUser.uid
                    
                    self.db.collection("tours").document(document.data()["tour"] as! String).getDocument { query, err in
                        if let err = err {
                            print(err.localizedDescription)
                        } else if let query = query, query.exists, let data = query.data() {
                            let tour = Tour_()
                            tour.id = query.documentID
                            tour.name = data["name"] as! String
                            tour.detail = data["detail"] as! String
                            tour.creator = data["creator"] as! String
                            tour.createDate = data["createDate"] as! Date
                            tour.updateDate = data["updateDate"] as! Date
                            tour.timeLimit = data["timeLimit"] as! Int
                            tour.image = data["image"] as! String
                            userTour.tour = tour
                            self.userTourList.append(userTour)
                            dGroup.leave()
                        } else {
                            print("Document does not exist")
                        }
                    }
                }
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
        return userTourList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompleteTourCell", for: indexPath)

        // Configure the cell...
        guard let textLabel = cell.textLabel else { return cell }
        textLabel.text = userTourList[indexPath.row].tour.name

        return cell
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "TourInfoSegue1" {
            guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
            let dest = segue.destination as! TourInfoMainVC
            dest.ThisTour = userTourList[indexPath.row].tour
            
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
