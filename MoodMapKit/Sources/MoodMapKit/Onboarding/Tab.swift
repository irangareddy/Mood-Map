//
//  Tab.swift
//  
//
//  Created by Ranga Reddy Nukala on 03/06/23.
//

import Foundation
import Lottie

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



/// Represents an animated icon associated with a tab.
public struct AnimatedIcon: Identifiable {
    /// The unique identifier of the animated icon.
    public var id: String
    
    /// The tab associated with the animated icon.
    public var tab: Tab
    
    /// The Lottie animation view for the icon.
    public var lottieView: LottieAnimationView
    
    /// Initializes an animated icon with the specified parameters.
    /// - Parameters:
    ///   - id: The unique identifier of the animated icon. Defaults to a generated UUID string.
    ///   - tab: The tab associated with the animated icon.
    ///   - lottieView: The Lottie animation view for the icon.
    public init(id: String = UUID().uuidString, tab: Tab, lottieView: LottieAnimationView) {
        self.id = id
        self.tab = tab
        self.lottieView = lottieView
    }
}
