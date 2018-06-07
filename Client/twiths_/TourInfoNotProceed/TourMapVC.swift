//
//  CreateLandmarkLocationVC.swift
//  twiths_
//
//  Created by yeon suk choi on 2018. 6. 4..
//  Copyright © 2018년 yeon suk choi. All rights reserved.
//

import UIKit
import GoogleMaps

class TourMapVC: UIViewController {
    var counterMarker: Int = 0
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }
}

extension TourMapVC: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        // Custom logic here
    }
}
