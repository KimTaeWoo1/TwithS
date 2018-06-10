//
//  SearchVC.swift
//  twiths_
//
//  Created by yeon suk choi on 2018. 5. 28..
//  Copyright © 2018년 Hanyang University Software Studio 1 TwithS team. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class SearchCell:UITableViewCell {
    @IBOutlet var titleText: UILabel!
    @IBOutlet var subtitleText: UILabel!
    @IBOutlet var imgView: UIImageView!
}

class SearchVC: UITableViewController, UISearchResultsUpdating {
    
    
    var tours:[Tour_]  = []
    var filteredTours:[Tour_] = []
    let searchController = UISearchController(searchResultsController: nil)
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var ref = db.collection("tours").addSnapshotListener { (querySnapshot, err) in
            if let err = err, let documents = querySnapshot?.documents {
                print("Error getting documents: \(err)")
            } else {
                var tourList:[Tour_] = []
                for document in querySnapshot!.documents {
                    let tour = Tour_()
                    tour.id = document.documentID
                    tour.name = document.data()["name"] as! String
                    tour.createDate = document.data()["createDate"] as! Date
                    tour.updateDate = document.data()["updateDate"] as! Date
                    tour.creator = document.data()["creator"] as! String
                    if let img = document.data()["image"] as? String {
                        tour.image = document.data()["image"] as! String
                    }
                    tour.detail = document.data()["detail"] as! String
                    tour.timeLimit = document.data()["timeLimit"] as! Int
                    tourList.append(tour)
                }
                self.tours = tourList
            }
        }
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchCell")
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if searchController.searchBar.text! == "" {
            filteredTours = tours
        } else {
            // Filter the results
            filteredTours = tours.filter { $0.name.lowercased().contains(searchController.searchBar.text!.lowercased()) }
        }
        
        self.tableView.reloadData()
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
        return self.filteredTours.count
    }
    
    // 테이블 뷰 셀의 세로 길이 설정
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        cell.titleText.text = filteredTours[indexPath.row].name
        cell.subtitleText.text = filteredTours[indexPath.row].detail
        
        // 이미지 뷰를 원형으로
        cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width / 2
        cell.imgView.layer.masksToBounds = true
        
        // 셀에 이미지를 불러오기 위한 이미지 이름, 저장소 변수
        let imgName = filteredTours[indexPath.row].image
        let storRef = Storage.storage().reference(forURL: "gs://twiths-350ca.appspot.com").child(imgName)
        
        // 셀에 이미지 불러오기. 임시로 64*1024*1024, 즉 64MB를 최대로 하고, 논의 후 변경 예정.
        storRef.getData(maxSize: 64 * 1024 * 1024) { Data, Error in
            if Error != nil {
                // 오류가 발생함.
            } else if let Data = Data {
                cell.imgView.image = UIImage(data: Data)
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
        
        // 투어에 대한 랜드마크 정보 보기
        if segue.identifier == "ShowLandmark" {
            let dest = segue.destination as! TourInfoMainVC
            guard let selectIndexPath = self.tableView.indexPathForSelectedRow else { return }
            dest.ThisTour = filteredTours[selectIndexPath.row]
            
            // 랜드마크 데이터베이스에서 tour의 값이 ThisTour의 ID와 일치하는 것만 랜드마크 리스트에 추가
            let ref = db.collection("landmarks").whereField("tour", isEqualTo: dest.ThisTour.id).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let landmark = Landmark_()
                        landmark.id = document.documentID
                        landmark.detail = document.data()["detail"] as! String
                        landmark.image = document.data()["image"] as! String
                        landmark.name = document.data()["name"] as! String
                        landmark.tour.id = document.data()["tour"] as! String
                        
                        landmark.location.append((document.data()["lati1"] as! Double, document.data()["longi1"] as! Double))
                        landmark.location.append((document.data()["lati2"] as! Double, document.data()["longi2"] as! Double))
                        landmark.location.append((document.data()["lati3"] as! Double, document.data()["longi3"] as! Double))
                        landmark.location.append((document.data()["lati4"] as! Double, document.data()["longi4"] as! Double))
                        dest.landmarkList.append(landmark)
                        dest.tableView.reloadData()
                    }
                }
            }
        }
    }
    
}
