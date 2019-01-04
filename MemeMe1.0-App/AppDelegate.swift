//
//  AppDelegate.swift
//  MemeMe1.0-App
//
//  Created by Yazeed ALZahrani on 12/31/18.
//  Copyright © 2018 Yazeed ALZahrani. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var memes = [Meme]()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }


}

