//
//  AdView.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 5/4/22.
//

import SwiftUI

struct AdView: View {
    
    var title: String
    var descr: String
    var buttonTitle: String
    var image: String
    let buttonHandler: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 10) {
            
            DragBar()
                .padding(.top, 15)
            
            Image(image)
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .padding(.top, 20)
            
            Text(title)
                .font(.customSize(40, weight: .medium))
                .frame(maxWidth: .infinity)
                .padding()
            
            Text(descr)
                .font(.customSize(20, weight: .light))
                .frame(maxWidth: .infinity)
                .padding()
            
            Button(buttonTitle) {
                buttonHandler?()
            }
#if os(iOS)
            .font(.customSize(20))
#endif
            
            Spacer()
        }
        .frame(maxHeight: .infinity)
        .background(.ultraThinMaterial)
        .cornerRadius(40)
    }
}

struct AdView_Previews: PreviewProvider {
    static var previews: some View {
        AdView(title: "Titulo", descr: "Description", buttonTitle: "Ok", image: "icn_car") {
            
        }
    }
}
