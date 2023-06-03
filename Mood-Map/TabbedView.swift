//
//  TabView.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 29/05/23.
//

import SwiftUI
import MoodMapKit

struct TabbedView: View {
    @ObservedObject var placeholder = PlaceholderData()
    @State private var moodEntries: [MoodEntry] = []
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }

            MoodInsightsView()
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Insights")
                }

            MemoryLaneView(moodEntries: $moodEntries)

                .tabItem {
                    Image(systemName: "photo.on.rectangle")
                    Text("Memory Lane")
                }         .onAppear {
                    moodEntries = placeholder.moodEntries
                }

            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }        .onAppear {
            moodEntries = placeholder.moodEntries
        }
    }
}
