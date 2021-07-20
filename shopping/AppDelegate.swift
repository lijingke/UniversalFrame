//
//  AppDelegate.swift
//  shopping
//
//  Created by 李京珂 on 2021/7/19.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc  = ViewController()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        return true
    }

}

