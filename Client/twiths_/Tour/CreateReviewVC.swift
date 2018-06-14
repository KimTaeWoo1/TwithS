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

class CreateReviewVC: UITableViewController,UITextViewDelegate {
    
    var tour = Tour_()
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var StarRating: CosmosView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        makeBorderToTextField(textField)
        StarRating.settings.fillMode = .half
        textField.text = "투어에 대한 리뷰를 입력해주세요."
        textField.textColor = UIColor.lightGray
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "투어에 대한 리뷰를 입력해주세요."
            textView.textColor = UIColor.lightGray
        }
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateReviewDone" {
            let db = Firestore.firestore()
            
            if let user = Auth.auth().currentUser {
                let uid = user.uid
                db.collection("reviews").addDocument(data: [
                    "creator" : uid,
                    "name" : user.displayName,
                    "tour" : tour.id,
                    "stars" : StarRating.rating,
                    "comment" : textField.text,
                    "createTime" : Date()
                    ])
            }
        }
    }
}
