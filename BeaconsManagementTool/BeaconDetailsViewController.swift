//
//  BeaconDetailsViewController.swift
//  BeaconsManagementTool
//
//  Created by Maxim Mikheev on 31/05/15.
//  Copyright (c) 2015 Maxim Mikheev. All rights reserved.
//

import UIKit

class BeaconDetailsViewController: UIViewController, UITextFieldDelegate, ESTBeaconConnectionDelegate {
    @IBOutlet weak var uuidTextField: UITextField!
    @IBOutlet weak var majorTextField: UITextField!
    @IBOutlet weak var minorTextField: UITextField!
    
    var beaconMacAddress: String = ""
    
    var beaconConnection: ESTBeaconConnection = ESTBeaconConnection()

    override func viewDidLoad() {
        super.viewDidLoad()
        beaconConnection = ESTBeaconConnection(macAddress: beaconMacAddress, delegate: self, startImmediately: false)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        beaconConnection.startConnection()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if beaconConnection.connectionStatus == ESTConnectionStatus.Connected || beaconConnection.connectionStatus == ESTConnectionStatus.Connecting {
            println("Cancelling connection")
            // The app crashes in cancelConnection, seems like somewhere in Estimote Framework
            beaconConnection.cancelConnection()
        }
    }
    
    // MARK: - Beacon Connection Delegate Methods
    
    func beaconConnectionDidSucceed(connection: ESTBeaconConnection!) {
        println("Connected!")
        if beaconConnection.proximityUUID != nil {
            uuidTextField.text = beaconConnection.proximityUUID.UUIDString
        } else {
            uuidTextField.text = "--"
        }
        
        if beaconConnection.major != nil {
            majorTextField.text = "\(beaconConnection.major)"
        } else {
            majorTextField.text = "--"
        }
        
        if beaconConnection.minor != nil {
            minorTextField.text = "\(beaconConnection.minor)"
        } else {
            minorTextField.text = "--"
        }
    }
    
    func beaconConnection(connection: ESTBeaconConnection!, didFailWithError error: NSError!) {
        println("Connection error: \(error.localizedDescription)")
    }
    
    func beaconConnection(connection: ESTBeaconConnection!, didDisconnectWithError error: NSError!) {
        println("Disconnected with error: \(error.localizedDescription)")
    }
    
    // MARK: - Text Field Delegate Methods
    
    func textFieldDidEndEditing(textField: UITextField) {
        if (textField == uuidTextField) {
            beaconConnection.writeProximityUUID(textField.text, completion: { (value, error) -> Void in
                if error != nil {
                    println("Error UUID write: \(error.localizedDescription)")
                } else {
                    println("Changed UUID")
                }
                
                self.uuidTextField.text = "\(value)"
            })
        } else if (textField == majorTextField) {
            var newMajor = self.majorTextField.text.toInt()
            
            if newMajor != nil {
                var newMajor16 = UInt16(newMajor!)
                beaconConnection.writeMajor(newMajor16, completion: { (major, error) -> Void in
                    if error != nil {
                        println("Error Major write: \(error.localizedDescription)")
                    } else {
                        println("Changed Major")
                    }
                    
                    self.majorTextField.text = "\(major)"
                })
            }
        } else if (textField == minorTextField) {
            var newMinor = self.minorTextField.text.toInt()
            
            if newMinor != nil {
                var newMinor16 = UInt16(newMinor!)
                beaconConnection.writeMinor(newMinor16, completion: { (minor, error) -> Void in
                    if error != nil {
                        println("Error Minor write: \(error.localizedDescription)")
                    } else {
                        println("Changed Minor")
                    }
                    
                    self.minorTextField.text = "\(minor)"
                })
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
