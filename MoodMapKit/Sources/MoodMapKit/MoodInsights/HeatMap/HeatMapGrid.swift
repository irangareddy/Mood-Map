//
//  File.swift
//
//
//  Created by Ranga Reddy Nukala on 02/06/23.
//

import Foundation

/// A data structure representing a grid for a heat map.
///
/// Use `HeatMapGrid` to represent a grid with the specified number of rows and columns,
/// and a 2D array of data values. Each element in the `data` array represents a value
/// associated with a specific cell in the grid.
public struct HeatMapGrid {
    /// The number of rows in the grid.
    public let rows: Int
    /// The number of columns in the grid.
    public let columns: Int
    /// The 2D array of data values representing the grid.
    public var data: [[Double]]

    /// Initializes a `HeatMapGrid` instance with the specified number of rows, columns, and data.
    ///
    /// - Parameters:
    ///   - rows: The number of rows in the grid.
    ///   - columns: The number of columns in the grid.
    ///   - data: The 2D array of data values representing the grid.
    public init(rows: Int, columns: Int, data: [[Double]]) {
        self.rows = rows
        self.columns = columns
        self.data = data
    }
}
