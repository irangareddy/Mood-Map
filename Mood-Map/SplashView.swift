//
//  SplashView.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 03/06/23.
//

import Foundation
import MoodMapKit
import SwiftUI

/// A view that represents the splash screen.
public struct SplashView: View {
    @State private var showHome = false

    /// The body view that constructs the UI hierarchy.
    public var body: some View {
        EmojiFacesView()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    withAnimation {
                        showHome = true
                    }
                }
            }
            .fullScreenCover(isPresented: $showHome, content: {
                HomeView()
            })
    }
}

/// A preview provider for the `SplashView` view.
public struct SplashView_Previews: PreviewProvider {
    /// Previews of the `SplashView` view.
    public static var previews: some View {
        Group {
            SplashView()
            SplashView()
                .preferredColorScheme(.dark)
        }
    }
}
