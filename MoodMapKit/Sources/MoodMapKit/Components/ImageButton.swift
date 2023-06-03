//
//  ImageButton.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 29/05/23.
//

import Foundation
import SwiftUI

struct ImageButton: View {
    var image: Image = Image(systemName: "heart")
    var text: String
    var action: () -> Void

    // Customization options
    var imageSize: CGSize = CGSize(width: 11, height: 11)
    var cornerRadius: CGFloat = 8.0
    var backgroundColor: Color
    var foregroundColor: Color
    var shadowRadius: CGFloat

    var body: some View {
        Button(action: action) {
            HStack {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: imageSize.width, height: imageSize.height)
                    .padding()

                Text(text + " 🙈")
                    .font(.headline)
                    .foregroundColor(foregroundColor)
            }
            .padding()
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(radius: shadowRadius)
        }
    }
}

struct ImageButton_Previews: PreviewProvider {
    static var previews: some View {
        ImageButton(image: Image(systemName: "heart.fill"), text: "Button", action: {}, imageSize: CGSize(width: 50, height: 50),
                    cornerRadius: 10,
                    backgroundColor: Color.blue,
                    foregroundColor: Color.white,
                    shadowRadius: 5)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
