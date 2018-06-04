//
//  CreateLandmarkLocationVC.swift
//  twiths_
//
//  Created by yeon suk choi on 2018. 6. 4..
//  Copyright © 2018년 yeon suk choi. All rights reserved.
//

import UIKit
import GoogleMaps

class CreateLandmarkLocationVC: UIViewController {
    var counterMarker: Int = 0
    var allMarkers:[GMSMarker] = [] 
    
    
    // You don't need to modify the default init(nibName:bundle:) method.
    
    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        view = mapView
        
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // 모든 정보를 입력하지 않은 경우 오류 메시지 출력
        if identifier == "CreateMapDone" {
            if counterMarker != 4{
                let alertController = UIAlertController(title: "Info", message: "4개의 핀이 찍혀야합니다.", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                return false
            }
        }
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }
}

extension CreateLandmarkLocationVC: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        // Custom logic here
        if counterMarker < 4 {
            let marker = GMSMarker()
            marker.position = coordinate
            marker.title = "I added this with a long tap"
            marker.snippet = ""
            allMarkers.append(marker)
            counterMarker += 1
            // Create the polygon, and assign it to the map.
            mapView.clear()
            let rect = GMSMutablePath()
            for mark in allMarkers {
                rect.add(mark.position)
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
        let rect = GMSMutablePath()
        for mark in allMarkers {
            rect.add(mark.position)
            mark.map = mapView
        }
        
        // Create the polygon, and assign it to the map.
        let polygon = GMSPolygon(path: rect)
        polygon.fillColor = UIColor(red: 0.25, green: 0, blue: 0, alpha: 0.05);
        polygon.strokeColor = .black
        polygon.strokeWidth = 2
        polygon.map = mapView
    }
}
