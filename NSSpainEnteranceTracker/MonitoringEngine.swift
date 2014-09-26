//
//  MonitoringEngine.swift
//  NSSpainEnteranceTracker
//
//  Created by Jens Kufver on 2014-09-17.
//  Copyright (c) 2014 Jens Kufver. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

// General search criteria for beacons that are broadcasting
//let BEACON_PROXIMITY_UUID = NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D") // Estimote
 let BEACON_PROXIMITY_UUID = NSUUID(UUIDString: "8C2486A0-3E4F-11E4-916C-0800200C9A66") // NSSpain

// Beacons are hardcoded into our app so we can easily filter for them in a noisy environment
let BEACON_OUTSIDE_MINOR = 0 //33011
let BEACON_INSIDE_MINOR = 1 //42851

let region = CLBeaconRegion(proximityUUID:BEACON_PROXIMITY_UUID, identifier:"Estimote region")


protocol MonitoringEngineDelegate : NSObjectProtocol {
    func monitoringEngine(engine: MonitoringEngine!, didRangeBeacons beacons: [AnyObject]!)
}

private let _singletonInstance = MonitoringEngine()

class MonitoringEngine: NSObject, CLLocationManagerDelegate {
    class var sharedInstance: MonitoringEngine {
        return _singletonInstance
    }
    
    var locationManager: CLLocationManager = CLLocationManager()
    var isMonitoring = false
    var isRanging = false

    var delegates = Array<MonitoringEngineDelegate>()
    
    func registerDelegate(item:MonitoringEngineDelegate) {
        delegates.append(item)
    }
    
    func removeDelegate(item:MonitoringEngineDelegate) {
        for (index, element) in enumerate(delegates) {
            if element === item {
                delegates.removeAtIndex(index)
            }
        }
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC))
            dispatch_after(time, dispatch_get_main_queue()) {
            
            switch CLLocationManager.authorizationStatus() {
            case .Authorized: self.startMonitoring()
            case .AuthorizedWhenInUse: self.locationManager.requestAlwaysAuthorization()
            case .Denied: UIAlertView(title: "Can't start", message: "Location services are .Denied for this app", delegate: nil, cancelButtonTitle: "OK").show()
            case .NotDetermined: self.locationManager.requestAlwaysAuthorization()
            case .Restricted: UIAlertView(title: "Can't start", message: "Location services are .Restricted for this app", delegate: nil, cancelButtonTitle: "OK").show()
            }
        }
    }
    
    func startMonitoring() {
        if !isMonitoring {
            println("BM start")
            isMonitoring = true
        } else {
            println("BM start (noop - already monitoring)")
            return
        }
        
        locationManager.startMonitoringForRegion(region)
    }
    
    func stopMonitoring() {
        println("BM stop")
        locationManager.stopMonitoringForRegion(region)
        isMonitoring = false
    }
    
    func startRanging() {
        if !isRanging {
            println("BM ranging start")
            isRanging = true
        } else {
            println("BM ranging start (noop - already ranging)")
            return
        }
        
        locationManager.startRangingBeaconsInRegion(region)
    }
    
    func stopRanging() {
        println("BM stop")
        locationManager.stopRangingBeaconsInRegion(region)
        isMonitoring = false
    }
    
    //  CLLocationManagerDelegate methods
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        println("BM didChangeAuthorizationStatus \(status.toRaw())")
        if status == .Authorized {
            startMonitoring()
        } else {
            stopMonitoring()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
        println("BM didStartMonitoringForRegion")
        locationManager.requestStateForRegion(region) // should locationManager be manager?
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion:CLRegion) {
        println("BM didEnterRegion \(didEnterRegion.identifier)")
        
        if let beaconRegion = didEnterRegion as? CLBeaconRegion  {
            manager.startRangingBeaconsInRegion(beaconRegion)
        }
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion:CLRegion) {
        println("BM didExitRegion \(didExitRegion.identifier)")

        if let beaconRegion = didExitRegion as? CLBeaconRegion  {
            manager.stopRangingBeaconsInRegion(beaconRegion)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didDetermineState state: CLRegionState, forRegion region: CLRegion!) {
        println("BM didDetermineState \(state.toRaw())")
        
        switch state {
        case .Inside:
            println("BeaconManager:didDetermineState CLRegionState.Inside \(region.identifier)")
            startRanging()
        case .Outside:
            println("BeaconManager:didDetermineState CLRegionState.Outside")
            stopRanging()
        case .Unknown:
            println("BeaconManager:didDetermineState CLRegionState.Unknown")
        default:
            println("BeaconManager:didDetermineState default")
        }
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        println("beacons.count: \(beacons.count)")
        
        for beacon in beacons {
            println("beacon: \(beacon)")
        }
        for delegate in delegates {
            delegate.monitoringEngine(self, didRangeBeacons: beacons)
        }
    }
}

