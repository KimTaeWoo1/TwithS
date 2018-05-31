//
//  TourInfoMainVC.swift
//  twiths_
//
//  Created by yeon suk choi on 2018. 5. 29..
//  Copyright © 2018년 Hanyang University Software Studio 1 TwithS Team. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class TourInfoMainVC: UITableViewController {
    
    let db = Firestore.firestore()
    var ThisTour = Tour_()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        }
        return ThisTour.landmarks.count
    }
    
    @IBAction func ToTourInfoMainSegue(segue: UIStoryboardSegue){
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {/*
         if indexPath.section == 0 && indexPath.row == 0 {
         let cell = tableView.dequeueReusableCell(withIdentifier: "UserSelectButtonCell", for: indexPath)
         return cell
         }*/
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TourTabBarCell", for: indexPath)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "TourInfoMain", for: indexPath)
        
        let ThisLandmark:Landmark_ = ThisTour.landmarks[indexPath.row]
        cell.textLabel!.text = ThisLandmark.name
        cell.detailTextLabel!.text = ThisLandmark.detail
        cell.imageView!.image = UIImage(named: ThisLandmark.image)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var cell:UIView = UIView()
        if section == 0 {
            cell =  tableView.dequeueReusableCell(withIdentifier: "UserSelectButtonCell")!
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 80
        }
        return 0
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
        
        // 투어 정보 보기
        if segue.identifier == "TIShowTourInfo" {
            let dest = segue.destination as! UINavigationController
            let destTarget = dest.topViewController as! TourInfoTourVC
            destTarget.ThisTour = ThisTour
        }
            
            // 랜드마크 정보 보기
        else if segue.identifier == "TIShowLandmarkInfo" {
            let dest = segue.destination as! UINavigationController
            let destTarget = dest.topViewController as! TourInfoLandmarkVC
            destTarget.ThisLandmark = ThisTour.landmarks[self.tableView.indexPathForSelectedRow!.row]
        }
    }
    
    @IBAction func JjimButtonClicked(_ sender: Any) {
        let uid = Auth.auth().currentUser?.uid as! String
        var ref = db.collection("userTourRelations").whereField("tour", isEqualTo: self.ThisTour.id)
            .whereField("user", isEqualTo: uid).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let documents = querySnapshot?.documents, documents.count != 0 {
                    let alertController = UIAlertController(title: "Error", message: "이미 진행하셨거나, 찜한 투어입니다.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    let cUtr = UserTourRelation_()
                    cUtr.tour = self.ThisTour.id
                    cUtr.user = uid
                    cUtr.state = 1
                    self.db.collection("userTourRelations").addDocument(data: [
                        "tour" : cUtr.tour,
                        "user" : cUtr.user,
                        "state" : cUtr.state,
                        "startTime" : cUtr.startTime,
                        "endTime" : cUtr.endTime
                        ])
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "Home") as UIViewController
                    self.present(vc, animated: true, completion: nil)
                    
                }
            }
        }
    }
}
