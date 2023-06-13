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
/// and a 2D array of data values. Each element in the `data` array represents a tuple
/// with the key and value associated with a specific cell in the grid.
public struct HeatMapGrid {
    /// The number of rows in the grid.
    public let rows: Int
    /// The number of columns in the grid.
    public let columns: Int
    /// The 2D array of data values representing the grid.
    public var data: [[(key: String, value: Double)]]

    /// Initializes a `HeatMapGrid` instance with the specified number of rows, columns, and data.
    ///
    /// - Parameters:
    ///   - rows: The number of rows in the grid.
    ///   - columns: The number of columns in the grid.
    ///   - data: The 2D array of data values representing the grid.
    public init(rows: Int, columns: Int, data: [[(key: String, value: Double)]]) {
        self.rows = rows
        self.columns = columns
        self.data = data
    }
}

public func generateHeatMapGrid(from heatmapData: [String: Int]) -> HeatMapGrid? {
    print("🚀 GOT \(heatmapData)")
    // Create a DateFormatter with ISO 8601 format
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"

    // Sort the keys in ascending order based on the date
    let sortedKeys = heatmapData.keys.sorted { (key1, key2) -> Bool in
        if let date1 = dateFormatter.date(from: key1),
           let date2 = dateFormatter.date(from: key2) {
            return date1 < date2
        }
        return false
    }

    // Create an array to hold the sorted key-value pairs
    var sortedData: [(key: String, value: Double)] = []

    // Iterate through the sorted keys and populate the sorted data array
    for key in sortedKeys {
        if let value = heatmapData[key] {
            let normalizedValue = Double(value) / 10
            sortedData.append((key: key, value: normalizedValue))
        }
    }

    // Calculate the number of rows and columns
    let rowCount = 7
    let columnCount = 13

    // Create the 2D array of data
    var data: [[(key: String, value: Double)]] = Array(repeating: [], count: rowCount)

    // Insert the sorted data into the 2D array row-wise
    for (index, entry) in sortedData.enumerated() {
        let rowIndex = index % rowCount
        data[rowIndex].append(entry)
    }

    // Create the HeatMapGrid instance
    let grid = HeatMapGrid(rows: rowCount, columns: columnCount, data: data)

    // Debug statements
    print("Generated HeatMapGrid:")
    print("Rows: \(grid.rows), Columns: \(grid.columns)")
    for row in grid.data {
        print(row)
    }

    return grid
}
