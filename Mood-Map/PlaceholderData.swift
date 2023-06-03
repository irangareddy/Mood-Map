//
//  PlaceholderData.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 31/05/23.
//

import Foundation
import SwiftUI
import MoodMapKit

class PlaceholderData: ObservableObject {
    @Published var moodEntries: [MoodEntry] = []

    init() {
        loadPlaceholderData()
        print("Loading")
    }

    func loadPlaceholderData() {
        guard let url = Bundle.main.url(forResource: "placeholder_data", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Failed to load data from JSON file")
            return
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            let moodEntries = try decoder.decode([MoodEntry].self, from: data)
            self.moodEntries = moodEntries
            print("Loaded placeholder data successfully.")
        } catch {
            print("Error decoding placeholder data: \(error)")
        }
    }

}
