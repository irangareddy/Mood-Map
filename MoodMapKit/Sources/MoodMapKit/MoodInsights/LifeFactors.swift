//
//  LifeFactors.swift
//
//
//  Created by Ranga Reddy Nukala on 06/06/23.
//

import Foundation

/// Represents various life factors that might influence an individual's mood.
///
/// LifeFactors is an enum that lists different factors that could potentially
/// influence a person's mood. This could include factors like exercise, sleep,
/// place, and weather. Each factor has a display name that is a capitalized
/// version of the case name.
///
/// - Note: More factors can be added as needed.
///
/// - Important: This enum conforms to `CaseIterable`, `Hashable`, and `Identifiable` protocols. Each case's `rawValue` is used as its unique identifier (`id`).
public enum LifeFactors: String, CaseIterable, Hashable, Identifiable {
    /// The unique identifier of the life factor. Derived from the `rawValue` of each case.
    public var id: String {
        self.rawValue
    }

    /// Represents the factor of exercise.
    case exercise

    /// Represents the factor of sleep.
    case sleep

    /// Represents the factor of place or location.
    case place

    /// Represents the factor of weather.
    case weather
    // Add more cases as needed

    /// The display name of the life factor. It is a capitalized version of the case name.
    public var displayName: String {
        return "\(self)".capitalized
    }
}
