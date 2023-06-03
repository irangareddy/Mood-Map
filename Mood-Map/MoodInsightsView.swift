//
//  MoodInsightsView.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 29/05/23.
//

import SwiftUI
import MoodMapKit

struct MoodInsightsView: View {
    @State private var selectedChartIndex = 0
    let monthlyData: [[Double]] = [
        [0.2, 0.3, 0.5, 0.7, 0.9, 0.4, 0.2, 0.1, 0.3, 0.6, 0.8, 0.9],
        [0.1, 0.5, 0.2, 0.8, 0.6, 0.4, 0.7, 0.3, 0.5, 0.9, 0.2, 0.1],
        [0.7, 0.3, 0.4, 0.9, 0.6, 0.8, 0.5, 0.2, 0.1, 0.3, 0.5, 0.7],
        [0.5, 0.9, 0.2, 0.4, 0.1, 0.7, 0.6, 0.8, 0.3, 0.5, 0.9, 0.2],
        [0.6, 0.3, 0.9, 0.5, 0.7, 0.2, 0.8, 0.1, 0.3, 0.5, 0.9, 0.4],
        [0.8, 0.4, 0.5, 0.1, 0.9, 0.3, 0.2, 0.5, 0.7, 0.6, 0.8, 0.1]
    ]

    var body: some View {
        VStack {
            Picker(selection: $selectedChartIndex, label: Text("Select Chart")) {
                Text("Heat Map").tag(0)
                Text("Mood Distribution").tag(1)
                Text("Activity and Mood").tag(2)
                Text("Weather and Mood").tag(3)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Spacer()

            if selectedChartIndex == 0 {
                HeatMapView(grid: HeatMapGrid(rows: monthlyData.count, columns: monthlyData[0].count, data: monthlyData))
            } else if selectedChartIndex == 1 {
                //                MoodDistributionView()
            } else if selectedChartIndex == 2 {
                //                MoodTrendsView()
            } else if selectedChartIndex == 3 {
                //                ScatterPlotView()
            }

            Spacer()
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .navigationTitle("Insights")
    }
}
