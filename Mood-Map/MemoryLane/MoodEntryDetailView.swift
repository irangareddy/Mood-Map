//
//  MoodEntryDetailView.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 12/06/23.
//

import SwiftUI
import MoodMapKit

struct MoodEntryDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    let moodEntry: MoodEntry

    var body: some View {
        ZStack {
            // Card content

            VStack(alignment: .leading, spacing: 10) {

                VStack(alignment: .leading, spacing: 10) {
                    Text("I'm feeling")

                    Text(moodEntry.moods.first?.toMood()?.name ?? Emoozee.shared.placeholderMood.name)
                        .foregroundColor(Color.red)

                }.font(.appTitle)

                Divider()

                Text(moodEntry.cardDate)
                    .font(.appBody)

                Divider()
                if let notes = moodEntry.notes {
                    Text(notes)
                }

                Image("lavender")
                    .resizable()
                    .scaledToFill()
                    .shadow(radius: 5)
                    .frame(maxWidth: .infinity)

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
                Spacer()
                VStack {
                    Text("Tap to analyze your mood notes and get more insights")
                        .font(.appCaption)
                    Button(action: {
                        // Add action for the button here

                    }) {
                        RoundedRectangle(cornerRadius: 100).frame(height: 60)
                            .overlay {
                                Text("Analyze Mood  🚀")
                                    .font(.appLargeBody)
                                    .foregroundColor(.white)
                            }
                    }
                }.frame(maxWidth: .infinity, maxHeight: .infinity)

            } .font(.appBody)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(.ultraThickMaterial)

            .onAppear(perform: {
                debugPrint(moodEntry)
            })

        }

    }
}

struct MoodEntryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        @ObservedObject var placehoder = PlaceholderData()
        MoodEntryDetailView(moodEntry: placehoder.moodEntries.first!)

    }
}
