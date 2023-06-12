//
//  MoodEntry.swift
//
//
//  Created by Ranga Reddy Nukala on 29/05/23.
//

import Foundation

public func getMoodNames(moods: [Mood]) -> [String] {
    let moodNames = moods.map { $0.name }
    return moodNames
}


/// Represents a mood entry.
///
/// A `MoodEntry` consists of various properties such as id, mood, timestamp, picture data, audio data, notes, place, exercise hours, sleep hours, and weather.
/// It conforms to `Equatable`, `Codable`, `Hashable`, and `Identifiable` protocols.
public struct MoodEntry: Equatable, Codable, Hashable, Identifiable {
    /// The unique identifier of the mood entry.
    public let id = UUID()

    /// The mood associated with the entry.
    public let moods: [String]

    /// The timestamp of the entry.
    public let timestamp: String

    /// The picture data associated with the entry.
    public var imageId: String?

    /// The audio data associated with the entry.
    public var voiceNoteId: String?

    /// The additional notes for the entry.
    public var notes: String?

    /// The place associated with the entry.
    public var place: String?

    /// The hours of exercise recorded for the entry.
    public var exerciseHours: Double?

    /// The hours of sleep recorded for the entry.
    public var sleepHours: Double?

    /// The weather condition recorded for the entry.
    public var weather: String?
    
    /// Initializes a new MoodEntry instance.
    ///
    /// - Parameters:
    ///   - mood: The mood associated with the entry.
    ///   - timestamp: The timestamp of the entry.
    ///   - imageId: The picture data associated with the entry.
    ///   - voiceNoteId: The audio data associated with the entry.
    ///   - notes: The additional notes for the entry.
    ///   - place: The place associated with the entry.
    ///   - exerciseHours: The hours of exercise recorded for the entry.
    ///   - sleepHours: The hours of sleep recorded for the entry.
    ///   - weather: The weather condition recorded for the entry.
    public init(moods: [Mood], timestamp: Date, imageId: String?, voiceNoteId: String?, notes: String?, place: Place?, exerciseHours: Double?, sleepHours: Double?, weather: Weather?) {
        self.moods = getMoodNames(moods: moods)
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        self.timestamp = formatter.string(from: timestamp)
        self.imageId = imageId
        self.voiceNoteId = voiceNoteId
        self.notes = notes
        self.place = place?.rawValue
        self.exerciseHours = exerciseHours
        self.sleepHours = sleepHours
        self.weather = weather?.rawValue
    }
    
    public init(moods: [Mood], timestamp: Date) {
        self.moods = getMoodNames(moods: moods)
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        self.timestamp = formatter.string(from: timestamp)
    }

    public enum CodingKeys: String, CodingKey {
        case id = "id"
        case moods = "moods"
        case timestamp = "timestamp"
        case imageId = "imageId"
        case voiceNoteId = "voiceNoteId"
        case notes = "notes"
        case place = "place"
        case exerciseHours = "exerciseHours"
        case sleepHours = "sleepHours"
        case weather = "weather"
    }
    
    public func encode(to encoder: Encoder) throws {
           var container = encoder.container(keyedBy: CodingKeys.self)
           try container.encode(id, forKey: .id)
           try container.encode(moods, forKey: .moods)
           try container.encode(timestamp, forKey: .timestamp)
           try container.encodeIfPresent(imageId, forKey: .imageId)
           try container.encodeIfPresent(voiceNoteId, forKey: .voiceNoteId)
           try container.encodeIfPresent(notes, forKey: .notes)
        try container.encodeIfPresent(place, forKey: .place)
           try container.encodeIfPresent(exerciseHours, forKey: .exerciseHours)
           try container.encodeIfPresent(sleepHours, forKey: .sleepHours)
            try container.encodeIfPresent(weather, forKey: .weather)
       }
    
    public init(from decoder: Decoder) throws {
           let container = try decoder.container(keyedBy: CodingKeys.self)
           moods = try container.decode([String].self, forKey: .moods)
           timestamp = try container.decode(String.self, forKey: .timestamp)
           imageId = try container.decodeIfPresent(String.self, forKey: .imageId)
           voiceNoteId = try container.decodeIfPresent(String.self, forKey: .voiceNoteId)
           notes = try container.decodeIfPresent(String.self, forKey: .notes)
        place = try container.decodeIfPresent(String.self, forKey: .place)
           exerciseHours = try container.decodeIfPresent(Double.self, forKey: .exerciseHours)
           sleepHours = try container.decodeIfPresent(Double.self, forKey: .sleepHours)
            weather = try container.decodeIfPresent(String.self, forKey: .weather)
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

            return weekdaySymbol 
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
