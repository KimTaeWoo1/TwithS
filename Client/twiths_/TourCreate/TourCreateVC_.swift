
//
//  TourCreate_tempViewController.swift
//  twiths_
//
//  Created by yeon suk choi on 2018. 5. 30..
//  Copyright © 2018년 yeon suk choi. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class TourNameCell: UITableViewCell {
    @IBOutlet weak var tourNameField: UITextField!
}
class TourDetailCell: UITableViewCell {
    @IBOutlet weak var tourDetailField: UITextView!
}
class TourLimitTimeCell: UITableViewCell {
    @IBOutlet weak var limitDay: UITextField!
    @IBOutlet weak var limitHour: UITextField!
    @IBOutlet weak var limitMin: UITextField!
}

class TourCreateVC: UITableViewController, UITextFieldDelegate {
    var landmarks:[Landmark_] = []
    var tour = Tour_()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 5
        }
        return landmarks.count
    }
    
    let cellIdentifier = ["static1", "static2", "static3", "static4", "static5"]
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier[indexPath.row], for: indexPath) as? TourNameCell)!
            case 1:
                cell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier[indexPath.row], for: indexPath) as? TourDetailCell)!
//                makeBorderToTextField(cell.detailTextLabel) as? UILabel)
            case 2:
                cell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier[indexPath.row], for: indexPath) as? TourLimitTimeCell)!
            default:
                cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier[indexPath.row], for: indexPath)
            }
            return cell
        }
        // Configure the cell...
        cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = landmarks[indexPath.row].name
        cell.detailTextLabel?.text = landmarks[indexPath.row].detail
        

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 1 {
            return 230
        }
        if indexPath.section == 0 && indexPath.row == 3 {
            return 200
        }
        return 60
    }
    
    @IBAction func LandmarkCreateToTourCreateSegue(segue:UIStoryboardSegue) {
        
    }
    @IBAction func LandmarkCreateToTourCreateSegue(sender:UIStoryboardSegue){
        if sender.source is LandmarkCreateVC {
            if let senderVC = sender.source as? LandmarkCreateVC {
                landmarks.append(senderVC.landmark)
                print(senderVC.landmark)
            }
            tableView.reloadData()
        }
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
        
        if segue.identifier == "createDone" {
            print("TESET")
            
//                let ref = Database.database().reference()
//                let userID = Auth.auth().currentUser?.uid
//
//                let ref = Database.database().reference()
//                let tourRef = ref.child("Tours").childByAutoId()
//                let landmarkRef = ref.child("Landmarks").childByAutoId()
//                let tour = Tour_()
//                tour.creator = userID!
//                tour.name = TourNameField.text!
//                tour.detail = detailTextField.text
//                tour.image = ImgUrl1.path
//                tour.timeLimit = makeLimitToMinite(day: Int(limitDay.text!)!, hour: Int(limitHour.text!)!, min: Int(limitMin.text!)!)
//
//                tourRef.child("creator").setValue(tour.creator)
//                tourRef.child("name").setValue(tour.name)
//                tourRef.child("timeLimit").setValue(tour.timeLimit)
//                tourRef.child("detail").setValue(tour.detail)
//                tourRef.child("image").setValue(tour.image)
//
//                let landmark = Landmark_()
//                landmark.tour = String(tourRef.key)
//                landmark.name = landmarkNameField.text!
//                landmark.image = ImgUrl2.path
//                landmark.detail = landmarkDetailTextField.text
//
//                landmarkRef.child("tour").setValue(landmark.tour)
//                landmarkRef.child("name").setValue(landmark.name)
//                landmarkRef.child("detail").setValue(landmark.detail)
//                landmarkRef.child("image").setValue(landmark.image)
        }
     }
    
    
}
