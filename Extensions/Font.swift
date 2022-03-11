//
//  Font.swift
//  Test
//
//  Created by Aitor Sola on 17/2/22.
//

import SwiftUI

extension Font {

  public static func customSize(_ size: CGFloat, weight: Weight = .medium, design: Design = .default) -> Font {
    Font.system(size: size, weight: weight, design: design)
  }
}
