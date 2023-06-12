//
//  InsightsViewModel.swift
//  AppWrite-CURD
//
//  Created by Ranga Reddy Nukala on 09/06/23.
//

import Foundation
import AppwriteModels
import MoodMapKit

// MARK: - HEATMAP

struct Streaks: Codable, Hashable {
    var heatmap: String
    var streakCount: Int

    init(heatmap: String, streakCount: Int) {
        self.heatmap = heatmap
        self.streakCount = streakCount
    }
}

class InsightsViewModel: BaseViewModel {
    @Published var streaks: [Document<Streaks>]?
    @Published var heatmap: String?
    @Published var streaksCount: Int?
    @Published var lastUpdated: String?
    @Published var isLoading = false
    @Published var error: NetworkError?

    private let networkManager = NetworkManager.shared

    func getHeatMap() async {

        debugPrint("Called getHeatMap")

        do {
            let response = try await networkManager.readDocuments(collectionId: K.HEATMAPS_COLLECTION_ID) as [AppwriteModels.Document<Streaks>]
            isLoading = true
            streaks = response

            if let streak = streaks?.first {
                debugPrint("Updated values")
                streaksCount = streak.data.streakCount
                heatmap = streak.data.heatmap
                lastUpdated = streak.updatedAt.humanReadableDateTimeWithSeconds()
            }
        } catch {
            handleAppError(error)
            self.error = NetworkError.dataConversionError
        }

        isLoading = false
    }
}
