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
        
        if beaconActivity.minor == 1 {
            self.insideBeaconUDIDLabel.text = newString
            
            UIView.animateWithDuration(0.5, animations: {
                self.insideBeaconImageView.alpha = 0
                }, completion: {
                    (value: Bool) in
                self.insideBeaconImageView.alpha = 1.0
            })
            
        } else if beaconActivity.minor == 0 {
            self.outsideBeaconUDIDLabel.text = newString
            
            UIView.animateWithDuration(0.5, animations: {
                self.outsideBeaconImageView.alpha = 0
                }, completion: {
                    (value: Bool) in
                    self.outsideBeaconImageView.alpha = 1.0
            })
        }
    }

}

