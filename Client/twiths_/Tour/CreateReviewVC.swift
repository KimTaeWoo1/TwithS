//
//  CreateReviewVC.swift
//  twiths_
//
//  Created by yeon suk choi on 2018. 6. 6..
//  Copyright © 2018년 yeon suk choi. All rights reserved.
//

import UIKit
import Cosmos
import Firebase

class CreateReviewVC: UITableViewController {
    
    var tour = Tour_()
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var StarRating: CosmosView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeBorderToTextField(textField)
        StarRating.settings.fillMode = .half
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        if segue.identifier == "CreateReviewDone" {
            let db = Firestore.firestore()
            let uid = Auth.auth().currentUser?.uid as! String
            db.collection("reviews").addDocument(data: [
                "creator" : uid,
                "name" : Auth.auth().currentUser?.displayName,
                "tour" : tour.id,
                "stars" : StarRating.rating,
                "comment" : textField.text,
                "createTime" : Date()
                ])
        }
    }
    

}
