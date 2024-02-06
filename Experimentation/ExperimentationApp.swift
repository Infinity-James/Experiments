//
//  ExperimentationApp.swift
//  Experimentation
//
//  Created by James Valaitis on 10/01/2024.
//

import SwiftUI
import TipKit

@main
struct ExperimentationApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    do {
                        try Tips.configure([.datastoreLocation(.applicationDefault)])
                    } catch {
                        print("Error configuring Tips: \(error)")
                    }
                }
        }
    }
}

private final class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            guard granted else { return }
            center.getNotificationSettings { settings in
                guard settings.authorizationStatus == .authorized else { return }
                DispatchQueue.main.async { application.registerForRemoteNotifications() }
            }
        }
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
            return .failed
        }
        
        print("📲 📲 📲 📲 📲")
        print("Received notification:")
        print(aps)
        return .noData
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("⚪️ ⚪️ ⚪️ ⚪️ ⚪️")
        print("Device token: \(token)")
    }
}
