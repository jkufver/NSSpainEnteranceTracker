//
//  MonitoringEngine.swift
//  NSSpainEnteranceTracker
//
//  Created by Jens Kufver on 2014-09-17.
//  Copyright (c) 2014 Jens Kufver. All rights reserved.
//

import Foundation
import CoreLocation

private let _singletonInstance = MonitoringEngine()

class MonitoringEngine: NSObject, CLLocationManagerDelegate {
    
    
    var locationManager = CLLocationManager()
    
    
    class var sharedInstance: MonitoringEngine {
        return _singletonInstance
    }
    
    override init() {
        super.init()
        locationManager.delegate = self

//        let BeaconIdentifier = "se.kufver.NSSpainEnteranceTracker"
//        let ourUUID = NSUUID(UUIDString: "8C2486A0-3E4F-11E4-916C-0800200C9A66")
//        let region = CLBeaconRegion(proximityUUID: ourUUID, identifier: BeaconIdentifier)
//        
//        region = locationManager.monitoredRegions.member(region)
        startMonitoring()
    }
    
    func startMonitoring() {
        let beaconIdentifier = "com.example.apple-samplecode.AirLocate"
        let defaultProximityUUID = NSUUID(UUIDString: "8C2486A0-3E4F-11E4-916C-0800200C9A66")
        
        // if region monitoring is enabled, update the region being monitored
        let region = CLBeaconRegion(proximityUUID: defaultProximityUUID, identifier: beaconIdentifier)
        
        region.notifyOnEntry = false
        region.notifyOnExit = false
        region.notifyEntryStateOnDisplay = false;
        
        locationManager.startMonitoringForRegion(region)
        locationManager.startRangingBeaconsInRegion(region)
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        
        for b in beacons {
            println(b.description)
        }
    }

}



