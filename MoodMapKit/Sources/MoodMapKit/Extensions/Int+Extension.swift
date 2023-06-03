//
//  File.swift
//
//
//  Created by Ranga Reddy Nukala on 02/06/23.
//

import Foundation

/// An extension that adds a convenience initializer to `Int` for converting a `CGFloat` value.
extension Int {

    /// Initializes an `Int` value from a `CGFloat` value.
    ///
    /// This initializer rounds the provided `CGFloat` value to the nearest whole number and converts it
    /// to an `Int`. The rounding behavior is performed using the `rounded()` method.
    ///
    /// - Parameter value: The `CGFloat` value to convert to an `Int`.
    ///
    /// - Note: If the provided `CGFloat` value is NaN or infinite, the resulting `Int` value may be
    ///   unpredictable.
    ///
    /// - SeeAlso: `CGFloat`, `rounded()`
    init(_ value: CGFloat) {
        self = Int(value.rounded())
    }
}
