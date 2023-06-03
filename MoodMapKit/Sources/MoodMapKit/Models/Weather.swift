//
//  File.swift
//
//
//  Created by Ranga Reddy Nukala on 31/05/23.
//

import Foundation

/// Represents different weather conditions.
///
/// `Weather` is an enumeration that includes various weather conditions such as sunny, cloudy, rainy, snowy, windy, foggy, stormy, etc.
/// It conforms to `CaseIterable` and `Identifiable` protocols.
public enum Weather: String, CaseIterable, Identifiable {
    /// The identifier of the weather condition.
    public var id: String { self.rawValue }

    /// The sunny weather condition.
    case sunny

    /// The cloudy weather condition.
    case cloudy

    /// The rainy weather condition.
    case rainy

    /// The snowy weather condition.
    case snowy

    /// The windy weather condition.
    case windy

    /// The foggy weather condition.
    case foggy

    /// The stormy weather condition.
    case stormy

    // Add more weather conditions as needed
}
