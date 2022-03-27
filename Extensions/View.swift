//
//  View.swift
//  Gas4Oil (iOS)
//
//  Created by Aitor Sola on 27/3/22.
//

import SwiftUI

extension View {
  
  #if canImport(UIKit)
  func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
  #endif
}
