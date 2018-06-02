
//
//  TourCreate_tempViewController.swift
//  twiths_
//
//  Created by yeon suk choi on 2018. 5. 30..
//  Copyright © 2018년 yeon suk choi. All rights reserved.
//

import UIKit
import Firebase
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

class static4: UITableViewCell {
    @IBOutlet var imgView: UIImageView!
}

class TourCreateVC: UITableViewController, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var landmarks:[Landmark_] = []
    var tour = Tour_()
    var imgURL:URL! = nil // 업로드할 이미지의 URL
    var imageCell:static4 = static4()
    
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
    
    let cellIdentifier = ["TourNameCell", "TourDetailCell", "TourLimitTimeCell", "static4", "static5"]
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier[indexPath.row], for: indexPath) as! TourNameCell
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier[indexPath.row], for: indexPath) as! TourDetailCell
                makeBorderToTextField(cell.tourDetailField)
                return cell
                
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier[indexPath.row], for: indexPath) as! TourLimitTimeCell
                return cell
                
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier[indexPath.row], for: indexPath) as! static4
                imageCell = cell
                return cell
                
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier[indexPath.row], for: indexPath)
                return cell
            }
        }
        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = landmarks[indexPath.row].name
        cell.detailTextLabel?.text = landmarks[indexPath.row].detail
        
        return cell
    }
    
    // '사진 올리기' 버튼 클릭 시 실행
    @IBAction func TourImgUpload(_ sender: Any) {
        var imgPick = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imgPick.delegate = self
            imgPick.sourceType = .savedPhotosAlbum
            imgPick.allowsEditing = false
            
            self.present(imgPick, animated: true, completion: nil)
        }
    }
    
    // 이미지를 선택 완료한 경우
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let url = info[UIImagePickerControllerReferenceURL] as? URL, let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageCell.imgView.image = image
            imgURL = url
            print(imgURL.absoluteString)
        }
        dismiss(animated: true)
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
            
            let db = Firestore.firestore()
            let imageName = "T\(Date().timeIntervalSince1970).jpg" // 이미지 이름을 지정
            
            var tourRef: DocumentReference? = nil
            let userID = Auth.auth().currentUser?.uid
            let tour = Tour_()
            tour.creator = userID!
            let cell1 = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TourNameCell
            let cell2 = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! TourDetailCell
            let cell3 = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! TourLimitTimeCell
            
            tour.name = (cell1.tourNameField?.text)!
            tour.detail = (cell2.tourDetailField?.text)!
            tour.image = imageName
            
            // 투어 이미지 올리기
            let storRef = Storage.storage().reference()
            let data = UIImagePNGRepresentation(imageCell.imgView.image!)
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            let ImgRef = storRef.child(imageName)
            _ = ImgRef.putData(data!, metadata:metadata, completion: { (metadata, error) in
                if let metadata = metadata {
                    print("Success")
                } else {
                    print("Error")
                }
            })
            
            if let day = cell3.limitDay.text, let hour = cell3.limitHour.text, let min = cell3.limitMin.text {
                tour.timeLimit = makeLimitToMinite(day: Int(day)!, hour: Int(hour)!, min: Int(min)!)
            }
            tourRef = db.collection("tours").addDocument(data: [
                "name" : tour.name,
                "creator" : tour.creator,
                "timeLimit" : tour.timeLimit,
                "detail" : tour.detail,
                "image" : tour.image,
                "createDate" : tour.createDate,
                "updateDate" : tour.updateDate
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(tourRef!.documentID)")
                }
            }
            for landmark in landmarks {
                let newLandmark = Landmark_()
                newLandmark.tour.id = (tourRef?.documentID)!
                newLandmark.name = landmark.name
                newLandmark.image = landmark.image
                newLandmark.detail = landmark.detail

                var ref = db.collection("landmarks").addDocument(data: [
                    "tour" : newLandmark.tour.id,
                    "name" : newLandmark.name,
                    "image": newLandmark.image,
                    "detail": newLandmark.detail
                ])
            }
        }
    }
    
}