//
//  AppDelegate.swift
//  BeaconsManagementTool
//
//  Created by Maxim Mikheev on 31/05/15.
//  Copyright (c) 2015 Maxim Mikheev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Replace empty string with your App ID and App Token from Estimote Cloud Console
        // https://cloud.estimote.com
        ESTCloudManager.setupAppID("", andAppToken: "")
        return true
    }
}

