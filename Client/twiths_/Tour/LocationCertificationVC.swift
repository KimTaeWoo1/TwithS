//
//  locationCertificationVC.swift
//  twiths_
//
//  Created by yeon suk choi on 2018. 6. 5..
//  Copyright © 2018년 yeon suk choi. All rights reserved.
//

import UIKit
import Firebase

class LocationCertificationVC: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 카메라 실행, 사진을 찍을 수 있으면
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cam = UIImagePickerController()
            cam.delegate = self
            cam.sourceType = .camera
            cam.allowsEditing = false
            self.present(cam, animated: true, completion: nil)
        }
        else {
            // 찍을 수 없으면 않으면 경고 메시지 띄우고 종료
            guard let nvController = self.navigationController else { return }
            nvController.popViewController(animated: true)
            
            let alertController = UIAlertController(title: "Info", message: "카메라를 실행할 수 없습니다.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        textField.delegate = self
        let nsdate = NSDate()
        let date = nsdate as Date
        let cal = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
        guard let cale = cal else { return }
        let year = cale.component(NSCalendar.Unit.year, from: date)
        let month = cale.component(NSCalendar.Unit.month, from: date)
        let day = cale.component(NSCalendar.Unit.day, from: date)
        let hour = cale.component(NSCalendar.Unit.hour, from: date)
        let minute = cale.component(NSCalendar.Unit.minute, from: date)
        let second = cale.component(NSCalendar.Unit.second, from: date)
        
        makeBorderToTextField(textField)
        textField.text = "장소에 방문한 소감을 입력해주세요."
        textField.textColor = UIColor.lightGray

        
        CertificationTimeLabel.text = "\(year)년 \(month)월 \(day)일 \(hour)시 \(minute)분 \(second)초"

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
            textView.text = "장소에 방문한 소감을 입력해주세요."
            textView.textColor = UIColor.lightGray
        }
    }
    
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
    
    
    // '사진 업로드' 버튼 클릭 시 실행
    @IBAction func picUpload(_ sender: Any) {
        
    }
    
    // 이미지를 선택 완료한 경우
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let type = info[UIImagePickerControllerMediaType] as! NSString
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        picImage.image = image
        
        self.imageUploaded = true
        dismiss(animated: true)
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
            guard let img = picImage.image else { return }
            guard let data = UIImagePNGRepresentation(img) else { return }
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            let ImgRef = storRef.child(imageName)
            _ = ImgRef.putData(data, metadata:metadata, completion: { (metadata, error) in
                if let metadata = metadata {
                    print("Success")
                } else {
                    print("Error")
                }
            })
            
            utlRef.updateData([
                "state" : 1,
                "comment" : textField.text,
                "image" : imageName,
                "successTime" : date
            ]){ err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
            let dest = segue.destination as! LandmarkListVC
            dest.tableView.reloadData()
        }
    }

}
