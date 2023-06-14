//
//  Reminder.swift
//
//
//  Created by Ranga Reddy Nukala on 02/06/23.
//

import Foundation

/// A struct representing a reminder.
///
/// Use the `Reminder` struct to store information about a reminder, including its unique identifier, time string, editing status, time, and time of day.
public struct Reminder: Identifiable, Codable {
    /// The unique identifier of the reminder.
    public var id = UUID()

    /// The time string representing the reminder's time.
    public var timeString: String

    /// A Boolean value indicating whether the reminder is currently being edited.
    public var isEditing: Bool = false

    /// The parsed time value of the reminder.
    public var time: Time {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        guard let date = formatter.date(from: timeString) else {
            // Default to current time if conversion fails
            return Time(date: Date())
        }
        return Time(date: date)
    }

    /// The time of day associated with the reminder's time.
    public var timeOfDay: TimeOfDay {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour], from: time.date)
        if let hour = components.hour {
            switch hour {
            case 6..<12:
                return .morning
            case 12..<18:
                return .afternoon
            case 18..<22:
                return .evening
            default:
                return .night
            }
        }
        return .morning
    }
}
