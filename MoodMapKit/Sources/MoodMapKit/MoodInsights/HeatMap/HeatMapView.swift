//
//  HeatMapView.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 30/05/23.
//

import SwiftUI

/// A view representing a heat map.
///
/// Use `HeatMapView` to display a grid of cells representing data in a heat map format.
public struct HeatMapView: View {
    /// The heat map grid containing the data.
    let grid: HeatMapGrid
    @State private var selectedRow: Int?
    @State private var selectedColumn: Int?
    @State private var isAnimating = false

    @GestureState private var dragState = CGSize.zero

    /// Initializes a `HeatMapView` with the given heat map grid.
    ///
    /// - Parameter grid: The heat map grid containing the data.
    public init(grid: HeatMapGrid) {
        self.grid = grid
    }

    /// The body of the view.
    public var body: some View {
        VStack {
            VStack {
                VStack {
                    ForEach(0..<grid.rows, id: \.self) { row in
                        HStack {
                            ForEach(0..<grid.columns, id: \.self) { column in
                                HeatMapCell(value: grid.data[row][column], row: row, column: column, grid: grid, selectedRow: $selectedRow, selectedColumn: $selectedColumn)
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

        VStack {
            if let selectedRow = selectedRow, let selectedColumn = selectedColumn {
                Text("Selected Cell: (\(selectedRow), \(selectedColumn))")
                    .font(.headline)
                    .padding(.bottom, 8)

                Text("Value: \(grid.data[selectedRow][selectedColumn])")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                Text("Tap a cell to view details.")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.secondary)
        .cornerRadius(10)
        .padding()
        .alert(isPresented: $isAnimating) {
            Alert(title: Text("HJel"))
        }
    }
}

struct HeatMapView_Previews: PreviewProvider {
    static var previews: some View {
        let monthlyData: [[Double]] = [
            [0.2, 0.3, 0.5, 0.7, 0.9, 0.4, 0.2, 0.1, 0.3, 0.6, 0.8, 0.9],
            [0.1, 0.5, 0.2, 0.8, 0.6, 0.4, 0.7, 0.3, 0.5, 0.9, 0.2, 0.1],
            [0.7, 0.3, 0.4, 0.9, 0.6, 0.8, 0.5, 0.2, 0.1, 0.3, 0.5, 0.7],
            [0.5, 0.9, 0.2, 0.4, 0.1, 0.7, 0.6, 0.8, 0.3, 0.5, 0.9, 0.2],
            [0.6, 0.3, 0.9, 0.5, 0.7, 0.2, 0.8, 0.1, 0.3, 0.5, 0.9, 0.4],
            [0.8, 0.4, 0.5, 0.1, 0.9, 0.3, 0.2, 0.5, 0.7, 0.6, 0.8, 0.1]
        ]
        HeatMapView(grid: HeatMapGrid(rows: monthlyData.count, columns: monthlyData[0].count, data: monthlyData))
    }
}
