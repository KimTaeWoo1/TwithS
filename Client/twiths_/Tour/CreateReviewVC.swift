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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

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
