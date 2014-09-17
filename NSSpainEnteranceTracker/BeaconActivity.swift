//
//  BeaconActivity.swift
//  NSSpainEnteranceTracker
//
//  Created by Andreas Claesson on 17/09/14.
//  Copyright (c) 2014 Jens Kufver. All rights reserved.
//

import Foundation
import CoreLocation

class BeaconActivity: NSObject {
    var timeStamp : String?
    var proximityUUID : NSUUID?
    var major : NSNumber?
    var minor : NSNumber?
    var proximity : CLProximity = .Unknown
    var accuracy : CLLocationAccuracy?
    var rssi : Int?
    
    override var description: String {
        return customDescription()
    }
    
    func customDescription() -> String {
        return "Timestamp:\(timeStamp),UUID:\(proximityUUID),Major:\(major),Minor:\(minor),Proximity:\(proximity),Accuracy:\(accuracy),RSSI:\(rssi)"
    }
}
