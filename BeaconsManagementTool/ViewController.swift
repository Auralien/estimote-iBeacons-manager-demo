//
//  ViewController.swift
//  BeaconsManagementTool
//
//  Created by Maxim Mikheev on 31/05/15.
//  Copyright (c) 2015 Maxim Mikheev. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, ESTUtilityManagerDelegate {
    
    var utilityManager: ESTUtilityManager = ESTUtilityManager()
    var beaconsArray: [ESTBluetoothBeacon] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Choose beacon"
        utilityManager.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        utilityManager.startEstimoteBeaconDiscovery()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        utilityManager.stopEstimoteBeaconDiscovery()
    }
    
    func utilityManager(manager: ESTUtilityManager!, didDiscoverBeacons beacons: [AnyObject]!) {
        beaconsArray = beacons as! [ESTBluetoothBeacon]
        self.tableView.reloadData()
    }

    // MARK: TableViewController Methods
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beaconsArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("beaconCellID", forIndexPath: indexPath) as! BeaconCell
        
        var beacon = beaconsArray[indexPath.row]
        cell.beaconName.text = "Mac Address: \(beacon.macAddress)"
    
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var controller: BeaconDetailsViewController = segue.destinationViewController as! BeaconDetailsViewController
        var indexPath = tableView.indexPathForSelectedRow()
        var beacon = beaconsArray[indexPath!.row]
        controller.beaconMacAddress = beacon.macAddress
    }
}

