//
//  Double.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 8/3/22.
//

import Foundation

extension Double {

  func toString() -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.locale = .current
    return formatter.string(from: NSNumber(value: self)) ?? ""
  }

  func round(to places: Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return (self * divisor).rounded() / divisor
  }
}
