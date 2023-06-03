//
//  Mood_MapApp.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 28/05/23.
//

import SwiftUI
import MoodMapKit

@main
struct Mood_MapApp: App {
    @ObservedObject var emoozee = Emoozee()

    init() {
        DesignSystem.registerFonts()
        #if os(iOS)
        DesignSystem.registerAppaerance()
        #endif
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(emoozee)
        }
        #if os(macOS)
        .defaultSize(width: 1000, height: 650)
        #endif
    }
}
