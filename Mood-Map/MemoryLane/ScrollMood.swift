//
//  File.swift
//
//
//  Created by Ranga Reddy Nukala on 02/06/23.
//

import Foundation
import SwiftUI
import AppwriteModels
import MoodMapKit

/// A struct representing a scrollable mood entry.
///
/// `ScrollMood` contains properties related to a mood entry, such as the unique identifier, date, an array of mood entries,
/// an index value, a rectangle, push offset, a flag indicating whether it is the current mood entry, and a color.
/// It also provides a computed property `userFriendlyDate` that returns a user-friendly representation of the date.
///
/// - Note: `ScrollMood` conforms to `Identifiable`, allowing it to be identified uniquely.
public struct ScrollMood: Identifiable {
    /// The unique identifier for the scrollable mood entry.
    public var id: UUID

    /// The date associated with the mood entry.
    public var date: Date

    /// An array of mood entries.
    public var moods: [AppwriteModels.Document<MoodEntry>]

    /// The index value associated with the mood entry.
    public var index: Int = 0

    /// The rectangle representing the mood entry.
    public var rect: CGRect = .zero

    /// The push offset of the mood entry.
    public var pushOffset: CGFloat = 0

    /// A flag indicating whether the mood entry is the current mood.
    public var isCurrent: Bool = false

    /// The color associated with the mood entry.
    public var color: Color = .clear

    /// Initializes a `ScrollMood` instance with the provided parameters.
    /// [AppwriteModels.Document<MoodEntry>]
    /// - Parameters:
    ///   - id: The unique identifier for the mood entry.
    ///   - date: The date associated with the mood entry.
    ///   - moods: An array of mood entries.
    public init(id: UUID, date: Date, moods: [AppwriteModels.Document<MoodEntry>], index: Int) {
        self.id = id
        self.date = date
        self.moods = moods
        self.index = index
    }

    /// A user-friendly representation of the date.
    public var userFriendlyDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "MMM d"

        return formatter.string(from: date)
    }
}
