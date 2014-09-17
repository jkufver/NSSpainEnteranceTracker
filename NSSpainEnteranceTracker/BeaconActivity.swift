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
    var timeStamp : String!
    var proximityUUID : NSUUID!
    var major : NSNumber!
    var minor : NSNumber!
    var proximity : CLProximity!
    var accuracy : CLLocationAccuracy!
    var rssi : Int!
    
    override var description: String {
        return String(format: "Timestamp:%@,UUID:%@,Major:%@,Minor:%@,Proximity:%d,Accuracy:%.2f,RSSI:%d\n",timeStamp,proximityUUID.UUIDString,major.stringValue,minor.stringValue,proximity.hashValue,accuracy,rssi)
    }
}
