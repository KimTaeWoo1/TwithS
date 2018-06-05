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

// 투어의 남은 시간, 진행률을 표시하는 셀
class tourInfoCell: UITableViewCell {
    @IBOutlet var clockIcon: UIImageView!
    @IBOutlet var timeLeft: UILabel!
    @IBOutlet var proceedRate: UILabel!
    
}

// 랜드마크 목록 셀
class LandmarkCell: UITableViewCell {
    @IBOutlet var LandmarkImage: UIImageView!
    @IBOutlet var LandmarkTitle: UILabel!
    @IBOutlet var LandmarkDescription: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
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
    var userTourLandmarks:[UserTourLandMark_] = []
    var Reviews:[Review_] = []
    let cal = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = userTourRelation.tour.name
        let dGroup = DispatchGroup()
        var utlList:[UserTourLandMark_] = []
        
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
        db.collection("userTourLandmarks").whereField("userTourRelation", isEqualTo: self.userTourRelation.id).addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else if let documents = querySnapshot?.documents {
                utlList = []
                for document in documents {
                    dGroup.enter()
                    let utl = UserTourLandMark_()
                    
                    utl.id = document.documentID
                    utl.user = document.data()["user"] as! String
                    utl.comment = document.data()["comment"] as! String
                    utl.state = document.data()["state"] as! Int
                    utl.successTime = document.data()["successTime"] as! Date
                    
                    self.db.collection("landmarks").document(document.data()["landmark"] as! String).addSnapshotListener { snapshot, err in
                        if let err = err {
                            print("Error getting document: \(err)")
                        } else if let data = snapshot?.data() {
                            let landmark = Landmark_()
                            landmark.tour.id = data["tour"] as! String
                            landmark.detail = data["detail"] as! String
                            landmark.image = data["image"] as! String
                            landmark.name = data["name"] as! String
                            
                            landmark.location.append((data["lati1"] as! Double, data["longi1"] as! Double))
                            landmark.location.append((data["lati2"] as! Double, data["longi2"] as! Double))
                            landmark.location.append((data["lati3"] as! Double, data["longi3"] as! Double))
                            landmark.location.append((data["lati4"] as! Double, data["longi4"] as! Double))
                            utl.landmark = landmark
                            utlList.append(utl)
                            dGroup.leave()
                        }
                    }
                }
            }
            dGroup.notify(queue: .main) {   //// 4
                self.userTourLandmarks = utlList
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
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TourInfoCell") as! tourInfoCell
        
        let now = NSDate()
        let DHM: Set<Calendar.Component> = [.day, .hour, .minute]
        let proceedTime = NSCalendar.current.dateComponents(DHM, from: self.userTourRelation.startTime, to: now as Date);
        
        let day = "\(proceedTime.day!)"
        let hour = "\(proceedTime.hour!)"
        let minute = "\(proceedTime.minute!)"
        
        let timeLimit = self.userTourRelation.tour.timeLimit
        let timeLeft = timeLimit - ((proceedTime.day!) * 1440 + (proceedTime.hour!) * 60 + (proceedTime.minute!))
        let dayLeft = "\(timeLeft / 1440)"
        let hourLeft = "\((timeLeft % 1440) / 60)"
        let minuteLeft = "\(timeLeft % 60)"
        
        cell.clockIcon.image = UIImage(named: "icon-157349_640")
        if timeLeft >= 0 {
            if timeLeft >= 1440 { cell.timeLeft.text = "남은시간: " + dayLeft + "일 " + hourLeft + "시간 " + minuteLeft + "분" }
            else { cell.timeLeft.text = "남은시간: " + hourLeft + "시간 " + minuteLeft + "분" }
        }
        
        let count = userTourLandmarks.count
        var reached = 0
        for utl in userTourLandmarks {
            if utl.state == 1 { reached += 1 }
        }
        if count > 0 { cell.proceedRate.text = "\(reached)/\(count) (\(reached * 100 / count)%)" }
        else { cell.proceedRate.text = "0/0 (0%)" }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if mode == 0 { return userTourLandmarks.count } // 코스
        else if mode == 1 { return 1 } // 지도
        else { return Reviews.count } // 리뷰
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 코스
        if mode == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LandmarkListREUSE", for: indexPath) as! LandmarkCell
        
            let userLandmark = self.userTourLandmarks[indexPath.row]
            if userLandmark.state == 0 {
                let ThisLandmark = userLandmark.landmark
                cell.LandmarkTitle.text = ThisLandmark.name
                cell.LandmarkDescription.text = ThisLandmark.detail
                cell.submitButton.tag = indexPath.row
                cell.cellDelegate = self
                
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
            } else {
                cell.LandmarkTitle.text = userLandmark.landmark.name
                cell.LandmarkDescription.text = userLandmark.comment
                
                // 버튼을 없애고 성공 라벨로 변경 혹은 버튼을누를수 없게..
                // 이미지 추가
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
        let landmark = userTourLandmarks[tag].landmark

        guard let locValue: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
        
        let rect = GMSMutablePath()
        for marker in landmark.location {
            rect.add(CLLocationCoordinate2D(latitude: marker.0, longitude: marker.1))
        }
        let polygon = GMSPolygon(path: rect)
        if GMSGeometryContainsLocation(locValue, polygon.path!, true) {
        }
        else {
            
            self.navigationController?.popViewController(animated: true)
            let alertController = UIAlertController(title: "Info", message: "아직 위치에 도달하지 않으셨군요!!\n좀 더 가까이 가서 인증해보세요!!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "확인", style: .cancel, handler: { (alert: UIAlertAction!) in
            })
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // 테이블 뷰 셀의 세로 길이 설정
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if mode == 0 { return 127.0 } // 코스
        else if mode == 1 { return 250.0 } // 지도
        else { return 65.0 } // 리뷰
    }
    
    @IBAction func TourListToLandmarkInfo(segue: UIStoryboardSegue){
        if segue.identifier == "locationCertificateDone" {
            self.tableView.reloadData()
        }
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
        if segue.identifier == "LandmarkInfoGO" {
            let dest = segue.destination as! UINavigationController
            let destTarget = dest.topViewController as! LandmarkInfoVC
            
            destTarget.tourName = self.userTourRelation.tour.name
            destTarget.ThisLandmark = self.userTourLandmarks[(self.tableView.indexPathForSelectedRow?.row)!].landmark
        }
        
        if segue.identifier == "locationCertificationSegue" {
            if let nextVC = segue.destination as? LocationCertificationVC {
                if let tag = (sender as? UIButton)?.tag {
                    nextVC.utl = userTourLandmarks[tag]
                }
            }
        }
    }

}
