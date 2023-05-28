//
//  Mood_MapApp.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 28/05/23.
//

import SwiftUI
import DesignSystem

@main
struct Mood_MapApp: App {
    
    init() {
      DesignSystem.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
