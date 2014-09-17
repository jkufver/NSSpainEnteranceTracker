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
    
    class var sharedInstance: BeaconActivityLogger {
        return _beaconActivityLoggerSingletonInstance
    }
    
    init() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let logSessionName = "BeaconActivity.log"
        let fileName = "\(documentsPath)/\(logSessionName)"
        if (!NSFileManager .defaultManager().fileExistsAtPath(fileName))
        {
            NSFileManager.defaultManager().createFileAtPath(fileName, contents: nil, attributes: nil)
        }
        file = NSFileHandle(forUpdatingAtPath: fileName)
    }
    
    func logActivity(beaconActivity: BeaconActivity)
    {
        self.file.seekToEndOfFile()
        file.writeData(beaconActivity.description.dataUsingEncoding(NSUTF8StringEncoding)!)
    }
    
    func readActivityLog() -> NSData {
        return file.readDataToEndOfFile()
    }
    
    func printActivityLog()
    {
        file.seekToFileOffset(0)
        let string = NSString(data: readActivityLog(), encoding: NSUTF8StringEncoding)
        NSLog("BeaconActivityLogger contents: %@", string);
    }
}
