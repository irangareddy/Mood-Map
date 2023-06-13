//
//  HeatmapDataView.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 13/06/23.
//

import SwiftUI
import MoodMapKit

struct HeatmapDataView: View {
    @EnvironmentObject var errorHandling: ErrorHandling
    @ObservedObject var insights = InsightsViewModel.shared

    var body: some View {

        List {

            Section {

                Label(streakLabel(), systemImage: "number")
                    .redacted(reason: insights.streaksCount == nil ? .placeholder : [])
            } header: {
                Text("Heatmap")
            } footer: {

            }

            // TODO: MOOD ANALYSIS
            Section("Mood Analysis") {                    Label(streakLabel(), systemImage: "number")
                .redacted(reason: insights.streaksCount == nil ? .placeholder : [])
            }

        }

    }

    private func streakLabel() -> String {
        return "Streak Count " + (insights.streaksCount?.description ?? "0")
    }
}

struct HeatmapDataView_Previews: PreviewProvider {
    static var previews: some View {
        HeatmapDataView()
    }
}
