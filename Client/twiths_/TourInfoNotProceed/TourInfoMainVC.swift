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
    let uid = Auth.auth().currentUser?.uid as! String
    var ThisTour = Tour_()
    var landmarkList:[Landmark_] = []
    
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
        return landmarkList.count
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
        
        let ThisLandmark:Landmark_ = landmarkList[indexPath.row]
        cell.textLabel!.text = ThisLandmark.name
        cell.detailTextLabel!.text = ThisLandmark.detail
        
        // 셀에 이미지를 불러오기 위한 이미지 이름, 저장소 변수
        let imgName = ThisLandmark.image
        let storRef = Storage.storage().reference(forURL: "gs://twiths-350ca.appspot.com").child(imgName)
        
        // 셀에 이미지 불러오기. 임시로 64*1024*1024, 즉 64MB를 최대로 하고, 논의 후 변경 예정.
        storRef.getData(maxSize: 64 * 1024 * 1024) { Data, Error in
            if Error != nil {
                // 오류가 발생함.
            } else {
                cell.imageView?.image = UIImage(data: Data!)
            }
        }
        
//        let ThisLandmark:Landmark_ = ThisTour.landmarks[indexPath.row]
//        cell.textLabel!.text = ThisLandmark.name
//        cell.detailTextLabel!.text = ThisLandmark.detail
//        cell.imageView!.image = UIImage(named: ThisLandmark.image)

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
            destTarget.TourName = ThisTour.name
            destTarget.ThisLandmark = landmarkList[self.tableView.indexPathForSelectedRow!.row]
        }
    }
    
    @IBAction func JjimButtonClicked(_ sender: Any) {
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
                    print(self.ThisTour.id)
                    let cUtr = UserTourRelation_()
                    cUtr.tour.id = self.ThisTour.id
                    cUtr.user = self.uid
                    cUtr.state = 1
                    self.db.collection("userTourRelations").addDocument(data: [
                        "tour" : cUtr.tour.id,
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
    
    @IBAction func proceedButtonClicked(_ sender: Any) {
        var ref = db.collection("userTourRelations").whereField("tour", isEqualTo: self.ThisTour.id)
            .whereField("user", isEqualTo: uid).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if let documents = querySnapshot?.documents, documents.count != 0 {
                        for document in documents {
                            if let state = document.data()["state"] as? Int, state == 1 {
                                self.db.collection("userTourRelations").document(document.documentID).updateData([
                                    "state" : 2,
                                    "startTime" : Date()
                                ])
                                self.makeUserTourLandmark(document.documentID)
                                
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "Home") as UIViewController
                                self.present(vc, animated: true, completion: nil)
                                
                            } else {
                                let alertController = UIAlertController(title: "Error", message: "진행 중이거나 진행 완료한 투어입니다.", preferredStyle: .alert)
                                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                
                                alertController.addAction(defaultAction)
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }
                    } else {
                        let cUtr = UserTourRelation_()
                        cUtr.tour.id = self.ThisTour.id
                        cUtr.user = self.uid
                        cUtr.state = 2
                        cUtr.startTime = Date()
                        let cUtrRef = self.db.collection("userTourRelations").addDocument(data: [
                            "tour" : cUtr.tour.id,
                            "user" : cUtr.user,
                            "state" : cUtr.state,
                            "startTime" : cUtr.startTime,
                            "endTime" : cUtr.endTime
                            ])
                        
                        self.makeUserTourLandmark(cUtrRef.documentID)
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "Home") as UIViewController
                        self.present(vc, animated: true, completion: nil)
                        
                    }
                }
        }
    }
    func makeUserTourLandmark(_ utrID:String) {
        var landmarkRef = self.db.collection("landmarks").whereField("tour", isEqualTo: self.ThisTour.id).getDocuments() { (snapshot, err) in
            if let err = err {
                print(err.localizedDescription)
            } else {
                if let documents = snapshot?.documents {
                    for document in documents {
                        //UserTourLandmark 추가
                        let utl = UserTourLandMark_()
                        utl.userTourRelation.id = utrID
                        utl.user = self.uid
                        
                        let utlRef = self.db.collection("userTourLandmarks").addDocument(data: [
                            "userTourRelation" : utl.userTourRelation.id,
                            "user" : utl.user,
                            "state" : utl.state,
                            "comment" : utl.comment,
                            "successTime" : utl.successTime
                            ])
                    }
                }
            }
        }
    }
}
