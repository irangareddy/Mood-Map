//
//  LockedFeatureView.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 13/06/23.
//

import SwiftUI

struct LockedFeatureModifer: ViewModifier {
    @State private var isBlurred = false

    func body(content: Content) -> some View {
        content
            .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            .blur(radius: isBlurred ? 10 : 0)
            .onLongPressGesture {
                isBlurred.toggle()
            }
    }
}

extension View {
    func lockView() -> some View {
        self.modifier(LockedFeatureModifer())
    }
}
