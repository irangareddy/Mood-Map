//
//  File.swift
//
//
//  Created by Ranga Reddy Nukala on 02/06/23.
//

import Foundation
import SwiftUI
import MoodMapKit

struct MoodEntryCardContentView: View {
    @Environment(\.colorScheme) var colorScheme
    let moodEntry: MoodEntry

    var body: some View {
        ZStack {
            // Card content
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("I'm feeling")

                    Text(moodEntry.moods.first?.toMood()?.name ?? Emoozee.shared.placeholderMood.name)

                }.font(.appTitle3)

                Text(moodEntry.cardDate)
                    .font(.caption)
                HStack {
                    if let place = moodEntry.place {
                        Image(systemName: "location.fill.viewfinder")
                            .font(.headline)
                        Text(place.capitalized)

                    }
                    Spacer() // Distribute space evenly
                    if let weather = moodEntry.weather {
                        Image(systemName: "cloud.fill")
                            .font(.headline)
                        Text(weather.capitalized)
                    }
                }

                HStack {
                    if let exerciseHours = moodEntry.exerciseHours {
                        Image(systemName: "figure.walk")
                            .font(.headline)
                        Text("\(exerciseHours.description.capitalized) hrs")
                    }
                    Spacer() // Distribute space evenly
                    if let sleepHours = moodEntry.sleepHours {
                        Image(systemName: "bed.double.fill")
                            .font(.headline)
                        Text("\(sleepHours.description) hrs")
                    }
                }
            } .font(.appBody)
            .padding()
            //                .frame(width: geometry.size.width*0.7, height: geometry.size.height/4)
            .background(.ultraThinMaterial)
            .background(getMoodCategoryColorMine(for: MoodCategory(rawValue: (moodEntry.moods.first?.toMood()?.category)!.rawValue) ?? .lowEnergyPleasant))                .cornerRadius(10)
            .shadow(radius: 5)
        }
        .redacted(reason: moodEntry.moods.first == nil ? .placeholder : [])
    }
}

struct MoodEntryCardContentView_Previews: PreviewProvider {
    static var previews: some View {
        @Namespace var animation
        @ObservedObject var placehoder = PlaceholderData()
        MoodEntryCardContentView(moodEntry: placehoder.moodEntries.first!)

    }
}

extension String {
    func toMood() -> Mood? {
        guard let mood = Emoozee.shared.moodData.moods.first(where: { $0.name.lowercased() == self.lowercased() }) else {
            return nil
        }
        return mood
    }
}
