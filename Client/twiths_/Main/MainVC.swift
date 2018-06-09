//
//  ProceedingVC.swift
//  twiths_
//
//  Created by ㅇㅇ on 2018. 5. 25..
//

import UIKit
import Firebase

class CurrentProceedTourCell : UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var proceedTimeLabel: UILabel!
    @IBOutlet weak var tourImageView: UIImageView!
    @IBOutlet weak var currentProceedLabel: UILabel!
    
}

class MainVC: UITableViewController {
    
    var proceedTours:[UserTourRelation_] = []
    
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid
    @IBOutlet var editButton: UIBarButtonItem!
    
    // 편집 버튼을 클릭하면 진행 중인 투어를 삭제(테이블뷰와 데이터베이스 모두에서)
    @IBAction func ProceedTourEdit(_ sender: Any) {
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
        let dGroup = DispatchGroup()
        
        var tours:[UserTourRelation_] = []
        db.collection("userTourRelations").whereField("user", isEqualTo: self.uid).whereField("state", isEqualTo: 2).addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else if let documents = querySnapshot?.documents, let uid = self.uid {
                tours = []
                for document in documents {
                    dGroup.enter()
                    let utr = UserTourRelation_()
                    utr.id = document.documentID
                    utr.state = document.data()["state"] as! Int
                    utr.startTime = document.data()["startTime"] as! Date
                    utr.user = uid
                    
                    self.db.collection("tours").document(document.data()["tour"] as! String).addSnapshotListener { query, err in
                        if let err = err {
                            print(err.localizedDescription)
                        } else if let query = query, query.exists, let data = query.data() {
                            let tour = Tour_()
                            tour.id = query.documentID
                            tour.name = data["name"] as! String
                            tour.detail = data["detail"] as! String
                            tour.creator = data["creator"] as! String
                            tour.createDate = data["createDate"] as! Date
                            tour.updateDate = data["updateDate"] as! Date
                            tour.timeLimit = data["timeLimit"] as! Int
                            tour.image = data["image"] as! String
                            utr.tour = tour
                            tours.append(utr)
                            dGroup.leave()
                        } else {
                            print("Document does not exist")
                        }
                    }
                }
            } 
            dGroup.notify(queue: .main) {   //// 4
                self.proceedTours = tours
                self.tableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        // 사용자가 진행 중인 투어의 개수를 구한다.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return proceedTours.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentTourCell", for: indexPath) as! CurrentProceedTourCell
        
        cell.nameLabel.text = proceedTours[indexPath.row].tour.name
        cell.proceedTimeLabel.text = getProceedTime(proceedTours[indexPath.row]) + " 째 진행중!"
        
        // 이미지 뷰를 원형으로
        cell.tourImageView.layer.cornerRadius = cell.tourImageView.frame.size.width / 2
        cell.tourImageView.layer.masksToBounds = true
        
        // 셀에 이미지를 불러오기 위한 이미지 이름, 저장소 변수
        var imgName = proceedTours[indexPath.row].tour.image
        
        let storRef = Storage.storage().reference(forURL: "gs://twiths-350ca.appspot.com").child(imgName)
        
        // 셀에 이미지 불러오기. 임시로 64*1024*1024, 즉 64MB를 최대로 하고, 논의 후 변경 예정.
        storRef.getData(maxSize: 64 * 1024 * 1024) { Data, Error in
            if let Error = Error {
                print(Error.localizedDescription)
            } else {
                cell.tourImageView.image = UIImage(data: Data!)
            }
        }
        return cell
    }
    
    
    
    @IBAction func TourListToTourCreate(segue:UIStoryboardSegue){
    }
    
    
     // 진행 중인 투어를 삭제하기(userTourRelations에서 해당 투어의 데이터를 삭제)
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            // 투어 삭제 확인 창 띄우기
            let alertController = UIAlertController(title: "Confirm", message: "이 투어를 정말로 삭제하시겠습니까?", preferredStyle: .alert)
            
            // 투어 삭제 확인 창에서 '예'를 클릭하면
            alertController.addAction(UIAlertAction(title: "예", style: .default, handler: {
                action in
                
                // 1. UserTourRelation의 데이터 삭제
                // 먼저 UserTourRelation 문서의 ID를 얻은 다음,
                let delTour = self.proceedTours[indexPath.row]
                var UTRdocID = ""
                
                self.db.collection("userTourRelations").whereField("user", isEqualTo: Auth.auth().currentUser!.uid).whereField("tour", isEqualTo: delTour.tour.id).getDocuments { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else if let documents = querySnapshot?.documents {
                        for document in querySnapshot!.documents {
                            UTRdocID = document.documentID
                            
                            // 그 ID에 해당하는 문서를 userTourRelations에서 삭제
                            self.db.collection("userTourRelations").document(UTRdocID).delete()
                            
                            // 2. UserTourLandmark의 데이터 삭제
                            // 먼저 UserTourLandmark 문서의 ID를 얻은 다음,
                            var UTLdocID = ""
                            
                            self.db.collection("userTourLandmarks").whereField("user", isEqualTo: Auth.auth().currentUser!.uid).whereField("userTourRelation", isEqualTo: UTRdocID).getDocuments { (querySnapshot, err) in
                                if let err = err {
                                    print("Error getting documents: \(err)")
                                } else if let documents = querySnapshot?.documents {
                                    for document in documents {
                                        UTLdocID = document.documentID
                                        
                                        // 그 ID에 해당하는 문서를 userTourLandmark에서 삭제
                                        self.db.collection("userTourLandmarks").document(UTLdocID).delete()
                                    }
                                }
                            }
                        }
                    }
                }
                
                // 테이블뷰에서 해당 투어를 삭제
                self.proceedTours.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }))
            
            // '아니오'를 클릭하면
            alertController.addAction(UIAlertAction(title: "아니오", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
     }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tour_detail" {
            let dest = segue.destination as! LandmarkListVC
            dest.userTourRelation = proceedTours[self.tableView.indexPathForSelectedRow!.row]
        }
    }
    
}
