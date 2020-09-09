//
//  AppDelegate.swift
//  Bubbless
//
//  Created by Vladislav Kulikov on 02.05.2020.
//  Copyright © 2020 Vladislav Kulikov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AdMob.shared.start()
        GameCenter.shared.authenticateLocalPlayer()
        IAPService.shared.addObserver()
        
        // Count the application launches for requesting a review.
        Defaults.shared.applicationLaunches += 1
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        IAPService.shared.removeObserver()
    }

}

