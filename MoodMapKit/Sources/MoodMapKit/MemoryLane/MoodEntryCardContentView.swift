//
//  File.swift
//
//
//  Created by Ranga Reddy Nukala on 02/06/23.
//

import Foundation
import SwiftUI

struct MoodEntryCardContentView: View {
    let moodEntry: MoodEntry

    var body: some View {
        ZStack {
            // Card content
            VStack(spacing: 10) {
                HStack {
                    Text("\(moodEntry.mood.name)")
                        .font(.title3)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 10)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    Spacer() // Distribute space evenly
                    Text(moodEntry.date, style: .time)
                        .font(.caption)
                }
                HStack {
                    if let place = moodEntry.place {
                        Image(systemName: "location.fill")
                            .font(.subheadline)
                        Text(place.capitalized)
                            .font(.caption)
                    }
                    Spacer() // Distribute space evenly
                    if let weather = moodEntry.weather {
                        Image(systemName: "cloud.fill")
                            .font(.subheadline)
                        Text(weather.capitalized)
                            .font(.caption)
                    }
                }

                HStack {
                    if let exerciseHours = moodEntry.exerciseHours {
                        Image(systemName: "figure.walk")
                        Text("\(exerciseHours.description.capitalized) hrs")
                            .font(.caption)
                    }
                    Spacer() // Distribute space evenly
                    if let sleepHours = moodEntry.sleepHours {
                        Image(systemName: "bed.double.fill")
                            .font(.subheadline)
                        Text("\(sleepHours.description) hrs")
                            .font(.caption)
                    }
                }
            }
            .padding()
            .background(getCategoryColor(for: moodEntry.mood.category))
            .cornerRadius(10)
            .shadow(radius: 5)
        }
    }
}
