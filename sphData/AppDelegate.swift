//
//  AppDelegate.swift
//  sphData
//
//  Created by Michael Schembri on 1/2/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// set up
		let navCtrl = UINavigationController(rootViewController: HomeViewController())
		window = UIWindow()
		window?.makeKeyAndVisible()
		window?.rootViewController = navCtrl
		return true
	}
}
