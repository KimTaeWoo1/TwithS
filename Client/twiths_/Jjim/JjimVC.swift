//
//  JjimVC.swift
//  twiths_
//
//  Created by yeon suk choi on 2018. 6. 1..
//  Copyright © 2018년 yeon suk choi. All rights reserved.
//

import UIKit
import Firebase


class JjimVC: UITableViewController {
    var tours:[Tour_] = []
    let db = Firestore.firestore()
    @IBOutlet var editButton: UIBarButtonItem!
    
    // 편집 버튼을 클릭하면 진행 중인 투어를 삭제(테이블뷰와 데이터베이스 모두에서)
    @IBAction func JjimTourEdit(_ sender: Any) {
        if self.tableView.isEditing == false {
            self.tableView.setEditing(true, animated: true)
            editButton.title = "완료"
        } else {
            self.tableView.setEditing(false, animated: true)
            editButton.title = "편집"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let uid = Auth.auth().currentUser?.uid as! String
        let dGroup = DispatchGroup()
        
        self.db.collection("userTourRelations").whereField("state", isEqualTo: 1).whereField("user", isEqualTo: uid).addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    dGroup.enter()
                    let tour = Tour_()
                    self.db.collection("tours").document(document.data()["tour"] as! String).addSnapshotListener { (query, error) in
                        if let query = query, query.exists {
                            tour.id = query.documentID
                            tour.name = query.data()!["name"] as! String
                            tour.creator = query.data()!["creator"] as! String
                            tour.image = query.data()!["image"] as! String
                            tour.timeLimit = query.data()!["timeLimit"] as! Int
                            tour.detail = query.data()!["detail"] as! String
                            tour.createDate = query.data()!["createDate"] as! Date
                            tour.updateDate = query.data()!["updateDate"] as! Date
                            self.tours.append(tour)
                            dGroup.leave()  /// 3
                        } else {
                            print("Document does not exist")
                        }
                    }
                }
            }
            dGroup.notify(queue: .main) {   //// 4
                self.tableView.reloadData()
            }
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.tours.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JjimCell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = self.tours[indexPath.row].name
        cell.detailTextLabel?.text = self.tours[indexPath.row].detail
        
        // 셀에 이미지를 불러오기 위한 이미지 이름, 저장소 변수
        let imgName = self.tours[indexPath.row].image
        let storRef = Storage.storage().reference(forURL: "gs://twiths-350ca.appspot.com").child(imgName)
        
        // 셀에 이미지 불러오기. 임시로 64*1024*1024, 즉 64MB를 최대로 하고, 논의 후 변경 예정.
        storRef.getData(maxSize: 64 * 1024 * 1024) { Data, Error in
            if Error != nil {
                // 오류가 발생함.
            } else {
                cell.imageView?.image = UIImage(data: Data!)
            }
        }
        
        return cell
    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
     // Override to support editing the table view.
    
     // 찜한 투어를 삭제하기(userTourRelations에서 해당 투어의 데이터를 삭제)
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // 먼저 문서의 ID를 얻은 다음,
            let delTour = tours[indexPath.row]
            var docID = ""
            
            db.collection("userTourRelations").whereField("user", isEqualTo: Auth.auth().currentUser!.uid).whereField("tour", isEqualTo: delTour.id).getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else if let documents = querySnapshot?.documents {
                    for document in querySnapshot!.documents {
                        docID = document.documentID
                        
                        // 그 ID에 해당하는 문서를 userTourRelations에서 삭제
                        self.db.collection("userTourRelations").document(docID).delete()
                    }
                }
            }
            
            // 테이블뷰에서 해당 투어를 삭제
            self.tours.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
     }
    
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
        
        // 투어에 대한 랜드마크 정보 보기
        if segue.identifier == "ShowLandmark" {
            let dest = segue.destination as! TourInfoMainVC
            dest.ThisTour = tours[self.tableView.indexPathForSelectedRow!.row]
            
        }
    }
    
    
}
