//
//  Mood.swift
//
//
//  Created by Ranga Reddy Nukala on 29/05/23.
//

import Foundation

/// Represents a mood.
///
/// A `Mood` consists of various properties such as name, category, happiness index, intensity level, emoji, and description.
/// It conforms to `Equatable`, `Codable`, `Hashable`, and `Identifiable` protocols.
///
/// - Note: The `id` property of `Mood` is derived from its `name`.
public struct Mood: Equatable, Codable, Hashable, Identifiable {
    /// The name of the mood.
    public let name: String

    /// The category of the mood.
    public let category: MoodCategory

    /// The happiness index associated with the mood.
    public let happinessIndex: Double

    /// The intensity level of the mood.
    public let intensityLevel: Int

    /// The emoji representing the mood.
    public let emoji: String

    /// The description of the mood.
    public let description: String

    /// The derived identifier of the mood, based on its name.
    public var id: String { self.name }

    /// A computed property that returns the title of the mood, combining its name and emoji.
    public var title: String {
        return "\(name) \(emoji)"
    }

    enum CodingKeys: String, CodingKey {
        case name
        case category
        case happinessIndex = "happiness_index"
        case intensityLevel = "intensity_level"
        case emoji
        case description
    }
}

/// Represents a collection of mood data.
///
/// `MoodData` is used to store and manage an array of `Mood` instances.
/// It conforms to `Equatable`, `Codable`, and `Hashable` protocols.
public struct MoodData: Equatable, Codable, Hashable {
    /// Determines the equality of two `MoodData` instances by comparing their contained moods.
    public static func == (lhs: MoodData, rhs: MoodData) -> Bool {
        return lhs.moods == rhs.moods
    }

    /// The array of moods stored within `MoodData`.
    public let moods: [Mood]
}
