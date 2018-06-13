//
//  LandmarkListVC.swift
//  twiths_
//
//  Created by ㅇㅇ on 2018. 5. 25..
//

import UIKit
import Firebase
import MapKit
import CoreLocation
import GoogleMaps
import Cosmos

protocol YourCellDelegate : class {
    func didPressButton(_ tag: Int)
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

// 리뷰 뷰 셀
class ReviewCell:UITableViewCell {
    @IBOutlet var reviewSubtitle: UILabel!
    @IBOutlet weak var starRating: CosmosView!
    @IBOutlet weak var nameLabel: UILabel!
}

class LandmarkListVC: UIViewController, UITableViewDataSource, YourCellDelegate, CLLocationManagerDelegate, UITableViewDelegate {
    
    var ID:Int = 0
    var userTourRelation = UserTourRelation_()
    var mode:Int = 0 // 0은 코스, 1은 지도, 2는 리뷰
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var clockIcon: UIImageView!
    @IBOutlet var timeLeft: UILabel!
    @IBOutlet var proceedRate: UILabel!
    @IBAction func menuSelectChanged(_ sender: UISegmentedControl) {
        mode = sender.selectedSegmentIndex
        if mode == 1 { self.view.bringSubview(toFront: mapView) }
        else { self.view.bringSubview(toFront: tableView) }
        
        self.tableView.reloadData()
    }
    
    let db = Firestore.firestore()
    let locationManager = CLLocationManager()
    var userTourLandmarks:[UserTourLandMark_] = []
    var Reviews:[Review_] = []
    let cal = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = userTourRelation.tour.name
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let dGroup = DispatchGroup()
        var utlList:[UserTourLandMark_] = []
        
        guard let location = locationManager.location else { return }
        guard let locValue: CLLocationCoordinate2D = location.coordinate else { return }
        let camera = GMSCameraPosition.camera(withTarget: locValue, zoom: 8.0)
        let gsMapView = GMSMapView.map(withFrame: mapView.bounds, camera: camera)
        
        
        gsMapView.delegate = self
        gsMapView.isMyLocationEnabled = true
        mapView.addSubview(gsMapView)
        
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
                    utl.image = document.data()["image"] as! String
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
                
                self.timeLeft.text = getProceedTime(self.userTourRelation) + " 째 진행중!"
                let count = self.userTourLandmarks.count
                var reached = 0
                for utl in self.userTourLandmarks {
                    if utl.state == 1 { reached += 1 }
                }
                if count > 0 { self.proceedRate.text = "\(reached)/\(count) (\(reached * 100 / count)%)" }
                else { self.proceedRate.text = "0/0 (0%)" }
                
                
                // 맵뷰에 랜드마크 위치 찍기
                for utl in self.userTourLandmarks {
                    let rect = GMSMutablePath()
                    for location in utl.landmark.location {
                        let marker = GMSMarker()
                        marker.position = CLLocationCoordinate2D(latitude: location.0, longitude: location.1)
                        marker.title = utl.landmark.name
                        marker.map = gsMapView
                        rect.add(marker.position)
                    }
                    let polygon = GMSPolygon(path: rect)
                    polygon.fillColor = UIColor(red: 0.25, green: 0, blue: 0, alpha: 0.05);
                    polygon.strokeColor = .black
                    polygon.strokeWidth = 2
                    polygon.map = gsMapView
                }

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
                    review.id = document.documentID as! String
                    review.name = document.data()["name"] as! String
                    review.stars = document.data()["stars"] as! Double
                    review.tour.id = document.data()["tour"] as! String
                    review.comment = document.data()["comment"] as! String
                    
                    Revs.append(review)
                }
                self.Reviews = Revs
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
        if mode == 0 { return userTourLandmarks.count } // 코스
        else if mode == 1 { return 0 } // 지도
        else { return Reviews.count } // 리뷰
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 코스
        if mode == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "LandmarkListREUSE", for: indexPath) as! LandmarkCell
            
            // 이미지 뷰를 원형으로
            cell.LandmarkImage.layer.cornerRadius = cell.LandmarkImage.frame.size.width / 2
            cell.LandmarkImage.layer.masksToBounds = true
            let userLandmark = self.userTourLandmarks[indexPath.row]
            let ThisLandmark = userLandmark.landmark
            print("---\(ThisLandmark.image)---\(userLandmark.image)")
            
            if let titleLabel = cell.submitButton.titleLabel {
                titleLabel.adjustsFontSizeToFitWidth = true;
                titleLabel.minimumScaleFactor = 0.5; // set whatever factor you want to set
            }
            
            // 셀에 이미지를 불러오기 위한 이미지 이름, 저장소 변수
            var imgName = ""
            if userLandmark.state == 0 { imgName = ThisLandmark.image }
            else { imgName = userLandmark.image }
            print("---\(imgName)")
            
            let storRef = Storage.storage().reference(forURL: "gs://twiths-350ca.appspot.com").child(imgName)
            
            // 셀에 이미지 불러오기. 임시로 64*1024*1024, 즉 64MB를 최대로 하고, 논의 후 변경 예정.
            storRef.getData(maxSize: 64 * 1024 * 1024) { Data, Error in
                if Error != nil {
                    // 오류가 발생함.
                } else if let Data = Data {
                    cell.LandmarkImage.image = UIImage(data: Data)
                }
            }
            
            if userLandmark.state == 0 {
                cell.LandmarkTitle.text = ThisLandmark.name
                cell.LandmarkDescription.text = ThisLandmark.detail
                cell.submitButton.tag = indexPath.row
                cell.cellDelegate = self
            } else {
                cell.LandmarkTitle.text = userLandmark.landmark.name
                cell.LandmarkDescription.text = userLandmark.comment
                cell.submitButton.setTitle("성공", for: UIControlState.normal)
                cell.submitButton.isEnabled = false
                cell.submitButton.alpha = 1.0;
                cell.submitButton.setTitleColor(UIColor.green, for: .disabled)
            }
            
            return cell
        }
            
            // 지도
        else if mode == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "LandmarkListREUSE", for: indexPath) as! LandmarkCell
            
            return cell
        }
            
            // 리뷰
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewREUSE", for: indexPath) as! ReviewCell
            
            let ThisReview = Reviews[indexPath.row]
            
            cell.starRating.rating = ThisReview.stars
            cell.nameLabel.text = ThisReview.name
            cell.reviewSubtitle.text = ThisReview.comment
            
            
            return cell
        }
    }
    
    func didPressButton(_ tag: Int) {
        let landmark = userTourLandmarks[tag].landmark
        
        guard let location = locationManager.location else { return }
        let locValue: CLLocationCoordinate2D = location.coordinate
        
        let rect = GMSMutablePath()
        for marker in landmark.location {
            rect.add(CLLocationCoordinate2D(latitude: marker.0, longitude: marker.1))
        }
        let polygon = GMSPolygon(path: rect)
        guard let path = polygon.path else { return }
        if GMSGeometryContainsLocation(locValue, path, true) {
        }
        else {
            
            print("\(locValue.latitude)/\(locValue.longitude)") // test
            
            guard let navController = self.navigationController else { return }
            navController.popViewController(animated: true)
            let alertController = UIAlertController(title: "Info", message: "아직 위치에 도달하지 않으셨군요!!\n좀 더 가까이 가서 인증해보세요!!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // 테이블 뷰 셀의 세로 길이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if mode == 0 { return 127.0 } // 코스
        else if mode == 1 { return 250.0 } // 지도
        else { return 80.0 } // 리뷰
    }
    @IBAction func TourListToLandmarkInfo(segue: UIStoryboardSegue){
    }
    @IBAction func TourListToLandmarkInfo(sender: UIStoryboardSegue){
        var utlID = ""
        if sender.identifier == "locationCertificateDone" {
            if sender.source is LocationCertificationVC {
                if let senderVC = sender.source as? LocationCertificationVC {
                    utlID = senderVC.utl.id
                }
            }
            var isClear = true
            for utl in userTourLandmarks {
                if utl.id == utlID { continue }
                if utl.state == 0 {
                    isClear = false
                    break;
                }
            }
            if isClear == true {
                userTourRelation.state = 3
                let utrRef = db.collection("userTourRelations").document(userTourRelation.id)
                utrRef.updateData([
                    "state" : 3,
                    "endTime" : Date()
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }
                let alertController = UIAlertController(title: "Info", message: "축하합니다!!!\n투어를 \(getProceedTime(userTourRelation)) 만에 완료하셨습니다.\n이 투어에 대한 리뷰를 작성하시겠습니까? ", preferredStyle: .alert)
                
                let okayAction = UIAlertAction(title: "예", style: .cancel, handler:{ (alert: UIAlertAction!) in
                    guard let storyboard = self.storyboard else { return }
                    let controller = storyboard.instantiateViewController(withIdentifier: "CreateReviewRoot") as! UINavigationController
                    let topController = controller.topViewController as! CreateReviewVC
                    topController.tour = self.userTourRelation.tour
                    
                    self.present(controller,animated:true,completion:nil)
                    
                })
                
                guard let nvC = self.navigationController else { return }
                let noAction = UIAlertAction(title: "아니요", style: .default, handler: { (alert: UIAlertAction!) in
                    nvC.popToRootViewController(animated: true)
                })
                alertController.addAction(okayAction)
                alertController.addAction(noAction)
                self.present(alertController, animated: true, completion: nil)
            }
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
            
            guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
            destTarget.tourName = self.userTourRelation.tour.name
            destTarget.ThisLandmark = self.userTourLandmarks[indexPath.row].landmark
        }
        
        if segue.identifier == "locationCertificationSegue" {
            if let nextVC = segue.destination as? LocationCertificationVC {
                let senderBtn = sender as? UIButton
                if let tag = (sender as? UIButton)?.tag {
                    nextVC.utl = userTourLandmarks[tag]
                }
            }
        }
    }
    
}

extension LandmarkListVC: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        // Custom logic here
    }
}
