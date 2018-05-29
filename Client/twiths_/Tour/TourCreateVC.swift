//
//  TourCreateVC.swift
//  twiths_
//
//  Created by ㅇㅇ on 2018. 5. 25..
//
// 임시로 이전 데이터베이스 양식을 이용하므로 나중에 수정이 필요함.

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class TourCreateVC: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var ImgView1: UIImageView!
    @IBOutlet var ImgView2: UIImageView!
    var ImgUrl1:URL! = nil // 투어 이미지의 URL
    var ImgUrl2:URL! = nil // 랜드마크 이미지의 URL

    @IBOutlet weak var TourNameField: UITextField!
    @IBOutlet weak var detailTextField: UITextView!
    @IBOutlet weak var landmarkDetailTextField: UITextView!
    @IBOutlet weak var landmarkNameField: UITextField!
    
    @IBOutlet weak var limitDay: UITextField!
    @IBOutlet weak var limitHour: UITextField!
    @IBOutlet weak var limitMin: UITextField!
    
    var imgPicker = UIImagePickerController()
    var IsTourUpload:Bool = true // 투어 이미지 업로드 시 true, 랜드마크 이미지 업로드 시 false
    
    // 투어에 있는 이미지 업로드 버튼 터치 시
    @IBAction func TourImgUpload(_ sender: Any) {
        IsTourUpload = true
        showImgAlbum(imgPicker: imgPicker, TourCreate: self)
    }
    
    // 랜드마크 업로드에 있는 이미지 업로드 버튼 터치 시
    @IBAction func LandmarkImgUpload(_ sender: Any) {
        IsTourUpload = false
        showImgAlbum(imgPicker: imgPicker, TourCreate: self)
    }
    
    // 이미지를 선택 완료한 경우
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let url = info[UIImagePickerControllerReferenceURL] as? URL, let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            UserDefaults.standard.set(url, forKey: "assetURL")
            
            if IsTourUpload == true {
                ImgView1.image = image
                ImgUrl1 = url
            } else {
                ImgView2.image = image
                ImgUrl2 = url
            }
        }
        dismiss(animated: true)
    }
    
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
            tour.image = ImgView1.image!.description // 임시로 해당 이미지의 description으로 저장
            tour.timeLimit = makeLimitToMinite(day: Int(limitDay.text!)!, hour: Int(limitHour.text!)!, min: Int(limitMin.text!)!)
            
            tourRef.child("creator").setValue(tour.creator)
            tourRef.child("name").setValue(tour.name)
            tourRef.child("timeLimit").setValue(tour.timeLimit)
            tourRef.child("detail").setValue(tour.detail)
            tourRef.child("image").setValue(tour.image)
            
            let landmark = Landmark_()
            landmark.tour = String(tourRef.key)
            landmark.name = landmarkNameField.text!
            landmark.image = ImgView2.image!.description // 임시로 해당 이미지의 description으로 저장
            landmark.detail = landmarkDetailTextField.text

            landmarkRef.child("tour").setValue(landmark.tour)
            landmarkRef.child("name").setValue(landmark.name)
            landmarkRef.child("detail").setValue(landmark.detail)
            landmarkRef.child("image").setValue(landmark.image)
            
            // 투어 이미지 올리기
            let storage1 = Storage.storage()
            let data1 = UIImagePNGRepresentation(ImgView1.image!)
            let storRef1 = storage1.reference()
            let ImgRef1 = storRef1.child(ImgUrl1.path)
            _ = ImgRef1.putData(data1!, metadata:nil, completion: { (metadata, error) in
                if let metadata = metadata {
                    print("Success")
                } else {
                    print("Error")
                }
            })
            
            // 랜드마크 이미지 올리기
            let storage2 = Storage.storage()
            let data2 = UIImagePNGRepresentation(ImgView2.image!)
            let storRef2 = storage2.reference()
            let ImgRef2 = storRef2.child(ImgUrl2.path)
            _ = ImgRef2.putData(data2!, metadata:nil, completion: { (metadata, error) in
                if let metadata = metadata {
                    print("Success")
                } else {
                    print("Error")
                }
            })
        }
    }
    

}
