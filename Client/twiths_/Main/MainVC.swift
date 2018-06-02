//
//  ProceedingVC.swift
//  twiths_
//
//  Created by ㅇㅇ on 2018. 5. 25..
//
// 임시로 이전 데이터베이스 양식을 이용하므로 나중에 수정이 필요함.

import UIKit
import Firebase

class CurrentProceedTourCell : UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var leftTimeLabel: UILabel!
    @IBOutlet weak var currentProceedLabel: UILabel!
    
    @IBOutlet weak var progressBar: UIView!
}

class MainVC: UITableViewController {
    
    var proceedTours:[UserTourRelation_] = []
    
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dGroup = DispatchGroup()
        
        db.collection("userTourRelations").whereField("user", isEqualTo: self.uid).whereField("state", isEqualTo: 2).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else if let documents = querySnapshot?.documents {
                for document in documents {
                    dGroup.enter()
                    print(document.documentID)
                    let utr = UserTourRelation_()
                    utr.id = document.documentID
                    utr.state = document.data()["state"] as! Int
                    utr.startTime = document.data()["startTime"] as! Date
                    utr.user = self.uid!
                    
                    self.db.collection("tours").document(document.data()["tour"] as! String).getDocument { query, err in
                        if let err = err {
                            print(err.localizedDescription)
                        } else if let query = query, query.exists {
                            let tour = Tour_()
                            tour.id = query.documentID
                            tour.name = query.data()!["name"] as! String
                            tour.detail = query.data()!["detail"] as! String
                            tour.creator = query.data()!["creator"] as! String
                            tour.createDate = query.data()!["createDate"] as! Date
                            tour.updateDate = query.data()!["updateDate"] as! Date
                            tour.timeLimit = query.data()!["timeLimit"] as! Int
                            utr.tour = tour
                            self.proceedTours.append(utr)
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
        
        // 사용자가 진행 중인 투어의 개수를 구한다.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        // 사용자가 진행 중인, 각각의 투어에 있는 랜드마크의 개수를 구한다.
        return proceedTours.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentTourCell", for: indexPath) as! CurrentProceedTourCell
        
        cell.nameLabel?.text = String(proceedTours[indexPath.row].tour.name)
        return cell
    }
    
    @IBAction func TourListToTourCreate(segue:UIStoryboardSegue){
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
        if segue.identifier == "tour_detail" {
            let dest = segue.destination as! LandmarkListVC
            dest.userTourRelation = proceedTours[self.tableView.indexPathForSelectedRow!.row]
//            let selindex = self.tableView.indexPathForSelectedRow?.section as! Int
//            dest.userTourRelation = proceedTours[selindex]
        }
    }
    
}
