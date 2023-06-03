//
//  File.swift
//
//
//  Created by Ranga Reddy Nukala on 31/05/23.
//

import Foundation

/// Represents different place types.
///
/// The `Place` enumeration provides a set of predefined place types such as home, work, school, park, restaurant, gym, and other.
/// It conforms to `String`, `CaseIterable`, and `Identifiable` protocols.
public enum Place: String, CaseIterable, Identifiable {
    /// The unique identifier of the place.
    public var id: String { self.rawValue }

    /// The home place type.
    case home

    /// The work place type.
    case work

    /// The school place type.
    case school

    /// The park place type.
    case park

    /// The restaurant place type.
    case restaurant

    /// The gym place type.
    case gym

    /// The other place type.
    case other

    // Add more place types as needed
}
