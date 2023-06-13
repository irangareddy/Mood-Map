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

    public init(value: Double, row: Int, column: Int, grid: HeatMapGrid, selectedRow: Binding<Int?>, selectedColumn: Binding<Int?>) {
        self.value = value
        self.row = row
        self.column = column
        self.grid = grid
        self._selectedRow = selectedRow
        self._selectedColumn = selectedColumn
    }

    var isSelected: Bool {
        selectedRow == row && selectedColumn == column
    }

    public var body: some View {
        RoundedRectangle(cornerRadius: 4.0)
            .fill(value == 0 ? Color.secondary.opacity(0.2) : Color.accentColor.opacity(value))
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

struct HeatMapCell_Previews: PreviewProvider {
    static var previews: some View {
        let grid = HeatMapGrid(rows: 5, columns: 5, data: [[(key: "2023-01-01", value: 0.2)]])
        let selectedRow = Binding<Int?>(get: { nil }, set: { _ in })
        let selectedColumn = Binding<Int?>(get: { nil }, set: { _ in })

        return Group {
            HeatMapCell(value: 0.2, row: 0, column: 0, grid: grid, selectedRow: selectedRow, selectedColumn: selectedColumn)
            HeatMapCell(value: 0.2, row: 0, column: 0, grid: grid, selectedRow: selectedRow, selectedColumn: selectedColumn)
                .preferredColorScheme(.dark)
        }.previewLayout(.sizeThatFits)
    }
}
