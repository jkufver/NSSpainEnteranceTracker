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
        
        self.updateBeaconInfo(0, UDID:"Test-Inside", major:"1.2", minor:"1.4", distanceRange:"near");
        self.updateBeaconInfo(1, UDID:"Test-Outside", major:"1.2", minor:"1.4", distanceRange:"near");

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateBeaconInfo(inside: Bool, UDID:String, major: String, minor: String, distanceRange: String) -> Void {
        
        if inside {
            self.insideBeaconUDIDLabel.text = UDID;
        } else {
            self.outsideBeaconUDIDLabel.text = UDID;
        }
    }

}

