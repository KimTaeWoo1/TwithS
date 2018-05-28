//
//  TourCreateVC.swift
//  twiths_
//
//  Created by ㅇㅇ on 2018. 5. 25..
//
// 임시로 이전 데이터베이스 양식을 이용하므로 나중에 수정이 필요함.

import UIKit
import FirebaseDatabase
import FirebaseAuth

class TourCreateVC: UITableViewController {

    @IBOutlet weak var TourNameField: UITextField!
    @IBOutlet weak var detailTextField: UITextView!
    @IBOutlet weak var landmarkDetailTextField: UITextView!
    @IBOutlet weak var landmarkNameField: UITextField!
    
    @IBOutlet weak var limitDay: UITextField!
    @IBOutlet weak var limitHour: UITextField!
    @IBOutlet weak var limitMin: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeBorderToTextField(detailTextField)
        makeBorderToTextField(landmarkDetailTextField)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "createDone" {
            
            let userID = Auth.auth().currentUser?.uid
            
            let ref = Database.database().reference()
            let tourRef = ref.child("Tours").childByAutoId()
            let landmarkRef = ref.child("Landmarks").childByAutoId()
            let tour = Tour_()
            tour.creator = userID!
            tour.name = TourNameField.text!
            tour.detail = detailTextField.text
            tour.timeLimit = makeLimitToMinite(day: Int(limitDay.text!)!, hour: Int(limitHour.text!)!, min: Int(limitMin.text!)!)
            
            tourRef.child("creator").setValue(tour.creator)
            tourRef.child("name").setValue(tour.name)
            tourRef.child("timeLimit").setValue(tour.timeLimit)
            tourRef.child("detail").setValue(tour.detail)
            
            let landmark = Landmark_()
            landmark.tour = String(tourRef.key)
            landmark.name = landmarkNameField.text!
            landmark.detail = landmarkDetailTextField.text

            landmarkRef.child("tour").setValue(landmark.tour)
            landmarkRef.child("name").setValue(landmark.name)
            landmarkRef.child("detail").setValue(landmark.detail)
        }
    }
    

}
