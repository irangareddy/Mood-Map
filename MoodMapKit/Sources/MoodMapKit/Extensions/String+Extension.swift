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

extension String {
    /// Check if the string represents the current week or last week and return a string representation.
    ///
    /// - Returns: A string representing "This Week" if it is the current week, "Last Week" if it is the last week, or the original string otherwise.
    public var currentOrLastWeek: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"

        let currentDate = Date()

        let trimmedDateString = self.trimmingCharacters(in: .whitespacesAndNewlines)

        // Check if the date string contains a date range
        if trimmedDateString.contains("-") {
            dateFormatter.dateFormat = "MMM d - MMM d, yyyy"

            guard let startDateRange = trimmedDateString.range(of: "-"),
                  startDateRange.lowerBound > trimmedDateString.startIndex && startDateRange.upperBound < trimmedDateString.endIndex else {
                return self
            }

            let startDateString = trimmedDateString[..<startDateRange.lowerBound].trimmingCharacters(in: .whitespacesAndNewlines)
            let endDateString = trimmedDateString[startDateRange.upperBound...].trimmingCharacters(in: .whitespacesAndNewlines)

            guard let startDate = dateFormatter.date(from: String(startDateString)),
                  let endDate = dateFormatter.date(from: String(endDateString)) else {
                return self
            }

            let calendar = Calendar.current

            let currentWeekStartDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate))
            let currentWeekEndDate = calendar.date(byAdding: .weekOfYear, value: 1, to: currentWeekStartDate!)

            let previousWeekStartDate = calendar.date(byAdding: .weekOfYear, value: -1, to: currentWeekStartDate!)
            let previousWeekEndDate = calendar.date(byAdding: .weekOfYear, value: -1, to: currentWeekEndDate!)

            if startDate >= currentWeekStartDate! && endDate <= currentWeekEndDate! {
                return "This Week"
            } else if startDate >= previousWeekStartDate! && endDate <= previousWeekEndDate! {
                return "Last Week"
            } else {
                return self
            }
        }
        // Check if the date string is in the format "MMM d, yyyy"
        else {
            guard let date = dateFormatter.date(from: trimmedDateString) else {
                return self
            }

            let calendar = Calendar.current

            let currentWeekStartDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate))
            let currentWeekEndDate = calendar.date(byAdding: .weekOfYear, value: 1, to: currentWeekStartDate!)

            let previousWeekStartDate = calendar.date(byAdding: .weekOfYear, value: -1, to: currentWeekStartDate!)
            let previousWeekEndDate = calendar.date(byAdding: .weekOfYear, value: -1, to: currentWeekEndDate!)

            if date >= currentWeekStartDate! && date <= currentWeekEndDate! {
                return "This Week"
            } else if date >= previousWeekStartDate! && date <= previousWeekEndDate! {
                return "Last Week"
            } else {
                return self
            }
        }
    }
}
