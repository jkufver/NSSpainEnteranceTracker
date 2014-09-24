//
//  BeaconActivityLogger.swift
//  NSSpainEnteranceTracker
//
//  Created by Andreas Claesson on 17/09/14.
//  Copyright (c) 2014 Jens Kufver. All rights reserved.
//

import Foundation

private let _beaconActivityLoggerSingletonInstance = BeaconActivityLogger()

class BeaconActivityLogger {

    var file: NSFileHandle!
    var filePath : NSString!
    
    class var sharedInstance: BeaconActivityLogger {
        return _beaconActivityLoggerSingletonInstance
    }
    
    init() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let logSessionName = "BeaconActivity.log"
        filePath = "\(documentsPath)/\(logSessionName)"
        if (!NSFileManager .defaultManager().fileExistsAtPath(filePath))
        {
            NSFileManager.defaultManager().createFileAtPath(filePath, contents: nil, attributes: nil)
        }
        file = NSFileHandle(forUpdatingAtPath: filePath)
    }
    
    func logActivity(beaconActivity: BeaconActivity)
    {
        self.file.seekToEndOfFile()
        let jsonString = beaconActivity.jsonDescription;
        NSLog("%@", jsonString)
        file.writeData(jsonString.dataUsingEncoding(NSUTF8StringEncoding)!)
    }
    
    func readActivityLog() -> NSData {
        file.seekToFileOffset(0)
        return file.readDataToEndOfFile()
    }
    
    func readActivityLog() -> NSString {
        return NSString(data: readActivityLog(), encoding: NSUTF8StringEncoding)
    }
    
    func printActivityLog()
    {
        let string = NSString(data: readActivityLog(), encoding: NSUTF8StringEncoding)
        NSLog("BeaconActivityLogger contents: %@", string);
    }
}
