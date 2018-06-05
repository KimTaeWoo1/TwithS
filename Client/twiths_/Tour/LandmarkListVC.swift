//
//  LandmarkListVC.swift
//  twiths_
//
//  Created by ㅇㅇ on 2018. 5. 25..
//
// 임시로 이전 데이터베이스 양식을 이용하므로 나중에 수정이 필요함.

import UIKit
import Firebase
import MapKit
import CoreLocation
import GoogleMaps

protocol YourCellDelegate : class {
    func didPressButton(_ tag: Int)
}

// 랜드마크 목록 셀
class LandmarkCell: UITableViewCell {
    @IBOutlet var LandmarkImage: UIImageView!
    @IBOutlet var LandmarkTitle: UILabel!
    @IBOutlet var LandmarkDescription: UILabel!
    weak var cellDelegate: YourCellDelegate?
    
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        cellDelegate?.didPressButton(sender.tag)
    }
    
}

// 지도 뷰 셀
class MapCell:UITableViewCell {
    
}

// 리뷰 뷰 셀
class ReviewCell:UITableViewCell {
    @IBOutlet var reviewImg: UIImageView!
    @IBOutlet var reviewTitle: UILabel!
    @IBOutlet var reviewSubtitle: UILabel!
}

class LandmarkListVC: UITableViewController, YourCellDelegate, CLLocationManagerDelegate {

    var mode:Int = 0 // 0은 코스, 1은 지도, 2는 리뷰
    
    // '코스' 버튼을 누르면 코스 버튼 띄우기
    @IBAction func courseShow(_ sender: Any) {
        mode = 0
        self.tableView.reloadData()
    }
    
    // '지도' 버튼을 누르면 지도 띄우기
    @IBAction func mapShow(_ sender: Any) {
        mode = 1
        self.tableView.reloadData()
    }
    
    // '리뷰' 버튼을 누르면 리뷰 띄우기
    @IBAction func reviewShow(_ sender: Any) {
        mode = 2
        self.tableView.reloadData()
    }
    
    var ID:Int = 0
    var userTourRelation = UserTourRelation_()
    
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid
    let locationManager = CLLocationManager()
    var landmarkList:[Landmark_] = []
    var Reviews:[Review_] = []
    let cal = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        // 랜드마크 목록에서 투어가 userTourRelation의 투어와 같은 것을 찾아서 랜드마크 정보에 추가한다.
        db.collection("landmarks").whereField("tour", isEqualTo: self.userTourRelation.tour.id).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else if let documents = querySnapshot?.documents {
                
                var landmarks:[Landmark_] = []
                for document in documents {
                    let landmark = Landmark_()
                    landmark.tour.id = document.data()["tour"] as! String
                    landmark.detail = document.data()["detail"] as! String
                    landmark.image = document.data()["image"] as! String
                    landmark.name = document.data()["name"] as! String
                    
                    landmark.location.append((document.data()["lati1"] as! Double, document.data()["longi1"] as! Double))
                    landmark.location.append((document.data()["lati2"] as! Double, document.data()["longi2"] as! Double))
                    landmark.location.append((document.data()["lati3"] as! Double, document.data()["longi3"] as! Double))
                    landmark.location.append((document.data()["lati4"] as! Double, document.data()["longi4"] as! Double))
 
                    landmarks.append(landmark)
                }
                self.landmarkList = landmarks
                self.tableView.reloadData()
            }
        }
        
        // 리뷰 목록에서 투어가 ThisTour와 같은 것을 찾아서 추가한다.
        db.collection("reviews").whereField("tour", isEqualTo: self.userTourRelation.tour.id).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else if let documents = querySnapshot?.documents {
                
                var Revs:[Review_] = []
                for document in documents {
                    let review = Review_()
                    review.createTime = document.data()["createTime"] as! Date
                    review.creator = document.data()["creator"] as! String
                    review.id = document.data()["id"] as! Int // 리뷰를 쓸 때마다 전체 리뷰 수를 카운트하여 ID를 자동으로 산출한다고 가정
                    review.image = document.data()["image"] as! String
                    review.stars = document.data()["stars"] as! Int
                    review.tour.id = document.data()["tour"] as! String
                    review.updateTime = document.data()["updateTime"] as! Date
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if mode == 0 { return landmarkList.count } // 코스
        else if mode == 1 { return 1 } // 지도
        else { return Reviews.count } // 리뷰
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 코스
        if mode == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LandmarkListREUSE", for: indexPath) as! LandmarkCell
        
            let ThisLandmark = landmarkList[indexPath.row]
            cell.LandmarkTitle.text = ThisLandmark.name
            cell.LandmarkDescription.text = ThisLandmark.detail
            
            cell.cellDelegate = self
            cell.tag = indexPath.row
            
            // 셀에 이미지를 불러오기 위한 이미지 이름, 저장소 변수
            let imgName = ThisLandmark.image
            let storRef = Storage.storage().reference(forURL: "gs://twiths-350ca.appspot.com").child(imgName)
            
            // 셀에 이미지 불러오기. 임시로 64*1024*1024, 즉 64MB를 최대로 하고, 논의 후 변경 예정.
            storRef.getData(maxSize: 64 * 1024 * 1024) { Data, Error in
                if Error != nil {
                    // 오류가 발생함.
                } else {
                    cell.LandmarkImage.image = UIImage(data: Data!)
                }
            }

            return cell
        }
        
        // 지도
        else if mode == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MapREUSE", for: indexPath) as! MapCell
            
            return cell
        }
        
        // 리뷰
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewREUSE", for: indexPath) as! ReviewCell
            
            let ThisReview = Reviews[indexPath.row]
            
            cell.reviewTitle.text = ThisReview.creator
            
            var starText = ""
            for _ in 0..<ThisReview.stars { starText += "★" }
            for _ in ThisReview.stars..<5 { starText += "☆" }
            let date = ThisReview.createTime
            let year = cal!.component(NSCalendar.Unit.year, from: date)
            let month = cal!.component(NSCalendar.Unit.month, from: date)
            let day = cal!.component(NSCalendar.Unit.day, from: date)
            
            cell.reviewSubtitle.text = "\(starText) / \(year)년 \(month)월 \(day)일"
            
            // 셀에 이미지를 불러오기 위한 이미지 이름, 저장소 변수
            let imgName = ThisReview.image
            let storRef = Storage.storage().reference(forURL: "gs://twiths-350ca.appspot.com").child(imgName)
            
            // 셀에 이미지 불러오기. 임시로 64*1024*1024, 즉 64MB를 최대로 하고, 논의 후 변경 예정.
            storRef.getData(maxSize: 64 * 1024 * 1024) { Data, Error in
                if Error != nil {
                    // 오류가 발생함.
                } else {
                    cell.reviewImg.image = UIImage(data: Data!)
                }
            }
            
            return cell
        }
    }
    
    func didPressButton(_ tag: Int) {
        let landmark = landmarkList[tag]
        guard let locValue: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
        
        let rect = GMSMutablePath()
        for marker in landmark.location {
            rect.add(CLLocationCoordinate2D(latitude: marker.0, longitude: marker.1))
        }
        let polygon = GMSPolygon(path: rect)
        if GMSGeometryContainsLocation(locValue, polygon.path!, true) {
            let alertController = UIAlertController(title: "Info", message: "4개의 핀이 찍혀야합니다.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else {
        }
    }
    
    // 테이블 뷰 셀의 세로 길이 설정
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if mode == 0 { return 127.0 } // 코스
        else if mode == 1 { return 250.0 } // 지도
        else { return 65.0 } // 리뷰
    }
    
    @IBAction func TourListToLandmarkInfo(segue: UIStoryboardSegue){
        
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // 투어 정보 보기
        if segue.identifier == "TourInfoGO" {
            let dest = segue.destination as! UINavigationController
            let destTarget = dest.topViewController as! TourInfoVC
            
            destTarget.ThisTour = self.userTourRelation.tour
        }
            
        // 랜드마크 정보 보기
        else if segue.identifier == "LandmarkInfoGO" {
            let dest = segue.destination as! UINavigationController
            let destTarget = dest.topViewController as! LandmarkInfoVC
            
            destTarget.tourName = self.userTourRelation.tour.name
            destTarget.ThisLandmark = self.landmarkList[(self.tableView.indexPathForSelectedRow?.row)!]
        }
    }

}
