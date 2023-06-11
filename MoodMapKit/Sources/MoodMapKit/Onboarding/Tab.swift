//
//  Tab.swift
//
//
//  Created by Ranga Reddy Nukala on 03/06/23.
//

import Foundation

/// Represents a tab in a tab bar.
public enum Tab: String, CaseIterable, Identifiable {
    case checkIn
    case memoryLane
    case moodInsights
    case settings

    /// The unique identifier for the tab.
    public var id: String {
        return rawValue
    }

    /// The name of the Lottie animation file associated with the tab.
    public var fileName: String {
        switch self {
        case .checkIn:
            return "check-in"
        case .memoryLane:
            return "spa-flower"
        case .moodInsights:
            return "chart"
        case .settings:
            return "avatar"
        }
    }

    /// The display name of the tab.
    public var tabName: String {
        switch self {
        case .checkIn:
            return "Check In"
        case .memoryLane:
            return "Memory Lane"
        case .moodInsights:
            return "Insights"
        case .settings:
            return "Account"
        }
    }
}

public enum MoodMapAnimatedIcons: String, CaseIterable, Identifiable {
    /// The unique identifier for the tab.
    public var id: String {
        return rawValue
    }

    case microphoneRecording
    case memoryLane
    case moodInsights
    case settings
    case speaker

    /// The name of the Lottie animation file associated with the tab.
    public var fileName: String {
        switch self {
        case .speaker:
            return "speaker"
        case .microphoneRecording:
            return "microphone-recording"
        case .memoryLane:
            return "spa-flower"
        case .moodInsights:
            return "chart"
        case .settings:
            return "avatar"
        }
    }
}
