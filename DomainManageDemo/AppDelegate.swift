//
//  AppDelegate.swift
//  DomainManageDemo
//
//  Created by MaciOS on 2021/11/1.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = HomeVC()
        window?.makeKeyAndVisible()
        
        NetstatManager.shared.NetworkStatusListener()
        AppUserDefaults.shared.loadFromUserDefaults()

        return true
    }

}

