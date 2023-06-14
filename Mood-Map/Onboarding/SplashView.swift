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
    @ObservedObject var userPreferenceViewModel = UserPreferenceViewModel.shared
    @ObservedObject private var authManager = AuthViewModel.shared
    @State private var isActive = false

    /// The body view that constructs the UI hierarchy.
    public var body: some View {
        NavigationView {
            EmojiFacesView()
                .onAppear {
                    authManager.validateCurrentSession()
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7).delay(0.5)) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.isActive = true
                            showNextScreen()
                        }
                    }

                }

        }    .preferredColorScheme(userPreferenceViewModel.selectedColorScheme)

    }

    func showNextScreen() {
        let rootView = authManager.isUserLoggedIn ? AnyView(TabbedView().withErrorHandling()) : AnyView(SignInView().withErrorHandling())

        NavigationController.rootView( UIHostingController(rootView: rootView))
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
