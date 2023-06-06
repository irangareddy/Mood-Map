//
//  MoodInsights+Helper.swift
//
//
//  Created by Ranga Reddy Nukala on 04/06/23.
//

import Foundation

/// Retrieves a random string based on the streak status.
///
/// - Parameters:
///   - days: The number of days for which the streak has been maintained. Use `nil` to indicate a missed streak.
/// - Returns: A randomly selected string based on the streak status.
public func getRandomStreakString(days: Int?) -> String {
    let missedStreakMessages = [
        "Oops! 😅 You missed a day of mood tracking. Let's get back on track!",
        "Don't worry, everyone has off days. Resume your mood entries and regain your streak! 💪",
        "Life can be unpredictable. Keep going, and don't let a missed day discourage you! 🌈",
        "Sometimes a break is needed. Pick up where you left off and continue your streak! 🔥",
        "One missed day won't define your progress. Start fresh and continue your mood tracking! ✨",
        "Don't dwell on the past. Embrace the present and continue your streak of mood entries! 🌟",
        "A missed day is an opportunity for a fresh start. Resume your mood tracking journey! 🚀",
        "We all have setbacks. Keep up the momentum and continue your mood entries! 💫",
        "Missing a day happens. Get back on track and continue your streak of mood tracking! 💥",
        "Remember, progress is not always linear. Keep going and continue your mood entries! 📈"
    ]

    let normalStreakMessages = [
        "You've been recording your mood for a streak of [X] consecutive days! 🎉",
        "Celebrate your [X]-day streak of capturing your emotions! 🥳",
        "Keep up the momentum! You've logged your mood for [X] days in a row and maintained your streak! 💯",
        "Maintain your emotional journey with a streak of [X] days of mood tracking! 🌻",
        "Uncover patterns in your emotions over a streak of [X] consistent entries! 🔍",
        "Track your mood every day for a streak of [X] days to gain valuable insights! 📊",
        "You're doing great! Keep up the streak of [X] days capturing your emotions and counting! 👏",
        "Explore your [X]-day streak of mood entries to better understand your emotional well-being! 🧐",
        "Stay committed to tracking your mood for a streak of [X] consecutive days! 🗓️",
        "Congratulations on your streak of [X] actively recording your emotions! 🎊",
        "Your mood matters! Maintain your streak of [X] days of consistent tracking and counting! ❤️",
        "Keep your emotions in focus with a streak of [X] days of mood entries! 🎯",
        "Make your emotions count! Dedicate yourself to a streak of [X] days of mood tracking! 📝",
        "Unlock the power of self-reflection with a streak of [X] days of mood logging! 🔓",
        "Every day brings new insights! Continue your streak of [X] days tracking your emotions! 🌈",
        "Stay in tune with your feelings for a streak of [X] consecutive days! 🎶",
        "Your mood journey continues! You're on a streak of [X] days and counting! 🚶",
        "Discover the patterns in your emotions over a streak of [X] days of tracking! 🔄",
        "Make a positive impact on your well-being with a streak of [X] days of mood entries! 🌞",
        "Celebrate your emotional growth! Maintain your streak of [X] days of mood tracking! 🌱"
    ]

    let messages = days == nil ? missedStreakMessages : normalStreakMessages

    let index = Int.random(in: 0..<messages.count)

    if let days = days {
        let message = messages[index].replacingOccurrences(of: "[X]", with: "\(days)")
        return message
    } else {
        return messages[index]
    }
}

/// A utility class for generating a list of weeks within a specified range of years.
public class WeekListGenerator {
    /// Generates a list of weeks from the start year to the current date.
    ///
    /// - Parameters:
    ///   - startYear: The start year for generating the week list.
    /// - Returns: An array of strings representing the weeks.
    public static func generateWeekList(startYear: Int) -> [String] {
        let dateFormatterWithYear = DateFormatter()
        dateFormatterWithYear.dateFormat = "MMM d, yyyy"

        let dateFormatterWithoutYear = DateFormatter()
        dateFormatterWithoutYear.dateFormat = "MMM d"

        var weekList: [String] = []

        let calendar = Calendar.current
        let currentDate = Date()

        var startDateComponents = DateComponents()
        startDateComponents.year = startYear
        startDateComponents.weekOfYear = 1

        guard let startDate = calendar.date(from: startDateComponents) else {
            return weekList
        }

        var currentDateValue = startDate
        while currentDateValue <= currentDate {
            let weekStartDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDateValue))

            let weekEndDateComponents = DateComponents(weekday: 7)
            let weekEndDate = calendar.nextDate(after: weekStartDate!, matching: weekEndDateComponents, matchingPolicy: .nextTime)

            if let weekStartDate = weekStartDate, let weekEndDate = weekEndDate {
                let formattedStartDate = dateFormatterWithoutYear.string(from: weekStartDate)
                let formattedEndDate = dateFormatterWithYear.string(from: weekEndDate)

                let weekString = "\(formattedStartDate) - \(formattedEndDate)"
                weekList.append(weekString)
            }

            currentDateValue = calendar.date(byAdding: .weekOfYear, value: 1, to: currentDateValue)!
        }

        if let currentDateInWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate)) {
            let formattedCurrentWeek = dateFormatterWithYear.string(from: currentDateInWeek)
            weekList.append(formattedCurrentWeek)
        }

        return weekList.reversed()
    }

    /// Check if the given date string represents the current week.
    /// - Parameter dateString: The date string to check.
    /// - Returns: `true` if the date string represents the current week, `false` otherwise.
    public static func isCurrentWeek(dateString: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"

        let currentDate = Date()

        let trimmedDateString = dateString.trimmingCharacters(in: .whitespacesAndNewlines)

        // Check if the date string contains a date range
        if trimmedDateString.contains("-") {
            dateFormatter.dateFormat = "MMM d - MMM d, yyyy"

            guard let startDateRange = trimmedDateString.range(of: "-"),
                  startDateRange.lowerBound > trimmedDateString.startIndex && startDateRange.upperBound < trimmedDateString.endIndex else {
                return false
            }

            let startDateString = trimmedDateString[..<startDateRange.lowerBound].trimmingCharacters(in: .whitespacesAndNewlines)
            let endDateString = trimmedDateString[startDateRange.upperBound...].trimmingCharacters(in: .whitespacesAndNewlines)

            guard let startDate = dateFormatter.date(from: String(startDateString)),
                  let endDate = dateFormatter.date(from: String(endDateString)) else {
                return false
            }

            let calendar = Calendar.current

            let currentWeekStartDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate))
            let currentWeekEndDate = calendar.date(byAdding: .weekOfYear, value: 1, to: currentWeekStartDate!)

            return startDate >= currentWeekStartDate! && endDate <= currentWeekEndDate!
        }
        // Check if the date string is in the format "MMM d, yyyy"
        else {
            guard let date = dateFormatter.date(from: trimmedDateString) else {
                return false
            }

            let calendar = Calendar.current

            let currentWeekStartDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate))
            let currentWeekEndDate = calendar.date(byAdding: .weekOfYear, value: 1, to: currentWeekStartDate!)

            return date >= currentWeekStartDate! && date <= currentWeekEndDate!
        }
    }

    /// Check if the given date string represents the last week.
    /// - Parameter dateString: The date string to check.
    /// - Returns: `true` if the date string represents the last week, `false` otherwise.
    public static func isLastWeek(dateString: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"

        let currentDate = Date()

        let trimmedDateString = dateString.trimmingCharacters(in: .whitespacesAndNewlines)

        // Check if the date string contains a date range
        if trimmedDateString.contains("-") {
            dateFormatter.dateFormat = "MMM d - MMM d, yyyy"

            guard let startDateRange = trimmedDateString.range(of: "-"),
                  startDateRange.lowerBound > trimmedDateString.startIndex && startDateRange.upperBound < trimmedDateString.endIndex else {
                return false
            }

            let startDateString = trimmedDateString[..<startDateRange.lowerBound].trimmingCharacters(in: .whitespacesAndNewlines)
            let endDateString = trimmedDateString[startDateRange.upperBound...].trimmingCharacters(in: .whitespacesAndNewlines)

            guard let startDate = dateFormatter.date(from: String(startDateString)),
                  let endDate = dateFormatter.date(from: String(endDateString)) else {
                return false
            }

            let calendar = Calendar.current

            let lastWeekStartDate = calendar.date(byAdding: .weekOfYear, value: -1, to: currentDate)
            let lastWeekEndDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: lastWeekStartDate!))

            return startDate >= lastWeekStartDate! && endDate <= lastWeekEndDate!
        }
        // Check if the date string is in the format "MMM d, yyyy"
        else {
            guard let date = dateFormatter.date(from: trimmedDateString) else {
                return false
            }

            let calendar = Calendar.current

            let lastWeekStartDate = calendar.date(byAdding: .weekOfYear, value: -1, to: currentDate)
            let lastWeekEndDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: lastWeekStartDate!))

            return date >= lastWeekStartDate! && date <= lastWeekEndDate!
        }
    }

}
