//
//  AppDelegate.swift
//  Cocoa Bluetooth RFCOMM Swift
//
//  Created by Worker PC on 2/8/15.
//  Copyright (c) 2015 Garvin Casimir. All rights reserved.
//

import Cocoa
import IOBluetooth
import IOBluetoothUI


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, IOBluetoothRFCOMMChannelDelegate {
    var mRFCOMMChannel : IOBluetoothRFCOMMChannel?
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet var textView: NSTextView!
    @IBOutlet var txtvw: NSTextView!
    
    @IBAction func discover(sender: AnyObject) {
        
        let deviceSelector = IOBluetoothDeviceSelectorController.deviceSelector()!
        let sppServiceUUID = IOBluetoothSDPUUID.uuid32(kBluetoothSDPUUID16ServiceClassSerialPort.rawValue)        
        let pnpServiceUUID = IOBluetoothSDPUUID.uuid32(kBluetoothSDPUUID16ServiceClassPnPInformation.rawValue)
        let netServiceUUID = IOBluetoothSDPUUID.uuid32(kBluetoothSDPUUID16ServiceClassGenericNetworking.rawValue)
        let vendorUUID = UUID(uuidString: "6088d2b3-983a-4eed-9f94-5ad1256816b7")
        var rfcommChannelID: BluetoothRFCOMMChannelID = 0
        
        deviceSelector.addAllowedUUID(sppServiceUUID)

        if ( deviceSelector.runModal()  !=  Int32(kIOBluetoothUISuccess) ) {
            self.log("User has cancelled the device selection.\n")
            return
        }
        
        let deviceArray = deviceSelector.getResults();
        guard let device = deviceArray![0] as? IOBluetoothDevice else {
            return
        }
        
        let serviceRecord = device.getServiceRecord(for: netServiceUUID)
        if (serviceRecord?.getRFCOMMChannelID(&rfcommChannelID) != kIOReturnSuccess ) {
            self.log("Error - Could not get RFCOMM Channel for UUID")
            return;
        }
        
        if let serviceRecord = serviceRecord {
            self.log("Got RFCOMM Channel ID \(rfcommChannelID) for service \(serviceRecord.getServiceName()!)")
        }
        
        
        if ( device.openRFCOMMChannelAsync(&mRFCOMMChannel, withChannelID: rfcommChannelID, delegate: self) != kIOReturnSuccess ) {
            // Something went bad (looking at the error codes I can also say what, but for the moment let's not dwell on
            // those details). If the device connection is left open close it and return an error:
            self.log("Error - open sequence failed.***\n")
            return;
        }
    }
    
    func log(_ text: String){
        textView.textStorage!.mutableString.append(text)
        print(text)
    }
    
    @IBAction func clearText(sender:AnyObject){
        textView.textStorage!.mutableString.setString("")
    }
    
    @IBAction func hello(sender:AnyObject){
        let myString = "I am doing ok Android. Thanks for asking";
        
        self.sendMessage(myString)
    }
    
    func sendMessage(_ message:String){
        /*
        let data = message.data(using: String.Encoding.utf8)
        let length = data!.count
        let dataPointer = UnsafeMutableRawPointer.allocate(capacity: 1)
        
        data?.copyBytes(to: dataPointer, count: length)
        
        self.log("Sending Message\n")
        mRFCOMMChannel?.writeSync(dataPointer, length: UInt16(length))
         */
    }

    func rfcommChannelOpenComplete(_ rfcommChannel: IOBluetoothRFCOMMChannel!, status error: IOReturn) {
        if(error != kIOReturnSuccess){
            self.log("Error - Failed to open the RFCOMM channel");
        } else {
            self.log("Connected");
        }
    }
    
    //DOWN: f0 02 00 30 01 01 01 10 47 30 39 30 52 44 31 30 37 34 34 32 30 35 52 4b 01 0b 00 00 01 02 01 00 04 00 00 00 00 03 d3 f1
    //UP:   f0 02 00 31 01 01 01 10 47 30 39 30 52 44 31 30 37 34 34 32 30 35 52 4b 01 0b 00 00 01 03 01 00 04 00 00 00 00 03 d4 f1
    func rfcommChannelData(_ rfcommChannel: IOBluetoothRFCOMMChannel!, data dataPointer: UnsafeMutableRawPointer!, length dataLength: Int) {
        let message = Data(bytes: dataPointer, count: dataLength)
        switch(rfcommChannel.getID()) {
        case 4:
            parseNetMessage(message)
        default:
            self.log("Message from unknown channel \(rfcommChannel.getID())")
        }
    }
    
    func parseNetMessage(_ message: Data) {
        guard message.count == 40 else {
            self.log("Unexpected message length \(message.count); expected 40: \(message.hexadecimalString())")
            return
        }
        guard message[0] == 0xF0 else {
            self.log("Starting byte was \(message[0]); expected 0xF0")
            return
        }
        guard message.last == 0xF1 else {
            self.log("Final byte was \(message.last!); expected 0xF1")
            return
        }
        let sequenceNumber = message[3]
        let DSN = String(data: message.subdata(in: 8..<8+0x10), encoding: String.Encoding.ascii) ?? "Unknown DSN"
        var direction = "unknown"
        switch (message[29]) {
        case 0x02:
            direction = "down"
        case 0x03:
            direction = "up"
        default:
            direction = "Unknown value \(message[29])"
        }
        
        self.log("(\(DSN)) [\(sequenceNumber)]: \(direction)\n");
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
}
