//
//  AppDelegate.swift
//  NSSpainEnteranceTracker
//
//  Created by Jens Kufver on 2014-09-17.
//  Copyright (c) 2014 Jens Kufver. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        let engine = MonitoringEngine.sharedInstance
        let dispatcher = BeaconSignalDispatcher.sharedInstance
        engine.registerDelegate(dispatcher)
        
        println(engine)
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
//    func startMonitoring() {
//        let beaconIdentifier = "com.example.apple-samplecode.AirLocate"
//        
//
//        let defaultProximityUUID = NSUUID(UUIDString: "8C2486A0-3E4F-11E4-916C-0800200C9A66")
//       
//        // if region monitoring is enabled, update the region being monitored
//        let region = CLBeaconRegion(proximityUUID: defaultProximityUUID, identifier: beaconIdentifier)
//
//        region.notifyOnEntry = false
//        region.notifyOnExit = false
//        region.notifyEntryStateOnDisplay = false
//
//        MEBe
//        
////            [[MEBeaconMonitoringManager sharedManager] startMonitoringForRegion:region];
////            [[MEBeaconMonitoringManager sharedManager] startRanging];
////            
////            [[MEBeaconSignalDispatcher sharedManager] loadBeaconsFor:@"Beacons_InnovationLab"];
////            [[MEBeaconSignalDispatcher sharedManager] startDispatcher];
////        }
//    }

    
//    func locationManager(manager: CLLocationManager!, didDetermineState state: CLRegionState, forRegion region: CLRegion!) {
//        
//        let notification = UILocalNotification();
//        var message: String;
//        
//        switch state {
//        case .Inside:
//            message = "Notify – you are inside the region"
//        case .Outside:
//            message = "Notify – you are outside the region"
//        default:
//            return
//        }
//
//        // Do something
//    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        // If the application is in the foreground, we will notify the user of the region's state via an alert.
        UIAlertView(title: notification.alertBody, message: nil, delegate: nil, cancelButtonTitle: "OK").show()
    }
}

