//
//  MoodEntry.swift
//
//
//  Created by Ranga Reddy Nukala on 29/05/23.
//

import Foundation

/// Represents a mood entry.
///
/// A `MoodEntry` consists of various properties such as id, mood, timestamp, picture data, audio data, notes, place, exercise hours, sleep hours, and weather.
/// It conforms to `Equatable`, `Codable`, `Hashable`, and `Identifiable` protocols.
public struct MoodEntry: Equatable, Codable, Hashable, Identifiable {
    /// The unique identifier of the mood entry.
    public let id = UUID()

    /// The mood associated with the entry.
    public let mood: Mood

    /// The timestamp of the entry.
    public let timestamp: String

    /// The picture data associated with the entry.
    public var pictureData: Data?

    /// The audio data associated with the entry.
    public var audioData: Data?

    /// The additional notes for the entry.
    public var notes: String?

    /// The place associated with the entry.
    public var place: String?

    /// The hours of exercise recorded for the entry.
    public var exerciseHours: Int?

    /// The hours of sleep recorded for the entry.
    public var sleepHours: Int?

    /// The weather condition recorded for the entry.
    public var weather: String?

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case mood = "mood"
        case timestamp = "timestamp"
        case pictureData = "pictureData"
        case audioData = "audioData"
        case notes = "notes"
        case place = "place"
        case exerciseHours = "exerciseHours"
        case sleepHours = "sleepHours"
        case weather = "weather"
    }

    /// Determines the equality of two `MoodEntry` instances by comparing their IDs.
    public static func == (lhs: MoodEntry, rhs: MoodEntry) -> Bool {
        return lhs.id == rhs.id
    }

    /// Generates a hash value for the `MoodEntry` based on its ID.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    /// The date associated with the mood entry.
    public var date: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"

        if let date = formatter.date(from: timestamp) {
            return date
        } else {
            // Return a default date or handle the error case
            return Date() // Default value is the current date and time
        }
    }

    /// The weekday associated with the mood entry.
    public var weekday: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"

        if let date = formatter.date(from: timestamp) {
            let calendar = Calendar.current
            let weekdayNumber = calendar.component(.weekday, from: date)

            let weekdaySymbol = calendar.weekdaySymbols[weekdayNumber - 1].capitalizedFirstLetter()

            return weekdaySymbol ?? "Unknown"
        }

        return "Unknown"
    }

    /// The user-friendly representation of the date in short format.
    public var userFriendlyDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none

        return formatter.string(from: date)
    }
}

// Helper extension to capitalize the first letter of a string
extension String {
    func capitalizedFirstLetter() -> String {
        guard let firstLetter = self.first else {
            return self
        }
        return firstLetter.uppercased() + self.dropFirst()
    }
}
