//
//  File.swift
//
//
//  Created by Ranga Reddy Nukala on 02/06/23.
//

import Foundation
import SwiftUI

extension Color {

    /// Initializes a color with the provided hexadecimal value.
    ///
    /// - Parameter hex: The hexadecimal value representing the color.
    ///
    /// - Note: The hexadecimal value should be a string without any leading `#` symbol.
    ///   The initializer supports both 6-digit and 8-digit hexadecimal values.
    ///
    /// - Example:
    ///   ```
    ///   let redColor = Color(hex: "FF0000")
    ///   ```
    ///
    /// - Warning: If an invalid hexadecimal value is provided, the resulting color may not be accurate.
    ///
    /// - SeeAlso: `init(red:green:blue:)`
    public init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)

        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}
