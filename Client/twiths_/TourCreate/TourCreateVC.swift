
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

class ldmkCell:UITableViewCell {
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var landmarkTitle: UILabel!
    @IBOutlet var landmarkDescription: UILabel!
}

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

class static5: UITableViewCell {
    
    @IBOutlet var landmarkCount: UILabel!
}

class TourCreateVC: UITableViewController, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var landmarks:[Landmark_] = []
    var images:[UIImage] = []
    var tour = Tour_()
    var imgURL:URL! = nil // 업로드할 이미지의 URL
    var imageCell:static4 = static4()
    var imageUploaded:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    // MARK: - Table view data source
    
    // 숫자 (0~9) 만 입력 가능하게 하기
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard NSCharacterSet(charactersIn: "0123456789").isSuperset(of: NSCharacterSet(charactersIn: string) as CharacterSet) else {
            print("wrong character")
            return false
        }
        return true
    }
    
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
                
                    cell.limitDay.delegate = self
                    cell.limitHour.delegate = self
                    cell.limitMin.delegate = self
                
                return cell
                
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier[indexPath.row], for: indexPath) as! static4
                imageCell = cell
                return cell
                
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier[indexPath.row], for: indexPath) as! static5
                
                cell.landmarkCount.text = "현재 랜드마크 \(landmarks.count)개"
                
                return cell
            }
        }
        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ldmkCell
        
        // 이미지 뷰를 원형으로
        cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width / 2
        cell.imgView.layer.masksToBounds = true
        
        cell.landmarkTitle.text = landmarks[indexPath.row].name
        cell.landmarkDescription.text = landmarks[indexPath.row].detail
        cell.imgView.image = images[indexPath.row]
        
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
        self.imageUploaded = true
        dismiss(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 1 {
            return 230
        }
        if indexPath.section == 0 && indexPath.row == 3 {
            return 200
        }
        return 70
    }
    
    @IBAction func LandmarkCreateToTourCreateSegue(segue:UIStoryboardSegue) {
        
    }
    @IBAction func LandmarkCreateToTourCreateSegue(sender:UIStoryboardSegue){
        if sender.source is LandmarkCreateVC {
            if let senderVC = sender.source as? LandmarkCreateVC {
                landmarks.append(senderVC.landmark)
                images.append(senderVC.imgView1.image!)
            }
            tableView.reloadData()
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "createDone" {
            // 모든 정보를 입력하지 않은 경우 또는 랜드마크 개수가 3개 미만인 경우 오류 메시지 출력
            let cell1 = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TourNameCell
            let cell2 = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! TourDetailCell
            let cell3 = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! TourLimitTimeCell
            
            let info1 = (cell1.tourNameField.text != "")
            let info2 = (cell2.tourDetailField.text != "")
            let info3 = (cell3.limitDay.text != "")
            let info4 = (cell3.limitHour.text != "")
            let info5 = (cell3.limitMin.text != "")
            let info6 = (landmarks.count >= 3)
            
            let infoFinish = info1 && info2 && info3 && info4 && info5 && info6 && imageUploaded
            
            if infoFinish == false {
                let alertController = UIAlertController(title: "Error", message: "랜드마크를 3개 이상 포함하여, 투어에 대한 모든 정보를 입력해 주세요.", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                
                return false
            }
        }
        return true
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        
        if segue.identifier == "createDone" {
            
            // 투어 생성
            let db = Firestore.firestore()
            let imageName = "T\(Date().timeIntervalSince1970).jpg" // 이미지 이름을 지정
            
            var tourRef: DocumentReference? = nil
            let userID = Auth.auth().currentUser?.uid
            let tour = Tour_()
            
            let cell1 = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TourNameCell
            let cell2 = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! TourDetailCell
            let cell3 = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! TourLimitTimeCell
            
            tour.creator = userID!
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
            for i in 0..<landmarks.count {
                let landmark = landmarks[i]
                let newLandmark = Landmark_()
                newLandmark.tour.id = (tourRef?.documentID)!
                newLandmark.name = landmark.name
                newLandmark.image = landmark.image
                newLandmark.detail = landmark.detail
                newLandmark.location = landmark.location
                
                // 랜드마크 이미지 올리기
                let storRef = Storage.storage().reference()
                let data = UIImagePNGRepresentation(images[i])
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                let ImgRef = storRef.child(landmark.image)
                _ = ImgRef.putData(data!, metadata:metadata, completion: { (metadata, error) in
                    if let metadata = metadata {
                        print("Success")
                    } else {
                        print("Error")
                    }
                })
                var ref = db.collection("landmarks").addDocument(data: [
                    "tour" : newLandmark.tour.id,
                    "name" : newLandmark.name,
                    "image": newLandmark.image,
                    "detail": newLandmark.detail,
                    "lati1" : newLandmark.location[0].0,
                    "longi1" : newLandmark.location[0].1,
                    "lati2" : newLandmark.location[1].0,
                    "longi2" : newLandmark.location[1].1,
                    "lati3" : newLandmark.location[2].0,
                    "longi3" : newLandmark.location[2].1,
                    "lati4" : newLandmark.location[3].0,
                    "longi4" : newLandmark.location[3].1
                ])
            }
        }
    }
    
}
