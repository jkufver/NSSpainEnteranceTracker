//
//  BeaconSignalDispatcher.swift
//  NSSpainEnteranceTracker
//
//  Created by Dorin Danciu on 17/09/14.
//  Copyright (c) 2014 Jens Kufver. All rights reserved.
//

import Foundation
import CoreLocation

enum LocationRelatedToVenue : Int{
    case Unknown
    case Inside
    case Outside
    case InBetween
    
    func simpleDescription() -> String {
        switch self {
        case .Unknown:
            return "Unknown"
        case .Inside:
            return "Inside"
        case .Outside:
            return "Outside"
        case .InBetween:
            return "InBetween"
        }
    }
}

protocol BeaconSignalDispatcherDelegate : NSObjectProtocol {
    func beaconSignalDispatcherDidSignalEventOfType(eventType: LocationRelatedToVenue, location:String)
}

private let _beaconSignalDispatcherSingletonInstance = BeaconSignalDispatcher()

class BeaconSignalDispatcher: NSObject, MonitoringEngineDelegate {
    var beacons   = Array<BeaconActivity>()
    var delegates = Array<BeaconSignalDispatcherDelegate>()
    var signals   = Array<AnyObject>()
    
    override init() {
        super.init()
        loadBeacons()
    }
    
    class var sharedInstance: BeaconSignalDispatcher {
        return _beaconSignalDispatcherSingletonInstance
    }
    
    func registerDelegate(item:BeaconSignalDispatcherDelegate) {
        delegates.append(item)
    }
    
    func removeDelegate(item:BeaconSignalDispatcherDelegate) {
        for (index, element) in enumerate(delegates) {
            if element === item {
                delegates.removeAtIndex(index)
            }
        }
    }
    
    func dequeue(){
        if let firstObj: AnyObject = signals.first {
            signals.removeAtIndex(0)
        }
    }
    
    func enqueue (item : AnyObject){
        if signals.count > 20 {
            dequeue()
        }
        signals.append(item)
    }
    
    func loadBeacons () {
        beacons.append(BeaconActivity())
        beacons.append(BeaconActivity())
    }
    
    func beaconForMinor(beacons: [AnyObject]!, minor: Int)->(AnyObject?) {
        for (index, element) in enumerate(beacons) {
            if element.minor == minor {
                return element
            }
        }
        return nil
    }
    
    func notifyObserversWithEventTypeAndLocation(aType:LocationRelatedToVenue, location:String) {
        println("Notification Sent! type: \(aType.simpleDescription()) | location: \(location)")
        for (index, element) in enumerate(delegates) {
            element.beaconSignalDispatcherDidSignalEventOfType(aType, location: location)
        }
    }
    
//    func handleBeaconSignal(beacon:BeaconActivity) {
//        if let prevBeacon = beaconForMinor(beacon.minor) {
//            if prevBeacon.proximity == beacon.proximity {
//                return
//            }
//            
//            switch prevBeacon.proximity {
////                case .Immediate:
////                    notifyObserversWithEventTypeAndLocation(.ExitImmediate, location: "\(beacon.minor)")
//                    
//                case .Near:
//                    notifyObserversWithEventTypeAndLocation(.ExitNear, location: "\(beacon.minor)")
//                default:
//                    break
//            }
//            
//            switch beacon.proximity {
////            case .Immediate:
////                notifyObserversWithEventTypeAndLocation(.EnterImmediate, location: "\(beacon.minor)")
//                
//            case .Near:
//                notifyObserversWithEventTypeAndLocation(.EnterNear, location: "\(beacon.minor)")
//            default:
//                break
//            }
//            
//            // update previous beacon
//            beacons[beacon.minor] = beacon;
//        } else {
//            beacons[beacon.minor] = beacon;
//        }
//    }
    
    func monitoringEngine(engine: MonitoringEngine!, didRangeBeacons beacons: [AnyObject]!) {
        var outside = beaconForMinor(beacons, minor: 0) as CLBeacon?
        var inside = beaconForMinor(beacons, minor: 1) as CLBeacon?
        
        if ((outside != nil && inside == nil)||(outside!.accuracy < inside!.accuracy)) {
            // outside
            println("outside")
            notifyObserversWithEventTypeAndLocation(.Outside, location: "Venue")
        } else if ((outside == nil && inside != nil)||(outside!.accuracy > inside!.accuracy)) {
            // inside
            println("inside")
            notifyObserversWithEventTypeAndLocation(.Inside, location: "Venue")
        } else {
            // in between
            println("in between")
            notifyObserversWithEventTypeAndLocation(.Unknown, location: "Venue")
        }
        
//        for (index, element) in enumerate(beacons) {
//            var beaconActivity = BeaconActivity(beacon: element as CLBeacon)
//            handleBeaconSignal(beaconActivity)
//        }
    }
}

