//
//  ScatterPlotView.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 31/05/23.
//

import SwiftUI
import Charts

/// A data structure representing mood exits with their associated properties.
///
/// Use `MoodExits` to represent a mood exit with its unique identifier, mood name, intensity level, and happiness level.
/// It conforms to the `Identifiable` protocol, allowing easy identification and usage in SwiftUI views.
public struct MoodExits: Identifiable {
    /// The unique identifier for the mood exit.
    public let id = UUID()
    /// The name of the mood.
    public let mood: String
    /// The intensity level of the mood exit.
    public let intensity: Int
    /// The happiness level of the mood exit.
    public let happiness: Int

    /// Initializes a `MoodExits` instance with the given mood, intensity, and happiness values.
    ///
    /// - Parameters:
    ///   - mood: The name of the mood.
    ///   - intensity: The intensity level of the mood exit.
    ///   - happiness: The happiness level of the mood exit.
    public init(mood: String, intensity: Int, happiness: Int) {
        self.mood = mood
        self.intensity = intensity
        self.happiness = happiness
    }
}

/// A view that visually presents mood data in a scatter plot.
///
/// Use `ScatterPlotView` to create a view that displays mood data in a scatter plot.
/// It allows users to compare intensity and happiness levels across different moods,
/// identify emotional patterns, and explore the emotional aspects of each mood.
public struct ScatterPlotView: View {
    var moodEntries: [MoodExits] = [
        // Mood entry data
    ]

    /// The body view of the ScatterPlotView.
    public var body: some View {
        ScrollView(showsIndicators: false) {
            Text("The ScatterPlotView visually presents mood data, allowing users to compare intensity and happiness levels across different moods, identify emotional patterns, and explore the emotional aspects of each mood.")
                .font(.appBody)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.bottom)

            Chart(moodEntries) {
                PointMark(
                    x: .value("Intensity", $0.intensity),
                    y: .value("Happiness", $0.happiness)
                )
                .foregroundStyle(by: .value("Mood", $0.mood))
                .symbol(by: .value("Mood", $0.mood))
            }.frame(height: 300)

            Divider()

            if let highestHappiness = moodEntries.max(by: { $0.happiness < $1.happiness }) {
                Text("Highest Happiness:")
                    .font(.headline)
                Text("Mood: \(highestHappiness.mood)")
                Text("Intensity: \(highestHappiness.intensity)")
                Text("Happiness: \(highestHappiness.happiness)")
            }

            if let lowestHappiness = moodEntries.min(by: { $0.happiness < $1.happiness }) {
                Text("Lowest Happiness:")
                    .font(.headline)
                Text("Mood: \(lowestHappiness.mood)")
                Text("Intensity: \(lowestHappiness.intensity)")
                Text("Happiness: \(lowestHappiness.happiness)")
            }

            Divider()

            if let highestIntensity = moodEntries.max(by: { $0.intensity < $1.intensity }) {
                Text("Highest Intensity:")
                    .font(.headline)
                Text("Mood: \(highestIntensity.mood)")
                Text("Intensity: \(highestIntensity.intensity)")
                Text("Happiness: \(highestIntensity.happiness)")
            }

            if let lowestIntensity = moodEntries.min(by: { $0.intensity < $1.intensity }) {
                Text("Lowest Intensity:")
                    .font(.headline)
                Text("Mood: \(lowestIntensity.mood)")
                Text("Intensity: \(lowestIntensity.intensity)")
                Text("Happiness: \(lowestIntensity.happiness)")
            }

            Spacer()

            Group {
                Text("Happiness: Happiness represents an individual's overall positive emotional state and well-being. It reflects feelings of joy, contentment, and satisfaction with life. Higher happiness values indicate a greater sense of happiness and well-being.")

                Text("Intensity: Intensity refers to the level of emotional intensity or energy associated with a mood. It represents the strength or magnitude of the emotional experience. Higher intensity values suggest stronger and more powerful emotional states.")

                Text("Note: The insights provided are based on the available data.")
            }
            .font(.appCaption)
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
            .padding(.bottom)
        }
        .padding()
    }
}

struct ScatterPlotView_Previews: PreviewProvider {
    static var previews: some View {
        ScatterPlotView()
    }
}
