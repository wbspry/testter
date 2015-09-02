//
//  MapViewController.swift
//  testter
//
//  Created by Naoki Fujii on 9/2/15.
//  Copyright © 2015 yyyske3. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {

    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startUserTracking()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startUserTracking() {
        if !CLLocationManager.locationServicesEnabled() {
            return
        }
        
        mapView.userTrackingMode = .Follow
        
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .AuthorizedAlways: fallthrough
        case .AuthorizedWhenInUse: mapView.showsUserLocation = true
        case .NotDetermined: locationManager.requestWhenInUseAuthorization()
        case .Restricted: break
        case .Denied: break
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        }
    }
}