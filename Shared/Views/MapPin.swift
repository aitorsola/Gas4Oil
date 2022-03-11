//
//  MapPin.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 7/3/22.
//

import SwiftUI

struct MapPin: View {

  var title: String
  var tapBlock: (() -> Void)?

  var body: some View {
    VStack(spacing: 0) {
      HStack {
        Image(systemName: "fuelpump.circle.fill")
          .resizable()
          .frame(width: 20, height: 20)
        Text(title.capitalized).font(.body)
      }
      .padding(12)
      .background(Color(.white))
      .foregroundColor(.black)
      .cornerRadius(8)
      .offset(x: 0, y: -5)

      Image(systemName: "mappin.circle.fill")
        .resizable()
        .font(.title)
        .foregroundColor(.orange)
        .frame(width: 50, height: 50)

      Image(systemName: "arrowtriangle.down.fill")
        .font(.caption)
        .foregroundColor(.orange)
        .offset(x: 0, y: -5)
    }
    .onTapGesture {
      tapBlock?()
    }
  }
}

struct MapPin_Previews: PreviewProvider {
  static var previews: some View {
    MapPin(title: "Hola")
  }
}
