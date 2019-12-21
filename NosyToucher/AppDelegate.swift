//
//  AppDelegate.swift
//  NosyToucher
//
//  Created by Roland Tolnay on 16/03/2018.
//  Copyright © 2018 Roland Tolnay. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    let attributes = [NSAttributedStringKey.font: UIFont(name: "AvenirNext-DemiBold", size: 18)!]
    UINavigationBar.appearance().titleTextAttributes = attributes
    
    NotificationService.shared.requestPermissions()
    
    return true
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    TimerService.shared.changedAppState(.background)
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    NotificationService.shared.updateScheduledNotifications()
    TimerService.shared.changedAppState(.foreground)
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    TimerService.shared.changedAppState(.background)
  }
  
  
}

