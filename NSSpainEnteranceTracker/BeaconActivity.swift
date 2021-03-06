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
    
    
    override init() {
        // perform some initialization here
        let dateFormater : NSDateFormatter = NSDateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss:sss"
        self.timeStamp = String(format:"%@", dateFormater.stringFromDate(NSDate()))
        self.proximityUUID = NSUUID(UUIDString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")
        self.major = 999
        self.minor = 999
        self.proximity = .Unknown
        self.accuracy = 999
        self.rssi = 123456
    }
    
    convenience init(beacon:CLBeacon) {
        self.init()
        self.proximityUUID = beacon.proximityUUID
        self.major = beacon.major
        self.minor = beacon.minor
        self.proximity = beacon.proximity
        self.accuracy = beacon.accuracy
        self.rssi = beacon.rssi
    }
    
    override var description: String {
        return String(format: "Timestamp:%@,UUID:%@,Major:%@,Minor:%@,Proximity:%d,Accuracy:%.2f,RSSI:%d\n",timeStamp,proximityUUID.UUIDString,major.stringValue,minor.stringValue,proximity.hashValue,accuracy,rssi)
    }

    var jsonDescription: String {
        var error : NSError?
        let dict = ["Timestamp":timeStamp,
                    "UUID":proximityUUID.UUIDString,
                    "Major":major,
                    "Minor":minor,
                    "Proximity":proximity.hashValue,
                    "Accuracy":accuracy,
                    "RSSI":rssi]
        return (NSString(data: NSJSONSerialization.dataWithJSONObject(dict, options: nil, error: &error)!, encoding: NSUTF8StringEncoding) + "\n") as String
    }
}
