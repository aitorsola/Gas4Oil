//
//  BackgroundTaskManager.swift
//  Gas4Oil (iOS)
//
//  Created by Aitor Sola on 4/4/22.
//

import BackgroundTasks

protocol BackgroundTaskManagerProtocol: AnyObject {
  func registerTask(_ task: BackgroundTaskIdentifers, handler: @escaping (BGTask) -> Void) -> Bool
  func scheduleTask(_ task: BackgroundTaskIdentifers, earliestBeginDate date: Date)
  func handleTask(_ task: BGTask, block: @escaping () -> Void)
}

enum BackgroundTaskIdentifers: String {
  case refreshStationList = "com.Gas4Oil.update_stations"
}

class BackgroundTaskManager {


}

extension BackgroundTaskManager: BackgroundTaskManagerProtocol {

  func registerTask(_ task: BackgroundTaskIdentifers, handler: @escaping (BGTask) -> Void) -> Bool {
    return BGTaskScheduler.shared.register(forTaskWithIdentifier: task.rawValue, using: nil, launchHandler: handler)
  }

  func scheduleTask(_ task: BackgroundTaskIdentifers, earliestBeginDate date: Date) {
    let task = BGAppRefreshTaskRequest(identifier: task.rawValue)
    task.earliestBeginDate = date
    do {
      try BGTaskScheduler.shared.submit(task)
    } catch {
      print(error.localizedDescription)
    }
  }

  func handleTask(_ task: BGTask, block: @escaping () -> Void) {
    task.expirationHandler = {
      task.setTaskCompleted(success: false)
    }
    DispatchQueue.main.async {
      block()
      task.setTaskCompleted(success: true)
    }
    Managers.backgroundTask.scheduleTask(.refreshStationList, earliestBeginDate: Date(timeIntervalSinceNow: 15*60))
  }
}
