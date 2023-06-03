//
//  File.swift
//
//
//  Created by Ranga Reddy Nukala on 02/06/23.
//

import Foundation

/// An extension that adds a computed property to `String` for extracting an emoji character.
extension String {

    /// Returns the emoji character represented by the string, if it exists.
    ///
    /// This property attempts to convert the string to its corresponding UTF-16 data representation and
    /// extract a Unicode scalar from it. If successful, the Unicode scalar is converted back to a `String`
    /// representation, which represents the emoji character.
    ///
    /// - Returns: The emoji character represented by the string, or `nil` if the string does not contain
    ///   a valid emoji.
    ///
    /// - Note: The emoji character will be returned as a single string, even if it consists of multiple
    ///   Unicode scalars.
    ///
    /// - SeeAlso: `UnicodeScalar`
    var emoji: String? {
        guard let data = self.data(using: .utf16),
              let scalar = UnicodeScalar(data.withUnsafeBytes { $0.load(as: UInt16.self) })
        else {
            return nil
        }
        return String(scalar)
    }
}
