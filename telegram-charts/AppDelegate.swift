//
//  AppDelegate.swift
//  telegram-charts
//
//  Created by Roman Aliyev on 3/12/19.
//  Copyright © 2019 Roman Aliyev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        self.window = window
        window.rootViewController = UINavigationController(rootViewController: StatisticsBuilder().build())
        window.makeKeyAndVisible()
        return true
    }
}

