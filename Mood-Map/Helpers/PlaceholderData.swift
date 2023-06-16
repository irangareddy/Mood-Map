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
    }

    func loadPlaceholderData() {
        guard let url = Bundle.main.url(forResource: "placeholder_data", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            debugPrint("Failed to load data from JSON file")
            return
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            let moodEntries = try decoder.decode([MoodEntry].self, from: data)
            self.moodEntries = moodEntries.reversed()
        } catch {
            debugPrint("Error decoding placeholder data: \(error)")
        }
    }

}
