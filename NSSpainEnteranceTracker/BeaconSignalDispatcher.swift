//
//  BeaconSignalDispatcher.swift
//  NSSpainEnteranceTracker
//
//  Created by Dorin Danciu on 17/09/14.
//  Copyright (c) 2014 Jens Kufver. All rights reserved.
//

import Foundation
import CoreLocation

enum BeaconEventType : Int{
    case Unknown
    case EnterNear
    case ExitNear
    case EnterImmediate
    case ExitImmediate
}

protocol BeaconSignalDispatcherDelegate : NSObjectProtocol {
    func beaconSignalDispatcherDidSignalEventOfType(eventType: BeaconEventType, location:String)
}

private let _beaconSignalDispatcherSingletonInstance = BeaconSignalDispatcher()

class BeaconSignalDispatcher: NSObject, MonitoringEngineDelegate {
    var beacons   = Array<BeaconActivity>()
    var delegates = Array<BeaconSignalDispatcherDelegate>()
    var signals   = Array<AnyObject>()
    
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
    
    func beaconForMinor(minor: Int)->(BeaconActivity?) {
        for (index, element) in enumerate(beacons) {
            if element.minor == minor {
                return element
            }
        }
        return nil
    }
    
    func notifyObserversWithEventTypeAndLocation(aType:BeaconEventType, location:String) {
        println("Notification Sent! type: \(aType) | location: \(location)")
        for (index, element) in enumerate(delegates) {
            element.beaconSignalDispatcherDidSignalEventOfType(aType, location: location)
        }
    }
    
    func handleBeaconSignal(beacon:BeaconActivity) {
        if let prevBeacon = beaconForMinor(beacon.minor) {
            if prevBeacon.proximity == beacon.proximity {
                return
            }
            
            switch prevBeacon.proximity {
                case .Immediate:
                    notifyObserversWithEventTypeAndLocation(.ExitImmediate, location: "test")
                    
                case .Near:
                    notifyObserversWithEventTypeAndLocation(.ExitNear, location: "test")
                default:
                    break
            }
            
            switch beacon.proximity {
            case .Immediate:
                notifyObserversWithEventTypeAndLocation(.EnterImmediate, location: "test")
                
            case .Near:
                notifyObserversWithEventTypeAndLocation(.EnterNear, location: "test")
            default:
                break
            }
            
            // update previous beacon
            beacons[beacon.minor] = beacon;
        } else {
            beacons[beacon.minor] = beacon;
        }
    }
    
    func monitoringEngine(engine: MonitoringEngine!, didRangeBeacons beacons: [AnyObject]!) {
        for (index, element) in enumerate(beacons) {
            var beaconActivity = BeaconActivity(beacon: element as CLBeacon)
            handleBeaconSignal(beaconActivity)
        }
    }
}

