//
//  AppDelegate.swift
//  Example
//
//  Created by MYUNGHOON HONG on 2020/04/24.
//  Copyright © 2020 hmhv. All rights reserved.
//

import UIKit
import MobS

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        MobS.isTraceEnabled = true
        return true
    }

}

