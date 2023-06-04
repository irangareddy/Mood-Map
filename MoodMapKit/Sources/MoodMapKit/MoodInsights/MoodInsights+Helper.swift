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
