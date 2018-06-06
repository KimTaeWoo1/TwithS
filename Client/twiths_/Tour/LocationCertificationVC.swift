//
//  locationCertificationVC.swift
//  twiths_
//
//  Created by yeon suk choi on 2018. 6. 5..
//  Copyright © 2018년 yeon suk choi. All rights reserved.
//

import UIKit
import Firebase

class LocationCertificationVC: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var utl = UserTourLandMark_()
    
    var date = NSDate()
    var year = 1970
    var month = 1
    var day = 1
    var hour = 9
    var minute = 0
    var second = 0
    
    var imageUploaded = false
    
    @IBOutlet weak var CertificationTimeLabel: UILabel!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet var picImage: UIImageView!
    
    // '사진 업로드' 버튼 클릭 시 실행
    @IBAction func picUpload(_ sender: Any) {
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
            picImage.image = image
        }
        self.imageUploaded = true
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        date = NSDate()
        let cal = Calendar.current
        let comps = cal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date as Date)
        year = comps.year!
        month = comps.month!
        day = comps.day!
        hour = comps.hour!
        minute = comps.minute!
        second = comps.second!
        
        makeBorderToTextField(textField)
        
        CertificationTimeLabel.text = "\(year)년 \(month)월 \(day)일 \(hour)시 \(minute)분 \(second)초"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
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

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "locationCertificateDone" {
            // 모든 정보를 입력하지 않은 경우 또는 랜드마크 개수가 3개 미만인 경우 오류 메시지 출력
            
            let info1 = (CertificationTimeLabel.text != "")
            let info2 = (textField.text != "")
            
            let infoFinish = info1 && info2 && imageUploaded
            
            if infoFinish == false {
                let alertController = UIAlertController(title: "Error", message: "사진을 포함하여 모든 정보를 입력해 주세요.", preferredStyle: .alert)
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
        if segue.identifier == "locationCertificateDone" {
            
            let db = Firestore.firestore()
            let utlRef = db.collection("userTourLandmarks").document(utl.id)
            
            // 완료한 랜드마크에 대한 이미지 올리기
            let imageName = "C\(Date().timeIntervalSince1970).jpg" // 이미지 이름을 지정
            let storRef = Storage.storage().reference()
            let data = UIImagePNGRepresentation(picImage.image!)
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
            
            utlRef.updateData([
                "state" : 1,
                "comment" : textField?.text,
                "image" : imageName,
                "successTime" : date
            ]){ err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        }
    }

}
