//
//  TourInfoMainVC.swift
//  twiths_
//
//  Created by yeon suk choi on 2018. 6. 7..
//  Copyright © 2018년 yeon suk choi. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import Cosmos

class TourInfoMain: UITableViewCell {
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var titleText: UILabel!
    @IBOutlet var subtitleText: UILabel!
}

class TourInfoMReview: UITableViewCell {
    @IBOutlet var reviewSubtitle: UILabel!
    @IBOutlet var reviewTitle: UILabel!
    @IBOutlet var StarRating: CosmosView!
}

class TourInfoMMap: UIView {
    
}

class TourInfoMainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: UIView!
    
    
    
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid as! String
    var ThisTour = Tour_()
    var landmarkList:[Landmark_] = []
    var Reviews:[Review_] = []
    var mode:Int = 0 // 0은 목록, 1은 지도, 2는 리뷰
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ThisTour.name
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let gsMapView = GMSMapView.map(withFrame: mapView.bounds, camera: camera)
        
        gsMapView.delegate = self
        gsMapView.isMyLocationEnabled = true
        mapView.addSubview(gsMapView)

        
        // 리뷰 목록에서 투어가 ThisTour와 같은 것을 찾아서 추가한다.
        db.collection("reviews").whereField("tour", isEqualTo: self.ThisTour.id).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else if let documents = querySnapshot?.documents {
                
                var Revs:[Review_] = []
                for document in documents {
                    let review = Review_()
                    review.createTime = document.data()["createTime"] as! Date
                    review.creator = document.data()["creator"] as! String
                    review.id = document.documentID as! String
                    review.name = document.data()["name"] as! String
                    review.stars = document.data()["stars"] as! Double
                    review.tour.id = document.data()["tour"] as! String
                    review.comment = document.data()["comment"] as! String
                    
                    Revs.append(review)
                }
                self.Reviews = Revs
                self.tableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if mode == 0 { return landmarkList.count } // 목록
        else if mode == 1 { return 1 } // 지도
        else { return Reviews.count } // 리뷰. 임시로 3개로 테스트
    }
    
    @IBAction func ToTourInfoMainSegue(segue: UIStoryboardSegue){
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 목록
        if mode == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TourInfoMain", for: indexPath) as! TourInfoMain
            
            let ThisLandmark:Landmark_ = landmarkList[indexPath.row]
            cell.titleText.text = ThisLandmark.name
            cell.subtitleText.text = ThisLandmark.detail
            
            // 이미지 뷰를 원형으로
            cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width / 2
            cell.imgView.layer.masksToBounds = true
            
            // 셀에 이미지를 불러오기 위한 이미지 이름, 저장소 변수
            let imgName = ThisLandmark.image
            let storRef = Storage.storage().reference(forURL: "gs://twiths-350ca.appspot.com").child(imgName)
            
            // 셀에 이미지 불러오기. 임시로 64*1024*1024, 즉 64MB를 최대로 하고, 논의 후 변경 예정.
            storRef.getData(maxSize: 64 * 1024 * 1024) { Data, Error in
                if Error != nil {
                    // 오류가 발생함.
                } else {
                    cell.imgView.image = UIImage(data: Data!)
                }
            }
            return cell
        }
            
        else if mode == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TourInfoMain", for: indexPath) as! TourInfoMain
            self.view.bringSubview(toFront: mapView)
            return cell
        }
            
            // 리뷰
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TourInfoMReview", for: indexPath) as! TourInfoMReview
            
            let ThisReview = Reviews[indexPath.row]
            cell.StarRating.rating = ThisReview.stars
            cell.reviewTitle.text = ThisReview.name
            cell.reviewSubtitle.text = ThisReview.comment
            
            return cell
        }
    }
    
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            self.view.bringSubview(toFront: mapView)
        } else {
            self.view.bringSubview(toFront: tableView)
            self.mode = sender.selectedSegmentIndex
            tableView.reloadData()
        }
    }
    
    // 테이블 뷰 셀의 세로 길이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if mode == 0 { return 65.0 } // 목록
        else if mode == 1 { return 250.0 } // 지도
        else { return 95.0 } // 리뷰
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 투어 정보 보기
        if segue.identifier == "TIShowTourInfo" {
            let dest = segue.destination as! UINavigationController
            let destTarget = dest.topViewController as! TourInfoTourVC
            destTarget.ThisTour = ThisTour
        }
            
            // 랜드마크 정보 보기
        else if segue.identifier == "TIShowLandmarkInfo" {
            let dest = segue.destination as! UINavigationController
            let destTarget = dest.topViewController as! TourInfoLandmarkVC
            destTarget.TourName = ThisTour.name
            destTarget.ThisLandmark = landmarkList[self.tableView.indexPathForSelectedRow!.row]
        }
    }
    
    @IBAction func JjimButtonClicked(_ sender: Any) {
        var ref = db.collection("userTourRelations").whereField("tour", isEqualTo: self.ThisTour.id)
            .whereField("user", isEqualTo: uid).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if let documents = querySnapshot?.documents, documents.count != 0 {
                        let alertController = UIAlertController(title: "Error", message: "이미 진행하셨거나, 찜한 투어입니다.", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        print(self.ThisTour.id)
                        let cUtr = UserTourRelation_()
                        cUtr.tour.id = self.ThisTour.id
                        cUtr.user = self.uid
                        cUtr.state = 1
                        self.db.collection("userTourRelations").addDocument(data: [
                            "tour" : cUtr.tour.id,
                            "user" : cUtr.user,
                            "state" : cUtr.state,
                            "startTime" : cUtr.startTime,
                            "endTime" : cUtr.endTime
                            ])
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "Home") as UIViewController
                        self.present(vc, animated: true, completion: nil)
                        
                    }
                }
        }
    }
    
    @IBAction func proceedButtonClicked(_ sender: Any) {
        var ref = db.collection("userTourRelations").whereField("tour", isEqualTo: self.ThisTour.id)
            .whereField("user", isEqualTo: uid).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if let documents = querySnapshot?.documents, documents.count != 0 {
                        for document in documents {
                            if let state = document.data()["state"] as? Int, state == 1 {
                                self.db.collection("userTourRelations").document(document.documentID).updateData([
                                    "state" : 2,
                                    "startTime" : Date()
                                    ])
                                self.makeUserTourLandmark(document.documentID)
                                
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "Home") as UIViewController
                                self.present(vc, animated: true, completion: nil)
                                
                            } else {
                                let alertController = UIAlertController(title: "Error", message: "진행 중이거나 진행 완료한 투어입니다.", preferredStyle: .alert)
                                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                
                                alertController.addAction(defaultAction)
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }
                    } else {
                        let cUtr = UserTourRelation_()
                        cUtr.tour.id = self.ThisTour.id
                        cUtr.user = self.uid
                        cUtr.state = 2
                        cUtr.startTime = Date()
                        let cUtrRef = self.db.collection("userTourRelations").addDocument(data: [
                            "tour" : cUtr.tour.id,
                            "user" : cUtr.user,
                            "state" : cUtr.state,
                            "startTime" : cUtr.startTime,
                            "endTime" : cUtr.endTime
                            ])
                        
                        self.makeUserTourLandmark(cUtrRef.documentID)
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "Home") as UIViewController
                        self.present(vc, animated: true, completion: nil)
                        
                    }
                }
        }
    }
    func makeUserTourLandmark(_ utrID:String) {
        var landmarkRef = self.db.collection("landmarks").whereField("tour", isEqualTo: self.ThisTour.id).getDocuments() { (snapshot, err) in
            if let err = err {
                print(err.localizedDescription)
            } else {
                if let documents = snapshot?.documents {
                    for document in documents {
                        //UserTourLandmark 추가
                        let utl = UserTourLandMark_()
                        utl.userTourRelation.id = utrID
                        utl.user = self.uid
                        utl.landmark.id = document.documentID
                        
                        let utlRef = self.db.collection("userTourLandmarks").addDocument(data: [
                            "userTourRelation" : utl.userTourRelation.id,
                            "user" : utl.user,
                            "state" : utl.state,
                            "comment" : utl.comment,
                            "successTime" : utl.successTime,
                            "landmark" : utl.landmark.id,
                            "image" : ""
                            ])
                    }
                }
            }
        }
    }

}

extension TourInfoMainVC: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        // Custom logic here
    }
}

