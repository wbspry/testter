//
//  BeaconViewController.swift
//  testter
//
//  Created by Naoki Fujii on 9/3/15.
//  Copyright © 2015 yyyske3. All rights reserved.
//

import UIKit
import CoreLocation

class BeaconViewController: UIViewController {

    @IBOutlet weak var UUIDLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var minorLabel: UILabel!
    @IBOutlet weak var rssiLabel: UILabel!
    @IBOutlet weak var proximityLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let beaconRegion: CLBeaconRegion = {
        let proximityUUID = NSUUID(UUIDString: "E1D9D437-B630-4764-A2B8-E37DD37C0E71") // beaconのUUIDを設定
        let identifier = "yyyske3.testter" // なんでもokだけどユニークなもの
        return CLBeaconRegion(proximityUUID: proximityUUID!, identifier: identifier)
    }()
    
    var nearestBeacon: CLBeacon? {
        didSet(oldValue) {
            var uuidString = "見つからない"
            var majorString = "---"
            var minorString = "---"
            var rssiString = "---"
            var proximityString = "---"
            
            if let nearestBeacon = nearestBeacon {
                uuidString = nearestBeacon.proximityUUID.UUIDString
                majorString = nearestBeacon.major.stringValue
                minorString = nearestBeacon.minor.stringValue
                rssiString = String(nearestBeacon.rssi)
                proximityString = stringFromProximity[nearestBeacon.proximity]!
                
                showBeaconAlert()
            }
            
            UUIDLabel.text = uuidString
            majorLabel.text = majorString
            majorLabel.text = minorString
            rssiLabel.text = rssiString
            proximityLabel.text = proximityString
        }
    }
    
    let stringFromProximity: [CLProximity:String] = [.Unknown : "わからない", .Immediate : "すぐ近く！", .Near : "近い・・", .Far : "遠い"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        startMonitoring()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showBeaconAlert() {
        let alertController = UIAlertController(title: "＼(^o^)／", message: "iBeaconが見つかりました！", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func startMonitoring() {
        // 使えなかったら 何もしない
        if !CLLocationManager.isMonitoringAvailableForClass(CLBeaconRegion.self) {
            return
        }
        if !CLLocationManager.locationServicesEnabled() {
            return
        }
        
        let status = CLLocationManager.authorizationStatus()
        switch status {
            // すでにユーザーから許可もらってるのでリージョン監視開始
        case .AuthorizedAlways: locationManager.startMonitoringForRegion(beaconRegion)
            // ユーザーからAuthorizedAlwaysの許可をもらう
        case .AuthorizedWhenInUse: fallthrough
        case .NotDetermined: locationManager.requestAlwaysAuthorization()
        case .Restricted: break
        case .Denied: break
        }
        
    }
}

extension BeaconViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("\(__FUNCTION__)")

        // AuthorizedAlwaysならリージョン監視開始
        if status == .AuthorizedAlways {
            locationManager.startMonitoringForRegion(beaconRegion)
        }
    }
    
    // リージョン監視開始
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        print("\(__FUNCTION__)")

        // 対象リージョンでの現在の状態を確認するために要求
        locationManager.requestStateForRegion(region)
    }
    
    // 対象リージョンでの現在の状態を通知される
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        print("\(__FUNCTION__)")

        switch state {
        case .Inside:
            // 領域内ならbeaconの情報を取りに行く
            if let region = region as? CLBeaconRegion where CLLocationManager.isRangingAvailable() {
                locationManager.startRangingBeaconsInRegion(region)
            }
            break
        case .Outside:
            break
        case .Unknown:
            break
        }
    }
    
    // 領域入った時
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("\(__FUNCTION__)")

        // 領域内ならbeaconの情報を取りに行く
        if let region = region as? CLBeaconRegion where CLLocationManager.isRangingAvailable() {
            locationManager.startRangingBeaconsInRegion(region)
        }
    }
    
    // 領域出た時
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("\(__FUNCTION__)")
    }
    
    // beaconの情報がとれた時
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        print("\(__FUNCTION__)")
        nearestBeacon = beacons.first
    }
}