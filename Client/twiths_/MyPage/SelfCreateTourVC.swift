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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
