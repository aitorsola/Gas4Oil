//
//  Sequence.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 6/3/22.
//

extension Sequence where Iterator.Element: Hashable {
  
  func unique() -> [Iterator.Element] {
    var seen: [Iterator.Element: Bool] = [:]
    return self.filter { seen.updateValue(true, forKey: $0) == nil }
  }
}
