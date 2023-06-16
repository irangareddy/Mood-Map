//
//  InsightsViewModel.swift
//  AppWrite-CURD
//
//  Created by Ranga Reddy Nukala on 09/06/23.
//

import Foundation
import AppwriteModels
import MoodMapKit

// MARK: - Entries
struct Entries: Codable {
    let heatmap: [String: Int]
    let streaks: Streaks
    let highestEntries: HighestEntries
}

// MARK: - HighestEntries
struct HighestEntries: Codable {
    let count: Int
    let date: String
}

// MARK: - Streaks
struct Contributions: Codable {
    let maintained: Maintained
    let current: Current
}

// MARK: - Current
struct Current: Codable {
    let count: Int
    let startDate: String?
}

// MARK: - Maintained
struct Maintained: Codable {
    let count: Int
    let endDate, startDate: String
}

// MARK: - HEATMAP

struct Streaks: Codable, Hashable {
    var heatmap: String
    var streaks: String
    var highestEntries: String

    init(heatmap: String, streaks: String, highestEntries: String) {
        self.heatmap = heatmap
        self.streaks = streaks
        self.highestEntries = highestEntries
    }
}

class InsightsViewModel: BaseViewModel {
    static let shared = InsightsViewModel()
    @Published var streaks: [Document<Streaks>] = []
    @Published var contributions: Contributions?
    @Published var heatmapData: HeatMapGrid?
    @Published var streaksCount: Int?
    @Published var highestEntries: HighestEntries?
    @Published var lastUpdated: String?
    @Published var error: NetworkError?

    private let networkManager = NetworkManager.shared

    func getHeatMap() async {
        do {
            let response = try await networkManager.readDocuments(collectionId: K.HEATMAPS_COLLECTION_ID) as [Document<Streaks>]
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.isLoading = true
                self.streaks = response

                if let streak = response.last {
                    let cleanedHeatmap = streak.data.heatmap.cleanJSONString()
                    if let heatmap: [String: Int] = cleanedHeatmap.decodeJSON() {
                        self.heatmapData = generateHeatMapGrid(from: heatmap)
                    }

                    let cleanedStreaks = streak.data.streaks.cleanJSONString()
                    if let contributions: Contributions = cleanedStreaks.decodeJSON() {

                        self.contributions = contributions
                        self.streaksCount = contributions.current.count
                    }

                    let cleanedHighestEntries = streak.data.highestEntries.cleanJSONString()
                    if let highestEntries: HighestEntries = cleanedHighestEntries.decodeJSON() {

                        self.highestEntries = highestEntries
                    }

                    self.lastUpdated = streak.updatedAt.humanReadableDateTimeWithSeconds()
                }
            }
        } catch {
            handleAppError(error)
            self.error = NetworkError.dataConversionError
        }

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.isLoading = false
        }
    }
}

extension String {
    func decodeJSON<T: Codable>() -> T? {
        guard let jsonData = self.data(using: .utf8) else {
            return nil
        }

        do {
            debugPrint(jsonData)
            let decoder = JSONDecoder()
            let decodedObject = try decoder.decode(T.self, from: jsonData)
            return decodedObject
        } catch {
            debugPrint("Failed to decode JSON: \(error)")
            return nil
        }
    }
}

extension String {
    func cleanJSONString() -> String {
        return self.replacingOccurrences(of: "'", with: "\"")
    }
}
