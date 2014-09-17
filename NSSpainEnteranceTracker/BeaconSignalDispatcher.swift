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

let MinAccuracyLevel = 3.0

protocol BeaconSignalDispatcherDelegate : NSObjectProtocol {
    func beaconSignalDispatcherDidSignalEventOfType(eventType: BeaconEventType, location:String)
}

class BeaconSignalDispatcher: NSObject {
    var beacons   = Array<BeaconActivity>()
    var delegates = Array<BeaconSignalDispatcherDelegate>()
    var signals   = Array<AnyObject>()
    
    private let _singletonInstance = BeaconSignalDispatcher()
    
    func sharedInstance()-> BeaconSignalDispatcher {
        return _singletonInstance
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
        var outdoor = BeaconActivity()
        outdoor.major = 1
        outdoor.minor = 0
        
        beacons.append(outdoor)
        
        
        var indoor = BeaconActivity()
        indoor.major = 1
        indoor.minor = 1
        
        beacons.append(indoor)
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
    
    func handleBeaconSignal(beacon:CLBeacon) {
        if let staticBeacon = beaconForMinor(beacon.minor) {
            if staticBeacon.proximity == beacon.proximity {
                return
            }
            
            switch staticBeacon.proximity {
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
            
            staticBeacon.proximity = beacon.proximity;
        }
    }
}

