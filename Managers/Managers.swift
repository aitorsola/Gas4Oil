//
//  Managers.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 6/3/22.
//

import Foundation

struct Managers {
  static let location = Location()
  #if os(iOS)
  static let backgroundTask: BackgroundTaskManagerProtocol = BackgroundTaskManager()
  #endif
}
