//
//  String.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 9/3/22.
//

import Foundation

extension String {

  var translated: String {
    let format = NSLocalizedString(self, tableName: "Localizable", bundle: Bundle.main, comment: "")
    return String(format: format)
  }

  func translated(_ args: CVarArg...) -> String {
    let format = NSLocalizedString(self, tableName: "Localizable", bundle: Bundle.main, comment: "")
    return String(format: format, arguments: args)
  }
}
