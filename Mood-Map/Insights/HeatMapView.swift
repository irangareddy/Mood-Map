//
//  HeatMapView.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 30/05/23.
//

import SwiftUI
import MoodMapKit

/// A view representing a heat map.
///
/// Use `HeatMapView` to display a grid of cells representing data in a heat map format.
public struct HeatMapView: View {
    /// The heat map grid containing the data.
    let grid: HeatMapGrid
    @State private var selectedRow: Int?
    @State private var selectedColumn: Int?
    @State private var isAnimating = false
    @ObservedObject var insights = InsightsViewModel.shared
    @GestureState private var dragState = CGSize.zero

    /// Initializes a `HeatMapView` with the given heat map grid.
    ///
    /// - Parameter grid: The heat map grid containing the data.
    public init(grid: HeatMapGrid) {
        self.grid = grid
    }

    /// The body of the view.
    public var body: some View {
        VStack(spacing: 10) {
            if let selectedRow = selectedRow, let selectedColumn = selectedColumn {
                Text("\(grid.data[selectedRow][selectedColumn].key.gridDate())")
                    .font(.appTitle3)
                    .foregroundColor(.accentColor)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical)
            }

            heatmapGrid
                .redacted(reason: insights.heatmapData == nil ? .placeholder : [])
                .padding(.vertical)

            StreakBar(title: "Current Streak", startDate: insights.contributions?.current.startDate?.description, streakCount: insights.contributions?.current.count.description ?? "")
                .redacted(reason: insights.contributions == nil ? .placeholder : [])

            StreakBar(title: "Longest Streak", startDate: insights.contributions?.maintained.startDate.description, endDate: insights.contributions?.maintained.endDate.description, streakCount: insights.contributions?.maintained.count.description ?? "")
                .redacted(reason: insights.contributions == nil ? .placeholder : [])

            StreakBar(title: "Top Check-In on", startDate: insights.highestEntries?.date.description, streakCount: insights.highestEntries?.count.description ?? "")
                .redacted(reason: insights.highestEntries == nil ? .placeholder : [])

            Spacer()
        }
        .padding()
        .navigationTitle("Streaks")

    }
}

extension HeatMapView {

    @ViewBuilder
    public var heatmapGrid: some View {
        VStack {
            VStack {
                VStack {
                    ForEach(0..<grid.rows, id: \.self) { row in
                        HStack {
                            ForEach(0..<grid.columns, id: \.self) { column in
                                HeatMapCell(value: grid.data[row][column].value, row: row, column: column, grid: grid, selectedRow: $selectedRow, selectedColumn: $selectedColumn)
                                    .onTapGesture {
                                        withAnimation {
                                            if selectedRow == row && selectedColumn == column {
                                                selectedRow = nil
                                                selectedColumn = nil
                                            } else {
                                                selectedRow = row
                                                selectedColumn = column
                                            }
                                        }
                                    }
                                    .scaleEffect(isAnimating && selectedRow == row && selectedColumn == column ? 1.2 : 1.0)
                                    .animation(.easeInOut(duration: 0.2))
                                    .gesture(
                                        DragGesture()
                                            .updating($dragState) { value, dragState, _ in
                                                debugPrint(value)
                                                dragState = value.translation
                                            }
                                            .onEnded { value in
                                                let location = value.location
                                                let gridSize = CGSize(width: 20 * grid.columns, height: 20 * grid.rows)
                                                let cellWidth = gridSize.width / CGFloat(grid.columns)
                                                let cellHeight = gridSize.height / CGFloat(grid.rows)

                                                let row = min(max(Int(location.y / cellHeight), 0), grid.rows - 1)
                                                let column = min(max(Int(location.x / cellWidth), 0), grid.columns - 1)

                                                withAnimation(.linear(duration: 0.1)) {
                                                    selectedRow = row
                                                    selectedColumn = column
                                                    isAnimating = false
                                                }
                                            }
                                    )
                            }
                        }
                    }
                }
            }
        }
    }
}

struct HeatMapView_Previews: PreviewProvider {
    static var previews: some View {
        let monthlyData: [[(key: String, value: Double)]] = [
            [("2023-05-1", 0.2), ("2023-05-2", 0.3), ("2023-05-3", 0.5), ("2023-05-4", 0.7), ("2023-05-5", 0.9), ("2023-05-6", 0.4), ("2023-05-7", 0.2), ("2023-05-8", 0.1), ("2023-05-9", 0.3), ("2023-05-10", 0.6), ("2023-05-11", 0.0), ("2023-05-12", 0.9)],
            [("2023-05-13", 0.1), ("2023-05-14", 0.5), ("2023-05-15", 0.2), ("2023-05-16", 0.0), ("2023-05-17", 0.6), ("2023-05-18", 0.4), ("2023-05-19", 0.7), ("2023-05-20", 0.3), ("2023-05-21", 0.5), ("2023-05-22", 0.9), ("2023-05-23", 0.2), ("2023-05-24", 0.1)],
            [("2023-05-25", 0.7), ("2023-05-26", 0.3), ("2023-05-27", 0.4), ("2023-05-28", 0.0), ("2023-05-29", 0.6), ("2023-05-30", 0.0), ("Key31", 0.5), ("Key32", 0.2), ("Key33", 0.1), ("Key34", 0.3), ("Key35", 0.5), ("Key36", 0.7)],
            [("Key37", 0.5), ("Key38", 0.9), ("Key39", 0.2), ("Key40", 0.4), ("Key41", 0.1), ("Key42", 0.7), ("Key43", 0.6), ("Key44", 0.0), ("Key45", 0.3), ("Key46", 0.5), ("Key47", 0.9), ("Key48", 0.2)],
            [("Key49", 0.6), ("Key50", 0.3), ("Key51", 0.9), ("Key52", 0.5), ("Key53", 0.7), ("Key54", 0.2), ("Key55", 0.0), ("Key56", 0.1), ("Key57", 0.3), ("Key58", 0.5), ("Key59", 0.9), ("Key60", 0.4)],
            [("Key61", 0.0), ("Key62", 0.4), ("Key63", 0.5), ("Key64", 0.1), ("Key65", 0.9), ("Key66", 0.3), ("Key67", 0.2), ("Key68", 0.5), ("Key69", 0.7), ("Key70", 0.6), ("Key71", 0.0), ("Key72", 0.1)]
        ]
        HeatMapView(grid: HeatMapGrid(rows: monthlyData.count, columns: monthlyData[0].count, data: monthlyData))
    }
}

struct StreakBar: View {
    let title: String
    let startDate: String?
    let endDate: String?
    let streakCount: String

    init(title: String, startDate: String?, endDate: String? = nil, streakCount: String) {
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.streakCount = streakCount
    }

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.appTitle3)
                    HStack(alignment: .firstTextBaseline) {
                        Text(startDate?.description.gridDate() ?? "May 1, 2023")
                        if endDate != nil {
                            Text("-")
                            Text(endDate?.description.gridDate() ?? "May 22, 2023")
                        }

                    }
                    .font(.appCaption)
                    .multilineTextAlignment(.leading)
                }
                .padding(.vertical, 8)

                Spacer()

                Text(streakCount)
                    .font(.appLargeTitle)
                    .padding(.bottom, 8)
            }
            Divider()

        }.frame(maxWidth: .infinity, alignment: .leading)
    }
}
