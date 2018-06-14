import UIKit
import GoogleMaps

class CreateLandmarkLocationVC: UIViewController {
    var counterMarker: Int = 0
    var allMarkers:[GMSMarker] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let alertController = UIAlertController(title: "Info", message: "원하는 위치의 네개의 꼭지점을 찾아 길게 눌러주세요.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        
        let camera = GMSCameraPosition.camera(withLatitude: 37.554974, longitude: 127.072699, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        view = mapView
    }
}

extension CreateLandmarkLocationVC: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        // Custom logic here
        if counterMarker < 4 {
            let marker = GMSMarker()
            marker.position = coordinate
            marker.title = "길게 누르면 없어집니다."
            allMarkers.append(marker)
            counterMarker += 1
            // Create the polygon, and assign it to the map.
            mapView.clear()
            let rect = reorderMarkersClockwise(mapView)
            for mark in allMarkers {
                mark.map = mapView
            }
            let polygon = GMSPolygon(path: rect)
            polygon.fillColor = UIColor(red: 0.25, green: 0, blue: 0, alpha: 0.05);
            polygon.strokeColor = .black
            polygon.strokeWidth = 2
            polygon.map = mapView
            
        }
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        marker.map = nil
        for (index, cmark) in allMarkers.enumerated() {
            if cmark.position.latitude == marker.position.latitude, cmark.position.longitude == marker.position.longitude {
                allMarkers.remove(at: index)
                break;
            }
        }
        counterMarker -= 1
        
        mapView.clear()
        let rect = reorderMarkersClockwise(mapView)
        for mark in allMarkers {
            mark.map = mapView
        }
        
        // Create the polygon, and assign it to the map.
        let polygon = GMSPolygon(path: rect)
        polygon.fillColor = UIColor(red: 0.25, green: 0, blue: 0, alpha: 0.05);
        polygon.strokeColor = .black
        polygon.strokeWidth = 2
        polygon.map = mapView
    }
    
    // 마커가 잘 찍히도록(교차가 일어나지 않도록)
    func reorderMarkersClockwise(_ mapView: GMSMapView) -> GMSMutablePath {
        let rect = GMSMutablePath()
        if (counterMarker > 1) {
            let arr = allMarkers.map{$0.position}.sorted(by: isLess)
            for pos in arr {
                rect.add(pos)
            }
        } else {
            for mark in allMarkers {
                rect.add(mark.position)
            }
        }
        return rect
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // 꼭짓점이 4개 미만인 경우 오류 출력
        if identifier == "CreateMapDone" {
            if counterMarker < 4 {
                let alertController = UIAlertController(title: "Error", message: "꼭짓점을 4개 찍어 주세요.", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                
                return false
            }
        }
        
        return true
    }
    
    func isLess(_ a: CLLocationCoordinate2D, _ b: CLLocationCoordinate2D) -> Bool {
        let center = getCenterPointOfPoints()
        
        if (a.latitude >= 0 && b.latitude < 0) {
            return true
        } else if (a.latitude == 0 && b.latitude == 0) {
            return a.longitude > b.longitude
        }
        
        let det = (a.latitude - center.latitude) * (b.longitude - center.longitude) - (b.latitude - center.latitude) * (a.longitude - center.longitude)
        if (det < 0) {
            return true
        } else if (det > 0) {
            return false
        }
        
        let d1 = (a.latitude - center.latitude) * (a.latitude - center.latitude) + (a.longitude - center.longitude) * (a.longitude - center.longitude)
        let d2 = (b.latitude - center.latitude) * (b.latitude - center.latitude) + (b.longitude - center.longitude) * (b.longitude - center.longitude)
        return d1 > d2
    }
    
    func getCenterPointOfPoints() -> CLLocationCoordinate2D {
        let arr = allMarkers.map {$0.position}
        let s1: Double = arr.map{$0.latitude}.reduce(0, +)
        let s2: Double = arr.map{$0.longitude}.reduce(0, +)
        let c_lat = arr.count > 0 ? s1 / Double(arr.count) : 0.0
        let c_lng = arr.count > 0 ? s2 / Double(arr.count) : 0.0
        return CLLocationCoordinate2D.init(latitude: c_lat, longitude: c_lng)
    }
}
