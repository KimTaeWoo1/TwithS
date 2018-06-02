//
//  JjimVC.swift
//  twiths_
//
//  Created by yeon suk choi on 2018. 6. 1..
//  Copyright © 2018년 yeon suk choi. All rights reserved.
//

import UIKit
import Firebase


class JjimVC: UITableViewController {
    var tours:[Tour_] = []
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let uid = Auth.auth().currentUser?.uid as! String
        let dGroup = DispatchGroup()
        
        self.db.collection("userTourRelations").whereField("state", isEqualTo: 1).whereField("user", isEqualTo: uid).addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    dGroup.enter()
                    let tour = Tour_()
                    self.db.collection("tours").document(document.data()["tour"] as! String).addSnapshotListener { (query, error) in
                        if let query = query, query.exists {
                            tour.id = query.documentID
                            tour.name = query.data()!["name"] as! String
                            tour.creator = query.data()!["creator"] as! String
                            tour.timeLimit = query.data()!["timeLimit"] as! Int
                            tour.detail = query.data()!["detail"] as! String
                            tour.createDate = query.data()!["createDate"] as! Date
                            tour.updateDate = query.data()!["updateDate"] as! Date
                            self.tours.append(tour)
                            dGroup.leave()  /// 3
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
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return self.tours.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JjimCell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = self.tours[indexPath.row].name
        cell.detailTextLabel?.text = self.tours[indexPath.row].detail
        
        return cell
    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // 투어에 대한 랜드마크 정보 보기
        if segue.identifier == "ShowLandmark" {
            let dest = segue.destination as! TourInfoMainVC
            dest.ThisTour = tours[self.tableView.indexPathForSelectedRow!.row]
            
        }
    }
    
    
}
