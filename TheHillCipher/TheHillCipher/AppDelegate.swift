//
//  AppDelegate.swift
//  TheHillCipher
//
//  Created by Olteanu Andrei on 18/10/2018.
//  Copyright © 2018 Andrei Olteanu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        let mainViewController = MainViewController.instantiate()
        let navigationController = UINavigationController(rootViewController: mainViewController)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}

