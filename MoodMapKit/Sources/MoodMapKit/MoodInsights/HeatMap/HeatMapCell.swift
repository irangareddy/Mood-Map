//
//  File.swift
//
//
//  Created by Ranga Reddy Nukala on 02/06/23.
//

import Foundation
import SwiftUI

/// A view representing a cell in a heat map grid.
///
/// Use `HeatMapCell` to display a cell with a specific value at the given row and column
/// in a heat map grid. The cell can be selected and interacted with through taps and drags.
public struct HeatMapCell: View {
    /// The value of the cell.
    let value: Double
    /// The row index of the cell.
    let row: Int
    /// The column index of the cell.
    let column: Int
    /// The heat map grid to which the cell belongs.
    let grid: HeatMapGrid

    @Binding var selectedRow: Int?
    @Binding var selectedColumn: Int?

    /// A Boolean value indicating whether the cell is currently selected.
    var isSelected: Bool {
        selectedRow == row && selectedColumn == column
    }

    /// The body of the view.
    public var body: some View {
        Rectangle()
            .fill(Color.accentColor.opacity(value))
            .frame(width: 20, height: 20)
            .border(isSelected ? Color.primary : Color.clear, width: 2)
            .onTapGesture {
                toggleSelection()
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        updateSelection(with: value)
                    }
                    .onEnded { _ in
                        resetSelection()
                    }
            )
            .scaleEffect(isSelected ? 1.2 : 1.0)
            .animation(.easeInOut(duration: 0.2))
    }

    private func toggleSelection() {
        if isSelected {
            selectedRow = nil
            selectedColumn = nil
        } else {
            selectedRow = row
            selectedColumn = column
        }
    }

    private func updateSelection(with value: DragGesture.Value) {
        let location = value.location
        let gridSize = CGSize(width: 20 * grid.columns, height: 20 * grid.rows)
        let cellWidth = gridSize.width / CGFloat(grid.columns)
        let cellHeight = gridSize.height / CGFloat(grid.rows)

        let row = min(max(Int(location.y / cellHeight), 0), grid.rows - 1)
        let column = min(max(Int(location.x / cellWidth), 0), grid.columns - 1)

        selectedRow = row
        selectedColumn = column
    }

    private func resetSelection() {
        selectedRow = nil
        selectedColumn = nil
    }
}
