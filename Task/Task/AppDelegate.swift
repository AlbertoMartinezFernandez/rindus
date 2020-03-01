//
//  AppDelegate.swift
//  TabBarApp
//
//  Created by Alberto Martínez Fernández on 29/02/2020.
//  Copyright © 2020 Alberto Martínez Fernández. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        configLanguage()
        return true
    }
    
    private func configLanguage() {
        if !Language.isSet() {
            _ = Language.setLanguage(locale:Locale.preferredLanguages[0], remember: true)
        } else {
            Language.load()
        }
    }
}

