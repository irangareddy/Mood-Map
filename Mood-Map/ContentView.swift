//
//  ContentView.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 28/05/23.
//

import SwiftUI
import MoodMapKit

struct ContentView: View {
    @ObservedObject var userPreferenceViewModel = UserPreferenceViewModel.shared
    @AppStorage("isFirstTimeUser") var isFirstTimeUser: Bool = true
    @EnvironmentObject var emoozee: Emoozee

    var body: some View {
        Group {
            if isFirstTimeUser {
                OnboardingView()
                    .withErrorHandling()
                    .environmentObject(emoozee)
            } else {
                SplashView()
                    .withErrorHandling()
                    .environmentObject(emoozee)
            }
        }.onAppear(perform: {
            userPreferenceViewModel.loadAccentColor()
        })
        .preferredColorScheme(userPreferenceViewModel.selectedColorScheme)

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct TypographyView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("How are you feeling?")
                .font(.appTitle)
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
                .font(.appHeadline)
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
                .font(.appSmallSubheadline)

            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec congue nulla. Aliquam erat volutpat. Fusce quis sem tincidunt, mattis felis a, elementum sapien.")
                .font(.appBody)

            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
                .font(.appLargeFootnote)

            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
                .font(.appCaption)
        }
        .padding()
    }
}
