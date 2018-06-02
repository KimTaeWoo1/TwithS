//
//  LandmarkCreateVC.swift
//  twiths_
//
//  Created by yeon suk choi on 2018. 5. 30..
//  Copyright © 2018년 yeon suk choi. All rights reserved.
//

import UIKit
import Firebase

class LandmarkCreateVC: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var landmarkNameFIeld: UITextField!
    @IBOutlet weak var landmarkDetailField: UITextView!
    
    let landmark = Landmark_()
    @IBOutlet var imgView1: UIImageView! // 랜드마크 사진 올리기 이미지뷰
    var imgURL:URL! = nil // 업로드할 이미지의 URL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeBorderToTextField(landmarkDetailField)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        dismiss(animated: true)
    }
    
    // MARK: - Table view data source
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
        guard let name = landmarkNameFIeld.text, let detail = landmarkDetailField.text else {
            return
        }
        
        let imageName = "L\(Date().timeIntervalSince1970).jpg" // 이미지 이름을 지정
        
        landmark.name = name
        landmark.detail = detail
        landmark.image = imageName
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // 랜드마크 이미지 올리기
        let storRef = Storage.storage().reference()
        let data = UIImagePNGRepresentation(imgView1.image!)
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
        
    }
    

}