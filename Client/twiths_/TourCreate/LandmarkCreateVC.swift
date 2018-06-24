//
//  LandmarkCreateVC.swift
//  twiths_
//
//  Created by yeon suk choi on 2018. 5. 30..
//  Copyright © 2018년 yeon suk choi. All rights reserved.
//

import UIKit
import Firebase


class LandmarkCreateVC: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {
    @IBOutlet weak var landmarkNameFIeld: UITextField!
    @IBOutlet weak var landmarkDetailField: UITextView!
    @IBOutlet weak var CheckLocationSelectedLabel: UILabel!
    
    let landmark = Landmark_()
    var imageUploaded = false
    var locationSet = false
    @IBOutlet var imgView1: UIImageView! // 랜드마크 사진 올리기 이미지뷰
    var imgURL:URL = URL(fileURLWithPath: "") // 업로드할 이미지의 URL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        landmarkDetailField.delegate = self
        makeBorderToTextField(landmarkDetailField)
        guard let locSelected = CheckLocationSelectedLabel else { return }
        locSelected.text = ""
        landmarkNameFIeld.placeholder = "장소 제목을 입력해주세요.".localized
        landmarkDetailField.text = "장소에 대한 설명을 입력해주세요.".localized
        landmarkDetailField.textColor = UIColor.lightGray
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "장소에 대한 설명을 입력해주세요.".localized
            textView.textColor = UIColor.lightGray
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func LandmarkImgUpload(_ sender: Any) {
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
            imgView1.image = image
            imgURL = url
        }
        imageUploaded = true
        dismiss(animated: true)
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // 모든 정보를 입력하지 않은 경우 오류 메시지 출력
        if identifier == "LandmarkDone" {
            let info1 = (self.landmarkNameFIeld.text != "")
            let info2 = (self.landmarkDetailField.text != "")
            let infoFinish = info1 && info2 && imageUploaded && locationSet
        
            if infoFinish == false {
                let alertController = UIAlertController(title: "Error", message: "사진과 위치 설정을 포함하여, 장소에 대한 모든 정보를 입력해 주세요.".localized, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                
                return false
            }
        }
        
        return true
    }

    @IBAction func MapToCreateLandmark(sender:UIStoryboardSegue){
        if sender.source is CreateLandmarkLocationVC {
            if let senderVC = sender.source as? CreateLandmarkLocationVC {
                var markerList:[(Double,Double)] = []
                for marker in senderVC.allMarkers {
                    markerList.append((marker.position.latitude, marker.position.longitude))
                }
                landmark.location = markerList
                guard let locSelected = CheckLocationSelectedLabel else { return }
                locSelected.text = "설정 완료".localized
                locationSet = true
            }
        }
    }
    
    @IBAction func MapToCreateLandmark(segue:UIStoryboardSegue){
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "LandmarkDone" {
            guard let name = landmarkNameFIeld.text, let detail = landmarkDetailField.text else {
                return
            }
        
            let imageName = "L\(Date().timeIntervalSince1970).jpg" // 이미지 이름을 지정
            
            landmark.name = name
            landmark.detail = detail
            landmark.image = imageName
        }
        
    }
    


}
