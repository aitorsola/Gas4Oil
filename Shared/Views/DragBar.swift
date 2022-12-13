//
//  DragBar.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 5/4/22.
//

import SwiftUI

struct DragBar: View {
    var body: some View {
        RoundedRectangle(cornerSize: .zero)
            .frame(width: 50, height: 6)
            .background(.gray)
            .cornerRadius(3)
    }
}

struct DragBar_Previews: PreviewProvider {
    static var previews: some View {
        DragBar()
    }
}
