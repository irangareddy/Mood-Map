//
//  MoodEntryDetailView.swift
//  Mood-Map
//
//  Created by Ranga Reddy Nukala on 12/06/23.
//

import SwiftUI
import MoodMapKit

struct MoodEntryDetailView: View {
    @ObservedObject var moodViewModel = MoodViewModel.shared
    @Environment(\.colorScheme) var colorScheme
    let moodEntry: MoodEntry
    @State var image: Image?
    @State var audio: Recording?
    @State private var isPresentingSheet = false
    @State var recording: Recording?

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            // Card content

            VStack(alignment: .leading, spacing: 10) {

                VStack(alignment: .leading, spacing: 10) {
                    Text("I'm feeling")
                    Text(moodEntry.moods.first?.toMood()?.name ?? Emoozee.shared.placeholderMood.name)
                        .foregroundColor(Color.red)

                }.font(.appTitle2)

                Text(moodEntry.cardDate)

                if let notes = moodEntry.notes {
                    Text(notes)
                        .multilineTextAlignment(.leading)
                }

                if moodEntry.imageId != nil {
                    if let looadedImage = image {
                        looadedImage
                            .resizable()
                            .scaledToFill()
                            .shadow(radius: 5)
                            .frame(maxWidth: .infinity)

                    }
                    Image("lavendar")
                        .resizable()
                        .frame(maxWidth: .infinity)
                        .redacted(reason: image != nil ? .placeholder : [])
                }

                if moodEntry.voiceNoteId != nil {
                       Text("Listen to Voice Note")
                        .padding()
                        .foregroundColor(.accentColor)
                        .onTapGesture {
                        isPresentingSheet.toggle()
                        }.frame(maxWidth: .infinity, alignment: .center)
                }

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
                    LargeButton(title: "Analyze Mood  🚀", disabled: true, foregroundColor: Color.black) {

                    }
                    Text("This feature is temporarily disabled.")
                        .font(.appCaption2)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                }
            }.font(.appSmallBody)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(.ultraThickMaterial)
            .onAppear {
                Task {
                    if let image = moodEntry.imageId {
                        let image = await moodViewModel.getImage(of: image)
                        self.image = image
                    }
                    if let voiceNote =  moodEntry.voiceNoteId {
                        let recording = await moodViewModel.getVoiceNote(of: voiceNote)
                        self.recording = recording
                        debugPrint(recording)
                    }

                }
            }
            .sheet(isPresented: $isPresentingSheet) {
                if let recording = recording {
                    MusicControllerView(recording: recording)
                }

        }

        }

    }
}

struct MoodEntryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        @ObservedObject var placehoder = PlaceholderData()
        MoodEntryDetailView(moodEntry: placehoder.moodEntries.first!)

    }
}
