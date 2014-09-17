//
//  FirstViewController.swift
//  NSSpainEnteranceTracker
//
//  Created by Jens Kufver on 2014-09-17.
//  Copyright (c) 2014 Jens Kufver. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet var outsideBeaconImageView: UIImageView!
    @IBOutlet var insideBeaconImageView: UIImageView!
    @IBOutlet var insideBeaconUDIDLabel: UILabel!
    @IBOutlet var outsideBeaconUDIDLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    // just for testing
        let testactivity: BeaconActivity = BeaconActivity()
        
        testactivity.minor = NSNumber.numberWithInt(0)
        self.updateBeaconInfo(testactivity);
        
        testactivity.minor = NSNumber.numberWithInt(1);
        self.updateBeaconInfo(testactivity);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateBeaconInfo(beaconActivity : BeaconActivity) -> Void {
        
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

