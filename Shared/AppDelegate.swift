//
//  AppDelegate.swift
//  Gas4Oil (iOS)
//
//  Created by Aitor Sola on 4/4/22.
//

import SwiftUI
import BackgroundTasks

extension Notification.Name {
    static let updateStations = Notification.Name.init(rawValue: "update_stations")
}

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    
    private let taskManager = Managers.backgroundTask
    
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        _ = taskManager.registerTask(.refreshStationList, handler: { task in
            self.taskManager.handleTask(task) {
                NotificationCenter.default.post(name: .updateStations, object: nil)
            }
        })
        return true
    }
}
