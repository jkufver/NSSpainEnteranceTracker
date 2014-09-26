//
//  FirstViewController.swift
//  NSSpainEnteranceTracker
//
//  Created by Jens Kufver on 2014-09-17.
//  Copyright (c) 2014 Jens Kufver. All rights reserved.
//

import UIKit
import CoreLocation

class FirstViewController: UIViewController, MonitoringEngineDelegate, BeaconSignalDispatcherDelegate {

    @IBOutlet var outsideBeaconImageView: UIImageView!
    @IBOutlet var insideBeaconImageView: UIImageView!
    @IBOutlet var insideBeaconUDIDLabel: UILabel!
    @IBOutlet var outsideBeaconUDIDLabel: UILabel!
    
    @IBOutlet var whereIamLabel: UILabel!
    
    
    func monitoringEngine(engine: MonitoringEngine!, didRangeBeacons beacons: [AnyObject]!) {
        
        for activity in beacons {
             self.updateBeaconInfo(activity as CLBeacon);
        }
    }
    
    func beaconSignalDispatcherDidSignalEventOfType(eventType: LocationRelatedToVenue, location:String) {
        whereIamLabel.text = eventType.simpleDescription()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        MonitoringEngine.sharedInstance.registerDelegate(self);
        BeaconSignalDispatcher.sharedInstance.registerDelegate(self);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func updateBeaconInfo(beaconActivity : CLBeacon) -> Void {
        
        let newString = beaconActivity.description.stringByReplacingOccurrencesOfString(",", withString: "\n", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        var animatedBeaconView: UIView?
        
        if beaconActivity.minor == BEACON_INSIDE_MINOR {
            self.insideBeaconUDIDLabel.text = newString
            animatedBeaconView = insideBeaconImageView
            
        } else if beaconActivity.minor == BEACON_OUTSIDE_MINOR {
            self.outsideBeaconUDIDLabel.text = newString
            animatedBeaconView = outsideBeaconImageView
        }

        if let viewToAnimate = animatedBeaconView {
            let duration = 0.2
            UIView.animateWithDuration(duration, animations: {
                viewToAnimate.alpha = 1.0
                }, completion: {
                    (value: Bool) in
                    
                    UIView.animateWithDuration(duration, animations: {
                        viewToAnimate.alpha = 0.4
                        }, completion: nil)
            })
        }
    }
}

