//
//  BeaconActivityTests.swift
//  NSSpainEnteranceTracker
//
//  Created by Andreas Claesson on 17/09/14.
//  Copyright (c) 2014 Jens Kufver. All rights reserved.
//

import UIKit
import XCTest

class BeaconActivityTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testBeaconDescription() {
        var beaconActivity = BeaconActivity()
        let dateFormater : NSDateFormatter = NSDateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss:sss"
        beaconActivity.timeStamp = String(format:"%@", dateFormater.stringFromDate(NSDate()))
        beaconActivity.proximityUUID = NSUUID(UUIDString: "123456")
    }

}
