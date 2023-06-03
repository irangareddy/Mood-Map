//
//  File.swift
//
//
//  Created by Ranga Reddy Nukala on 02/06/23.
//

import Foundation

/// Represents different categories of mood.
///
/// The `MoodCategory` enum provides options to categorize moods based on their energy level and pleasantness. Each category represents a specific combination of energy and pleasantness, allowing for a more detailed classification of moods. The enum is designed to be used in conjunction with mood-related data and can help organize and analyze mood-related information effectively.
///
/// - Note: For more information about mood categories, you can refer to [Google's Mood Categories](https://www.google.com).
public enum MoodCategory: String, Codable {
    /// The high energy pleasant category.
    case highEnergyPleasant = "High Energy Pleasant"

    /// The high energy unpleasant category.
    case highEnergyUnpleasant = "High Energy Unpleasant"

    /// The low energy pleasant category.
    case lowEnergyPleasant = "Low Energy Pleasant"

    /// The low energy unpleasant category.
    case lowEnergyUnpleasant = "Low Energy Unpleasant"
}
